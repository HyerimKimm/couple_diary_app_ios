import 'package:couple_diary_app/chatting/chat/message.dart';
import 'package:couple_diary_app/chatting/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({Key? key}) : super(key: key);

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final _authentication = FirebaseAuth.instance;

  @override
  void initState(){
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser(){
    final user = _authentication.currentUser;
    if(user==null){
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text('채팅', style: TextStyle(color: Theme.of(context).primaryColor),),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: Messages()),
          NewMessage(),
        ],
      ),
    );
  }
}
