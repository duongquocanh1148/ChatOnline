import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatonline/function/fnc_conversation.dart';
import 'package:chatonline/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class FriendRequest extends StatefulWidget {
  const FriendRequest({Key? key}) : super(key: key);

  @override
  State<FriendRequest> createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  Future acceptAddFriend(String uid) async{
    //send my info to friend list of other user
    Map<String, dynamic>? myData = await getUserData(FirebaseAuth.instance.currentUser!.uid);
    CollectionReference friends = FirebaseFirestore.instance.collection('users').doc(uid)
            .collection('friends');
    await friends.doc(FirebaseAuth.instance.currentUser!.uid).set(myData);

    //send info to my friend list
    Map<String, dynamic>? friendData = await getUserData(uid);
    friends = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('friends');
    await friends.doc(uid).set(friendData);

    await removeFriendRequest(uid);

  }

  Future removeFriendRequest(String uid) async{
    CollectionReference requests = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('requests');
    await requests.doc(uid).delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid).collection('requests').snapshots(),

      builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.hasData) {
          return ListView.builder(
            itemCount: snapShot.data!.docs.length,
            itemBuilder: (context, index) {

              UserModel request = UserModel.fromJson(snapShot.data!.docs[index].data() as Map<String, dynamic>);

              return Container(
                decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: ClipOval(
                    child: request.image!.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: request.image!,
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
                    request.userName!,
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
                        acceptAddFriend(request.userID!);
                      },
                      child: Text("Accept", style: TextStyle(color: Colors.white),),),
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
