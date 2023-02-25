import 'package:chatonline/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({super.key});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  Stream? users;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        title: const Text(
          'Add Friends',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: (){
            
          }, 
          icon: const Icon(Icons.search),
          )
        ],
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          nextScreen(context, const AddFriend());
        },
        elevation: 0,
        child: const Icon(Icons.add),
      ),
    );
  }

  groupList(){
    return StreamBuilder(
      stream: users,
      builder: (context, AsyncSnapshot snapShot){
        if(snapShot.hasData){
          if(snapShot.data['users'].length != 0){
              return const Text(
                "Hello"
              );
          }else{
              return const Text(
                "No users"
              );
          }
        }else{
            return const Text(
                "Check your internet again!"
              );
        }  
      },
    );
  }
}