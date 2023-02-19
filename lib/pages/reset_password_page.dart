import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({ Key? key }) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController emailController = TextEditingController();

  bool isEmailValidation = true;
  FirebaseAuth firebaseAuth= FirebaseAuth.instance;

  bool validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return (regex.hasMatch(value)) ? true : false;
  }

  Future resetPassword(BuildContext context) async{
    if(isEmailValidation){
      try{
        await firebaseAuth.sendPasswordResetEmail(email: emailController.text);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Check your email"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ));
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(context);

      }
      on PlatformException catch(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ));
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
          color: Colors.blue,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Center(
              child: Text(
                "Reset Password",
                style: TextStyle(
                  color: Colors.blue, fontSize: 32, fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32,),
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
                  errorText: !isEmailValidation ? "Email invalidate!" :null),
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
                const SizedBox(height: 32,),
                ElevatedButton(
                  onPressed: () async {
                    await resetPassword(context);
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 32,
                    height: 48,
                    child: const Center(
                        child: Text(
                          "Reset Password",
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