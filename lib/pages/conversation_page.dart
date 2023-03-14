import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatonline/models/conversation_models.dart';
import 'package:chatonline/pages/add_conversation.dart';
import 'package:chatonline/pages/conversation_detail_page.dart';
import 'package:chatonline/widget/image_path.dart';
import 'package:chatonline/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../function/fnc_conversation.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({ Key? key }) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  Icon actionIcon = const Icon(Icons.search);
  Widget appBarTitle = const Text('Conversations',);

  final TextEditingController _searchUserController = TextEditingController();
  String searchString = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        actions: [
          IconButton(onPressed: (){
              setState(() {
                searchConversation();
              });
            },
            icon: actionIcon,
          )
        ],
      ),
      body: conversationList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          nextScreen(context, AddConversation());
        },
        elevation: 0,
        child: const Icon(Icons.add),
      ),
    );
  }
  conversationList(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid).collection('conversations').orderBy('lastTime', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.hasData) {
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapShot.data!.docs.length,
            itemBuilder: (context, index) {

              ConversationModel conversationModel = ConversationModel.fromJson(snapShot.data!.docs[index].data() as Map<String, dynamic>);

              if(conversationModel.conName!.toLowerCase().contains(searchString.toLowerCase())){

                  return Container(
                    decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: ClipOval(
                        child: conversationModel.image!.isNotEmpty
                            ? CachedNetworkImage(
                          imageUrl: conversationModel.image!,
                          width: 48,
                          height: 48,
                        )
                            : Image.asset(
                          ImagePath.avatar,
                          width: 48,
                          height: 48,
                        ),
                      ),
                      title: Text(
                        conversationModel.conName!,
                        style: const TextStyle(fontSize: 16),
                      ),

                      onTap: () async {
                        Map<String, dynamic>? userData = await getUserData(conversationModel.cid!);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ConversationDetailPage(userInfo: userData!)));
                      },

                    ),
                  );
                }
                else{
                  return const Center();
                }

            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
  searchConversation(){
    if(this.actionIcon.icon==Icons.search){
      this.actionIcon = const Icon(Icons.close);
      this.appBarTitle = TextField(
        controller: _searchUserController,
        style: new TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.white),
          border: InputBorder.none,
          // border: OutlineInputBorder(),
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.white),
          contentPadding: EdgeInsets.fromLTRB(4, 14, 4, 0),
        ),
        onChanged: (text) {
          setState(() {
            searchString = text;
          });
        },
      );

    }
    else{
      handleSearchEnd();
    }
  }
  handleSearchEnd(){
    setState(() {
      this.appBarTitle = const Text("Add Friends");
      this.actionIcon = const Icon(Icons.search);
      searchString = '';
      _searchUserController.clear();
    });
  }
}
