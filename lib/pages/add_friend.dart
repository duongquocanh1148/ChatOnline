import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatonline/models/models.dart';
import 'package:chatonline/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AddFriend extends StatefulWidget {
  const AddFriend({super.key});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  Stream? users;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        title: const Text(
          'Add Friends',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: (){
            
          }, 
          icon: const Icon(Icons.search),
          )
        ],
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          nextScreen(context, const AddFriend());
        },
        elevation: 0,
        child: const Icon(Icons.add),
      ),
    );
  }

  groupList(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users').where(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.hasData) {
          return ListView.builder(
            itemCount: snapShot.data!.docs.length,
            itemBuilder: (context, index) {
              UserModel user = UserModel.fromJson(snapShot.data!.docs[index].data() as Map<String, dynamic>);                  
              return Container(
                decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
                child: ListTile(              
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: ClipOval(
                            child: user.image!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: user.image!,
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
                    user.userName.toString(),
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