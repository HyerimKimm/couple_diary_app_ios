import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_diary_app/user_info/logged_user_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String coupleChattingRoomUid='';
  var _userEnterMessage = '';

  void _sendMessage(){
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection('coupleChat')
        .doc(coupleChattingRoomUid).collection('chat').add({
      'text':_userEnterMessage,
      'addDatetime':Timestamp.now(),
      'senderUid': Provider.of<LoggedUserInfo>(context,listen: false).userUid,
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    coupleChattingRoomUid = Provider.of<LoggedUserInfo>(context).coupleChatUid;

    return Container(
      margin: const EdgeInsets.only(top: 8.0,),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  maxLines: null,
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: '메세지를 입력하세요.'
                  ),
                ),
              ),
          ),
          IconButton(
            onPressed: (){
              _userEnterMessage = _controller.text.toString();
              if(_userEnterMessage=='' || _userEnterMessage==null){
                return;
              }
              else{
                _sendMessage();
                _controller.clear();
              }
            },
            icon: const Icon(Icons.send),
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}
