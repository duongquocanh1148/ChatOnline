import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatonline/models/user_models.dart';
import 'package:chatonline/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendList extends StatefulWidget {
  const FriendList({Key? key}) : super(key: key);

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid).collection('friends').snapshots(),

      builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.hasData) {
          return ListView.builder(
            itemCount: snapShot.data!.docs.length,
            itemBuilder: (context, index) {

              UserModel friends = UserModel.fromJson(snapShot.data!.docs[index].data() as Map<String, dynamic>);

              return Container(
                decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: ClipOval(
                    child: friends.image!.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: friends.image!,
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
                    friends.userName!,
                    style: const TextStyle(fontSize: 16),
                  ),

                  onTap: () => {
                    //nextScreenReplace(context, )
                  },
                  trailing: Container(
                    width: 80.0,
                    height: 36.0,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(36),color:Colors.grey),
                    child: TextButton(
                      onPressed: () {
                        showSnackBar(context, Colors.red, "Chưa viết");
                      },
                      child: Text("Unfriend", style: TextStyle(color: Colors.white),),),
                  ),
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
