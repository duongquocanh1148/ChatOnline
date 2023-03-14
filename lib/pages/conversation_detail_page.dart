
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatonline/function/fnc_conversation.dart';
import 'package:chatonline/models/message_models.dart';
import 'package:chatonline/pages/conversation_info_page.dart';
import 'package:chatonline/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ConversationDetailPage extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  const ConversationDetailPage({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<ConversationDetailPage> createState() => _ConversationDetailPageState();
}

class _ConversationDetailPageState extends State<ConversationDetailPage> {
  final TextEditingController _messageController = TextEditingController();

  late String mesID;
  late Map<String, dynamic> m_message;

  Future sendMessage() async{
    if(_messageController.text.trim().isNotEmpty){
      //lấy token người gửi
      Uuid uuid = const Uuid();
      mesID = uuid.v4();

      m_message = {
        'mesID': mesID,
        'senderID': FirebaseAuth.instance.currentUser!.uid,
        'mesDes': _messageController.text,
        'time': Timestamp.now(),
        'isRemove': false,
      };

      _messageController.clear();

      updateMessage(FirebaseAuth.instance.currentUser!.uid,widget.userInfo['userID']);

      Map<String, dynamic>? userData = await getUserData(widget.userInfo['userID']);

      updateMessage(widget.userInfo['userID'], FirebaseAuth.instance.currentUser!.uid);
    }
  }

  void updateMessage(String uid, String other){
    FirebaseFirestore.instance.collection('users').doc(uid)
        .collection('conversations').doc(other).collection('messages').doc(mesID).set(m_message).then((value) {
      FirebaseFirestore.instance.collection('users').doc(uid)
          .collection('conversations').doc(other).update({
        'lastTime': m_message['time'],
        'lastMes': m_message['mesDes'],
      });
    });
  }

  //Bug
  Future removeMessage(String mesID)async{
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('conversations').doc(widget.userInfo['userID'])
        .collection('messages').doc(mesID).delete();

    await FirebaseFirestore.instance.collection('users').doc(widget.userInfo['userID'])
        .collection('conversations').doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages').doc(mesID).delete();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            ClipOval(
                child: widget.userInfo['image'].isNotEmpty? CachedNetworkImage(
                  imageUrl: widget.userInfo['image'],
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                ):Image.asset(
                  'assets/images/user_img.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                )
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              '${widget.userInfo['userName']}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 36,
                height: 36,
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(18)),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>ConversationInfoPage(userInfo: widget.userInfo,)));
                  },
                  splashRadius: 18,
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.info,
                  ),
                ),
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: SingleChildScrollView(
                reverse: true,
                physics: const BouncingScrollPhysics(),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('conversations').doc(widget.userInfo['userID'])
                      .collection('messages').orderBy('time').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.connectionState == ConnectionState.active){
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          MessageModel message = MessageModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                          bool flag = message.senderID! == FirebaseAuth.instance.currentUser!.uid;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: GestureDetector(
                              onLongPress: (){
                                if(flag){
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Remove this message'),
                                          content: const Text('Are you sure to remove?'),
                                          actions: [
                                            TextButton(
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel')
                                            ),
                                            TextButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  if(snapshot.data!.docs.length>1){
                                                    if(index == snapshot.data!.docs.length){
                                                      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                                                          .collection('conversations').doc(widget.userInfo['userID']).update({
                                                        'lastMes': snapshot.data!.docs[index-1].get('lastMes'),
                                                        'lastTime':  snapshot.data!.docs[index-1].get('lastTime'),
                                                      });
                                                    }
                                                  }
                                                  //only one mess
                                                  else{
                                                    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                                                        .collection('conversations').doc(widget.userInfo['userID']).update({
                                                      'lastMes': '',
                                                      'lastTime':  '',
                                                    });
                                                  }
                                                  // await removeMessage(snapshot.data!.docs[index].get('mesID'));
                                                },
                                                child: const Text('OK')
                                            ),
                                          ],
                                        );
                                      });
                                }
                              },
                              child: Row(
                                mainAxisAlignment: !flag
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.end,
                                children: [
                                  !flag ? ClipOval(
                                      child: widget.userInfo['image'].isNotEmpty? CachedNetworkImage(
                                        imageUrl: widget.userInfo['image'],
                                        width: 36,
                                        height: 36,
                                        fit: BoxFit.cover,
                                      ):Image.asset(
                                        'assets/images/user_img.png',
                                        width: 36,
                                        height: 36,
                                        fit: BoxFit.cover,
                                      )
                                  ):const Text(''),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    constraints: BoxConstraints(maxWidth: width*0.7),
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                        color: flag
                                            ? Colors.blue
                                            : Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Text(
                                      message.mesDes!,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: !flag
                                              ? Colors.black
                                              : Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const Center();
                  },
                )
            ),
          ),),
          Container(
            width: width,
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child:  TextField(
                        controller: _messageController,
                        style: const TextStyle(fontSize:  16),
                        decoration: const InputDecoration(
                          contentPadding:  EdgeInsets.all(8),
                          hintText: "Enter message",
                          border: InputBorder.none,
                        ),
                      ),
                    )
                ),
                GestureDetector(
                  onTap: () async{
                    // print('send');
                    await  sendMessage();
                  },
                  child: const Icon(Icons.send, color: Colors.blue,size: 36,),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
