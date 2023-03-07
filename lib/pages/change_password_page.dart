import 'package:chatonline/pages/account_page.dart';
import 'package:chatonline/widget/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({ Key? key }) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController newPWController = TextEditingController();
  final TextEditingController cfpassController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool showPW = false;
  bool showCfpass = false;
  bool isNewPWValidation = true;
  bool isConPassValidation = true;

  Future savePassword() async{
    if(isNewPWValidation && isConPassValidation){
      if(newPWController.text == cfpassController.text){
        try {
          await FirebaseAuth.instance.currentUser!.updatePassword(newPWController.text);
          Navigator.pop(context);
        } 
        on FirebaseAuthException catch (e) {
          showSnackBar(context, Colors.red, e.message.toString());
        }
      }
      else{
        showSnackBar(context, Colors.red, "Password does not match");
      }
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Change Password'),
          elevation: 0,
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
            TextField(
              controller: newPWController,
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
                errorText: !isNewPWValidation ? "Please enter your password!" : null,
                suffixIcon: InkWell(
                  onTap: (){
                    setState(() {
                      showPW = !showPW;
                    });
                  },
                  child: !showPW ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)
                )
              ),
              onChanged: (text) {
                if(newPWController.text.isEmpty){
                  isNewPWValidation = false;
                } else {
                  isNewPWValidation = true;
                }
              },
              onTap: () {
                setState(() {
                  if(newPWController.text.isEmpty){
                    isNewPWValidation = false;
                  }
                });
              }
            ),
            const SizedBox(height: 16,),
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
              onPressed: () async {
                await savePassword();
                
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
      ),
    
    );
  }
}