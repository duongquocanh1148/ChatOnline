
import 'dart:io';
import 'package:chatonline/widget/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({ Key? key }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cfpassController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool showPW = false;
  bool showCfpass = false;
  bool isEmailValidation = true;
  bool isPWValidation = true;
  bool isNameValidation = true;
  bool isConPassValidation = true;

  String id = "";
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

  Future<void> register() async{
    if(isEmailValidation && isNameValidation && isPWValidation && isConPassValidation){
      if(passwordController.text == cfpassController.text){
        try{
          await firebaseAuth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text)
          .then((value){
            setState(() {
              id = value.user!.uid;
            });            
          });
          String imageURL = '';
          if(image != null){
            await 
            FirebaseStorage.instance.ref().child('users').child(id).child(image.toString()).putFile(image!);
            imageURL = await FirebaseStorage.instance.ref().child('users').child(id).child(image.toString()).getDownloadURL();
          }
          Map<String, dynamic> map ={
            'userID' : id,
            'userName': nameController.text,
            'email': emailController.text,
            'image': imageURL.isNotEmpty?imageURL:'',
          };

          // ignore: avoid_single_cascade_in_expression_statements
          FirebaseFirestore.instance.collection('users').doc(map['userID']).set(map).then((value){
            showSnackBar(context, Colors.green, "Register successfully");
            Navigator.pop(context);
          });
        } on FirebaseAuthException catch(e){
          showSnackBar(context, Colors.red, e.message.toString());
        }
      }else{
        showSnackBar(context, Colors.red, "Password does not match");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Colors.blue
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
              child: Text(
                "Register",
                style: TextStyle(
                  color: Colors.blue, fontSize: 36, fontWeight: FontWeight.bold,
                ),
              ),),
              const SizedBox(height: 28,),
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
                      Image.asset(
                        'assets/images/user_img.png',
                        width: 128,
                        height: 128,
                        fit: BoxFit.cover,
                      ),
                    ),
                ),
              ),
              const SizedBox(height: 32,),
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
                  hintText: "Name",
                  errorText: !isNameValidation ? "Please enter your name!" : null),
                  onChanged: (text){
                    setState(() {
                      if(nameController.text.isEmpty){
                        isNameValidation = false;               
                      }else {
                          isNameValidation = true;
                        }
                    });
                  },
                  onTap: (){
                    setState(() {
                      if(nameController.text.isEmpty){
                        isNameValidation = false;
                      }
                    });
                  },
                ),
              const SizedBox(height: 12,),
              TextField(
                controller: emailController,
                style: const TextStyle(fontSize: 16),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.mail),
                  border: const OutlineInputBorder(),
                  hintText: "Email",
                  errorText: !isEmailValidation ? "Please enter your email!" :null),
                  onChanged: (text){
                    setState(() {
                      isEmailValidation = validateEmail(emailController.text);
                    });
                  },
                  onTap: (){
                    if(emailController.text.isEmpty){
                      isEmailValidation = false;
                    }
                  }
                ),
              const SizedBox(height: 12,),
              TextField(
                controller: passwordController,
                obscureText: !showPW,
                style: const TextStyle(fontSize: 16),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.send,               
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  hintText: "Password",
                  errorText: !isPWValidation ? "Please enter your password!" : null,
                  suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            showPW = !showPW;
                          });
                        },
                        child: !showPW
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      )),
                  onChanged: (text){
                    setState(() {
                      if(passwordController.text.length < 6){
                        isPWValidation = false;
                      } else {
                        isPWValidation = true;
                      }
                    });
                  },
                  onTap: (){
                    setState(() {
                      if(passwordController.text.length < 6){
                        isPWValidation = false;
                      }else {
                        isPWValidation = true;
                      }
                    });
                  },
                ),
              const SizedBox(height: 12,),
              TextField(
                controller: cfpassController,
                obscureText: !showCfpass,
                style: const TextStyle(fontSize: 16),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.send,               
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  hintText: "ConfirmPassword",
                  errorText: !isConPassValidation ? "Please enter your confirm password!" : null,
                  suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            showCfpass = !showCfpass;
                          });
                        },
                        child: !showCfpass
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      )),
                  onChanged: (text){
                    setState(() {
                      if(cfpassController.text.length < 6){
                        isConPassValidation = false;
                      } else {
                        isConPassValidation = true;
                      }
                    });
                  },
                  onTap: (){
                    setState(() {
                      if(cfpassController.text.length < 6){
                        isConPassValidation = false;
                      }else {
                        isConPassValidation = true;
                      }
                    });
                  },
                ),
              const SizedBox(height: 32,),
              ElevatedButton(
                  onPressed: () {
                    register();
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 32,
                    height: 48,
                    child: const Center(
                        child: Text(
                          "Register",
                          style: TextStyle(fontSize: 16),
                        )
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}