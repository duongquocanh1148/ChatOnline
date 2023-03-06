import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>?> getUserData(String uid) async{
  Map<String, dynamic>? userData;
  await FirebaseFirestore.instance.collection('users')
      .doc(uid).get().then((value) async{
    userData = value.data();
  });
  return userData;
}