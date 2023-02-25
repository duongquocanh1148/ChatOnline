import 'package:chatonline/pages/add_conversation.dart';
import 'package:chatonline/pages/pages.dart';
import 'package:chatonline/widget/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String hintTextEmail= "Email";
  bool show = false;
  bool isEmailValidation = true;
  bool isPWValidation = true;

  bool validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return (regex.hasMatch(value)) ? true : false;
  }

  Future<void> signIn(String email, String pass) async {
    if (isEmailValidation && isPWValidation) {
      try {
        await firebaseAuth
            .signInWithEmailAndPassword(email: email, password: pass)
            .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Sign in successfully"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ));
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const NavigationPage()),
              (route) => false);
        });
      } on FirebaseAuthException catch (e) {
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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.blue,
    ));
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "Chat",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            TextFieldWidget.base(
              controller: emailController,
              hint: "Email",
              icon: Icons.email,
              error: "Email invalidate!",
              isValidation: isEmailValidation,
              style: const TextStyle(fontSize: 16),
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onChanged: (text) {
                setState(() {
                  isEmailValidation = validateEmail(emailController.text);
                });
              },
              onTap: () {
                setState(() {
                  if (emailController.text.isEmpty) {
                    isEmailValidation = false;
                  }
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
                controller: passwordController,
                obscureText: !show,
                style: const TextStyle(fontSize: 16),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)
                  ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    hintText: "Password",
                    errorText:
                        !isPWValidation ? "Please enter your password!" : null,
                    suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            show = !show;
                          });
                        },
                        child: !show
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off))),
                onChanged: (text) {
                  if (passwordController.text.isEmpty) {
                    isPWValidation = false;
                  } else {
                    isPWValidation = true;
                  }
                },
                onTap: () {
                  setState(() {
                    if (passwordController.text.isEmpty) {
                      isPWValidation = false;
                    }
                  });
                }),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ResetPassword()));
                    },
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(color: Colors.blue),
                    )),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            ElevatedButton(
                onPressed: () {
                  signIn(emailController.text, passwordController.text);
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 32,
                  height: 48,
                  child: const Center(
                      child: Text(
                    "Login",
                    style: TextStyle(fontSize: 16),
                  )),
                )),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddConversation(),
                      ));
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
