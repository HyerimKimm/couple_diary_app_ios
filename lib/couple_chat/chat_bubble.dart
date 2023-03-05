import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class ChatBubbles extends StatefulWidget {
  ChatBubbles({Key? key, required this.message, required this.isMe, required this.userId, required this.addDatetime}) : super(key: key);

  final String message;
  final bool isMe;
  final String userId;
  final DateTime? addDatetime;

  @override
  State<ChatBubbles> createState() => _ChatBubblesState();
}

class _ChatBubblesState extends State<ChatBubbles> {
  @override
  Widget build(BuildContext context) {
    return
      widget.isMe
      //내 챗버블
          ? StreamBuilder(
            stream: FirebaseFirestore.instance.collection('user').doc(widget.userId).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting) return Column();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(snapshot.data!['name'],),
                    ),
                    ChatBubble(
                      clipper: ChatBubbleClipper4(
                        radius: 13,
                        type: BubbleType.sendBubble
                      ),
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(top: 0),
                      backGroundColor: Color.fromRGBO(123, 191, 239, 1),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: Text(widget.message, style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
      //상대방 챗버블
          :StreamBuilder(
        stream: FirebaseFirestore.instance.collection('user').doc(widget.userId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting) return Column();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(snapshot.data!['name'],),
                ),
                ChatBubble(
                  clipper: ChatBubbleClipper4(
                    type: BubbleType.receiverBubble,
                    radius: 13,
                  ),
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 0),
                  backGroundColor: Color.fromRGBO(190, 190, 190, 1),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Text(widget.message, style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          );
        },
      );
  }
}
