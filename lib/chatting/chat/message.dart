import 'package:couple_diary_app/chatting/chat/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chat')
            .orderBy('time',descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          final chatDocs = snapshot.data!.docs;

          return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (context, index){
                return ChatBubbles(
                    message: chatDocs[index]['text'],
                    isMe: chatDocs[index]['userId']==user!.uid?true:false,
                );
              }
          );
       },
    );
  }
}
