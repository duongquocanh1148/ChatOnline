import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatonline/models/conversation_models.dart';
import 'package:chatonline/pages/add_conversation.dart';
import 'package:chatonline/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({ Key? key }) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Conversations',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: (){
            
          }, 
          icon: const Icon(Icons.search),
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
          .doc(FirebaseAuth.instance.currentUser!.uid).collection('conversations')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.hasData) {
          return ListView.builder(
            itemCount: snapShot.data!.docs.length,
            itemBuilder: (context, index) {

              ConversationModel conversationModel = ConversationModel.fromJson(snapShot.data!.docs[index].data() as Map<String, dynamic>);

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
                                    "assets/images/user_img.png",
                                    width: 48,
                                    height: 48,
                                  ),
                          ),
                  title: Text(
                    conversationModel.conName!,
                    style: const TextStyle(fontSize: 16),
                  ),

                  onTap: () => {
                    //nextScreenReplace(context, )
                  },

                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
