import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';

class ChatBubbles extends StatelessWidget {
  const ChatBubbles({Key? key, required this.message, required this.isMe}) : super(key: key);

  final String message;
  final bool isMe;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe?MainAxisAlignment.end:MainAxisAlignment.start,
      children: [
        if(isMe)
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('user', style: TextStyle(fontWeight: FontWeight.bold),),
              ChatBubble(
                clipper: ChatBubbleClipper4(type: BubbleType.sendBubble),
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 0),
                backGroundColor: Color.fromRGBO(123, 191, 239, 1),
                child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Text(message, style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
          if(!isMe) Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('receiver', style: TextStyle(fontWeight: FontWeight.bold),),
                ChatBubble(
                  clipper: ChatBubbleClipper4(type: BubbleType.receiverBubble),
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(top: 0),
                  backGroundColor: Color.fromRGBO(225, 225, 225, 1),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Text(message, style: TextStyle(color: Colors.black),),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
