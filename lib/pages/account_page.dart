import 'dart:io';

import 'package:chatonline/pages/pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({ Key? key }) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future signOut() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({
      'token': '',
    });
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
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
                    child: ClipOval(
                      child: image != null? Image.file(
                        image!,width: 64,
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
                    
                ],
              ),
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
        ),
    );
  }
}