import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

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
    return Container();
  }
}
