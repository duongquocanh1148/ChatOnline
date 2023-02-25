import 'package:flutter/material.dart';

import 'add_friend.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({ Key? key }) : super(key: key);

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        title: const Text(
          'Friends',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: (){
            
          }, 
          icon: const Icon(Icons.search),
          )
        ],
      ),
      //body: ,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AddFriend()));
        },
        elevation: 0,
        child: const Icon(Icons.add),
      ),
    );
  }
}