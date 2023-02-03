import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({Key? key, required this.message, required this.isMe}) : super(key: key);

  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe==true?MainAxisAlignment.end:MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe==true?Color.fromRGBO(123, 191, 239, 0.3):Color.fromRGBO(215, 215, 215, 0.5),
            borderRadius: BorderRadius.circular(15),
          ),
          width: 200,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: EdgeInsets.symmetric(horizontal:8, vertical: 5),
          child: Text(message),
        ),
      ],
    );
  }
}
