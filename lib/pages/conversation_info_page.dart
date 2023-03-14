import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatonline/widget/image_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user_models.dart';

class ConversationInfoPage extends StatelessWidget {
  final Map<String, dynamic> userInfo;
  const ConversationInfoPage({Key? key, required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.blue),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(userInfo['userID']).snapshots(),
          builder: ( context,AsyncSnapshot<DocumentSnapshot> snapshot) {
            if(snapshot.hasData){
              UserModel userModel = UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: userModel.image!.isNotEmpty? CachedNetworkImage(
                            imageUrl:  userModel.image!,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ):Image.asset(
                            ImagePath.avatar,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          )
                      ),
                    ),
                    Center(child: Text(userModel.userName!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      leading: const Icon(Icons.person, size: 28,),
                      iconColor: Colors.blue,
                      textColor: Colors.blue,
                      title: const Text('Profile', style: TextStyle(fontSize: 18),),
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Center(
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(24),
                                            child: userModel.image!.isNotEmpty? CachedNetworkImage(
                                              imageUrl: userModel.image!,
                                              width: 48,
                                              height: 48,
                                              fit: BoxFit.cover,
                                            ):Image.asset(
                                              ImagePath.avatar,
                                              width: 48,
                                              height: 48,
                                              fit: BoxFit.cover,
                                            )
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(userModel.userName!)
                                      ],
                                    )),
                                content: SizedBox(
                                  height: 100,
                                  width: MediaQuery.of(context)
                                      .size
                                      .width -
                                      32,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.email,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                              userModel.email!)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.phone,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                              userModel.email!)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      leading: const Icon(Icons.delete, size: 28,),
                      iconColor: Colors.red,
                      textColor: Colors.red,
                      title: const Text('Remove conversation', style: TextStyle(fontSize: 18),),
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Remove this conversation'),
                                content: const Text('Are you sure to remove?'),
                                actions: [
                                  TextButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel')
                                  ),
                                  TextButton(
                                      onPressed: ()async{
                                        // await removeConversation(userModel.userID!, context);
                                      },
                                      child: const Text('OK')
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  ],
                ),
              );
            }
            return const Center(child: const CircularProgressIndicator(),);
          },

        )
    );
  }
}
