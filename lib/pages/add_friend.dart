import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatonline/models/models.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../service/firebase_service.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({super.key});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  Stream? users;
  String? userID;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Friends',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: groupList(),
    );
  }

  groupList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('userID', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.hasData) {
          return ListView.builder(
            itemCount: snapShot.data!.docs.length,
            itemBuilder: (context, index) {
              UserModel userModel = UserModel.fromJson(
                  snapShot.data!.docs[index].data() as Map<String, dynamic>);
                  userID = userModel.userID;
              return Container(
                decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
                child: ListTile(              
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: ClipOval(
                            child: userModel.image!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: userModel.image!,
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
                    userModel.userName!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: Container(
                    width: 36,
                    height: 36.0,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(36),color:Colors.blue.shade400),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      splashRadius: 22.0,
                            onPressed: () async{                         
                             await add();     
                             print("A");                
                            }, icon:
                             const Icon(Icons.person_add,size:  18.0,),color: Colors.white,),
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
  Future add() async{
   try{
     
    CollectionReference requests = FirebaseFirestore.instance.collection('users').doc(userID).collection('requests'); 
     Map<String, dynamic>? map  = await getUserData(FirebaseAuth.instance.currentUser!.uid);
    await requests.doc(FirebaseAuth.instance.currentUser!.uid).set(map);
     //map = await getUserData(userID!);
    
   }on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ));
  }
}
Future<Map<String, dynamic>?> getUserData(String uid) async{
    Map<String, dynamic>? userData;
    await FirebaseFirestore.instance.collection('users')
        .doc(uid).get().then((value) async{
         userData = value.data();
    });
    return userData;
  }
}