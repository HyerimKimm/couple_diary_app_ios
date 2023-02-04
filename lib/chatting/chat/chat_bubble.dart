import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';

class ChatBubbles extends StatefulWidget {
  ChatBubbles({Key? key, required this.message, required this.isMe, required this.userId}) : super(key: key);

  final String message;
  final bool isMe;
  final String userId;

  @override
  State<ChatBubbles> createState() => _ChatBubblesState();
}

class _ChatBubblesState extends State<ChatBubbles> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.isMe?MainAxisAlignment.end:MainAxisAlignment.start,
      children: [
        if(widget.isMe)
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: FutureBuilder(
                  future: FirebaseFirestore.instance.collection('user').doc(widget.userId).get(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if(snapshot.hasData){
                      final userName = snapshot.data['name'];
                      return Text(userName);
                    }else{
                      return Text('');
                    }
                  },
                ),
              ),
              ChatBubble(
                clipper: ChatBubbleClipper4(type: BubbleType.sendBubble),
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
        ),
          if(!widget.isMe) Padding(//상대방 챗버블
            padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance.collection('user').doc(widget.userId).get(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if(snapshot.hasData){
                        final userName = snapshot.data['name'];
                        return Text(userName);
                      }else{
                        return Text('');
                      }
                    },
                  ),
                ),
                ChatBubble(
                  clipper: ChatBubbleClipper4(type: BubbleType.receiverBubble),
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(top: 0),
                  backGroundColor: Color.fromRGBO(225, 225, 225, 1),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Text(widget.message, style: TextStyle(color: Colors.black),),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
