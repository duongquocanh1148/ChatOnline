// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});
  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
     
    

  Future<Map<String, dynamic>?> getUserData(String uid) async{
    Map<String, dynamic>? userData;
    await FirebaseFirestore.instance.collection('users')
        .doc(uid).get().then((value) async{
         userData = value.data();
    });
    return userData;
  }

}
