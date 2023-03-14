import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatonline/function/fnc_conversation.dart';
import 'package:chatonline/models/user_models.dart';
import 'package:chatonline/pages/conversation_detail_page.dart';
import 'package:chatonline/widget/image_path.dart';
import 'package:chatonline/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendList extends StatefulWidget {
  const FriendList({Key? key}) : super(key: key);

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {

  Future removeFriend(String uid)async{
    CollectionReference friend =  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('friends');
    await  friend.doc(uid).delete();

    friend =  FirebaseFirestore.instance.collection('users').doc(uid).collection('friends');
    await  friend.doc(FirebaseAuth.instance.currentUser!.uid).delete();

    updateIsFriend(uid, false);
  }

  Future updateIsFriend(String uid, bool temp) async{
    CollectionReference mess = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('conversations');
    await mess.doc(uid).update({
      'isFriend' : temp,
    });

    mess = FirebaseFirestore.instance.collection('users').doc(uid)
        .collection('conversations');
    await mess.doc(FirebaseAuth.instance.currentUser!.uid).update({
      'isFriend' : temp,
    });
  }

  Future createNewConversation(String uid) async{
    String mesDes = '';
    Map<String, dynamic>? myData  = await getUserData(FirebaseAuth.instance.currentUser!.uid);
    Map<String, dynamic>? friendData  = await getUserData(uid);
    Map<String, dynamic>? conversation = {
      'cid': uid,
      'conName' : friendData!['userName'],
      'image': friendData['image'],
      'lastTime': Timestamp.now(),
      'lastMes': mesDes,
      'isFriend': true,
    };

    await  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('conversations').doc(uid).set(conversation);

    conversation['conName'] = myData!['userName'];
    conversation['cid'] = myData['userID'];
    conversation['image'] = myData['image'];

    await  FirebaseFirestore.instance.collection('users').doc(uid)
        .collection('conversations').doc(FirebaseAuth.instance.currentUser!.uid).set(conversation);
  }

  Future goToConversation(String uid, BuildContext context)async{
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('conversations').doc(uid).get().then((value) async{
      if(!value.exists){
        await createNewConversation(uid);
      }
      else{
        updateIsFriend(uid, true);
      }
    });

    Map<String, dynamic>? userData = await getUserData(uid);
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ConversationDetailPage(userInfo: userData!)));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid).collection('friends').snapshots(),

      builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.hasData) {
          return ListView.builder(
            itemCount: snapShot.data!.docs.length,
            itemBuilder: (context, index) {

              UserModel friends = UserModel.fromJson(snapShot.data!.docs[index].data() as Map<String, dynamic>);

              return Container(
                decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: ClipOval(
                    child: friends.image!.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: friends.image!,
                      width: 48,
                      height: 48,
                    )
                        : Image.asset(
                      ImagePath.avatar,
                      width: 48,
                      height: 48,
                    ),
                  ),
                  title: Text(
                    friends.userName!,
                    style: const TextStyle(fontSize: 16),
                  ),

                  onTap: () => {
                    //nextScreenReplace(context, )
                  },
                  trailing: SizedBox(
                    width: 90.0,
                    height: 36.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 36.0,
                          height: 36.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(36),color:Colors.blue.shade400),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            splashRadius: 22.0,
                            onPressed: () {
                              goToConversation(friends.userID!, context);
                            },
                            icon: const Icon(Icons.message,size:  18.0,),color: Colors.white,),
                        ),
                        Container(
                          width: 36.0,
                          height: 36.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(36),color:Colors.red.shade400),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            splashRadius: 22.0,
                            onPressed: () {
                              // removeFriend(friends.userID!);
                              showDialog(context: context, builder: (context){
                                return AlertDialog(
                                  title: const Text('Unfriend'),
                                  content: const Text('Are you sure to unfriend?'),
                                  actions: [
                                    TextButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel')
                                    ),
                                    TextButton(
                                        onPressed: (){
                                          removeFriend(friends.userID!);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Yes')
                                    ),
                                  ],
                                );
                              });
                            },
                            icon: const Icon(Icons.person_remove,size:  18.0,),color: Colors.white,),
                        ),

                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
