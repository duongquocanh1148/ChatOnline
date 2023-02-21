import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatonline/models/user_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ChangeInfoPage extends StatefulWidget {
  const ChangeInfoPage({ Key? key }) : super(key: key);

  @override
  State<ChangeInfoPage> createState() => _ChangeInfoPageState();
}

class _ChangeInfoPageState extends State<ChangeInfoPage> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isNameValidation = true;
  bool isEmailValidation = true;

  bool validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return (regex.hasMatch(value)) ? true : false;
  }

  File? image;

  Future pickImage() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;

      final imageTemporary = File(image.path);
      setState(()=>this.image = imageTemporary);

    } on PlatformException catch(e){
      if (kDebugMode) {
        print('Failed to pick image:  $e');
      }
    }
  }
  String? imageURL;

  Future saveInfo(String imageURL) async{
    if(nameController.text.isEmpty){
      setState(() {
        isNameValidation = false;
      });   
      return;            
    }
    else{
      setState(() {
        isNameValidation = true;
      }); 
    }

    if(image !=null){
      await FirebaseStorage.instance.ref().child('users').child(FirebaseAuth.instance.currentUser!.uid).child(image.toString()).putFile(image!);

      imageURL = await FirebaseStorage.instance.ref().child('users').child(FirebaseAuth.instance.currentUser!.uid).child(image.toString()).getDownloadURL();
    }

    Map<String, dynamic> map = {
      'userName': nameController.text,
      'image': imageURL,
    };

    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update(map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Update information'),
          elevation: 0,
        ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid).get(),

        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          UserModel userModel = UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);

          nameController.text = userModel.userName!;
          emailController.text = userModel.email!;
          imageURL = userModel.image!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Center(
                child: GestureDetector(
                  onTap: (){
                    pickImage();
                  },
                  child: ClipOval(
                      child: image != null? Image.file(
                        image!,width: 128,
                        height: 128,
                        fit: BoxFit.cover,):
                      userModel.image!.isNotEmpty? CachedNetworkImage(
                        imageUrl: userModel.image!,
                        width: 128,
                        height: 128,
                        fit: BoxFit.cover,):
                      Image.asset(
                        'assets/images/user_img.png',
                        width: 128,
                        height: 128,
                        fit: BoxFit.cover,
                      ),
                    ),
                ),
              ),
              const SizedBox(height: 16,),
              TextField(
                controller: nameController,
                style: const TextStyle(fontSize: 16),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                  errorText: !isNameValidation ? "Please enter your name!" : null),
                  
                ),
              const SizedBox(height: 16,),
              TextField(
                  controller: emailController,
                  style: const TextStyle(fontSize: 16),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.mail),
                    border: const OutlineInputBorder(),
                    hintText: "Email",
                    errorText: !isEmailValidation ? "Please enter your email!" :null),
                  ),
                const SizedBox(height: 16,),
                ElevatedButton(
                  onPressed: () async {
                    await saveInfo(imageURL.toString());
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  // ignore: prefer_const_constructors
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: const Center(
                        child: Text(
                          "Save",
                          style: TextStyle(fontSize: 16),
                        )
                    ),
                  )
                ),
            ]),
          );
        }
      ),
    );
  }
}