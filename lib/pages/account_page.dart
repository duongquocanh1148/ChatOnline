import 'dart:io';

import 'package:chatonline/models/user_models.dart';
import 'package:chatonline/pages/change_info_page.dart';
import 'package:chatonline/pages/change_password_page.dart';
import 'package:chatonline/pages/pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({ Key? key }) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future signOut() async {
    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(auth.currentUser!.uid)
    //     .update({
    //   'token': '',
    // });
    auth.signOut();
  }
  
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Account'),
          elevation: 0,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if(snapshot.hasData)
            {
              UserModel userModel = UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
            
            return SingleChildScrollView(
              child: Column(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
                        child: ClipOval(
                          child: userModel.image!.isNotEmpty? CachedNetworkImage(
                            imageUrl: userModel.image!,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,):
                          Image.asset(
                            'assets/images/user_img.png',
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                        ),),
                        const SizedBox(width: 8,),
                        // ignore: prefer_const_constructors
                        Text(
                          userModel.userName!,
                          style: const TextStyle(
                          color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  iconColor: Colors.blue,
                  textColor: Colors.blue,
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Update information'),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const ChangeInfoPage()));
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  iconColor: Colors.blue,
                  textColor: Colors.blue,
                  leading: const Icon(Icons.key),
                  title: const Text('Change password'),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const ChangePasswordPage()));
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  iconColor: Colors.blue,
                  textColor: Colors.blue,
                  leading: const Icon(Icons.lock),
                  title: const Text('Log out'),
                  onTap: ()async{
                    await signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const LoginPage()), (route) => false);
                  },
                ),
              ]),
            );
          }
          return const Center(
                child: CircularProgressIndicator(),
              );
          }
        ),
    );
  }
}