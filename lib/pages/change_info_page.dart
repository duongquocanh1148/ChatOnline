import 'dart:io';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Update information'),
          elevation: 0,
        ),
      body: Padding(
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
                  Image.asset(
                    'assets/images/user_img.png',
                    width: 128,
                    height: 128,
                    fit: BoxFit.cover,
                  ),
                ),
            ),
          ),
        ]),
      ),
    );
  }
}