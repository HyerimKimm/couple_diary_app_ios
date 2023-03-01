import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_diary_app/couple_chat/chat_bubble.dart';
import 'package:couple_diary_app/user_info/logged_user_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {

  @override
  Widget build(BuildContext context) {
    final String userId = Provider.of<LoggedUserInfo>(context).userUid;
    final String coupleChatUid = Provider.of<LoggedUserInfo>(context).coupleChatUid;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('coupleChat').doc(coupleChatUid).collection('chat').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        final chatDocs = snapshot.data!.docs;

        if(snapshot.connectionState==ConnectionState.waiting){
          return Container();
        }
        return Container();
      },
    );
  }
}
