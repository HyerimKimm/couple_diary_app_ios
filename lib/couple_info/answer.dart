import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_diary_app/utils/snackBar.dart';
import 'package:flutter/material.dart';

class Answer extends StatefulWidget {
  final String question;
  final String category;
  final String coupleId;
  final String userId;
  final String userName;

  Answer({Key? key, required this.question, required this.coupleId, required this.userId, required this.userName, required this.category}) : super(key: key);

  @override
  State<Answer> createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String answer='';

    void _addAnswer() async{
      answer = answerController.text;
      await FirebaseFirestore.instance.collection('couple').doc(widget.coupleId)
          .collection('QnAanswer').add(
          {
            'userId':widget.userId,
            'userName':widget.userName,
            'question':widget.question,
            'category':widget.category,
            'answer':answer,
            'add_datetime':Timestamp.now(),
          }).then((value) {
            showSnackBar(context, '등록되었습니다!');
            Navigator.of(context).pop();
      });
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(widget.question,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'GangwonEduBold'
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width*0.9,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.1),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Form(
            child: TextFormField(
                controller: answerController,
                maxLines: 8,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'NotoSansKR-Regular',
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorStyle: TextStyle(
                    color: Color.fromRGBO(255, 150, 210, 1),
                  ),
                  contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                )
            ),
          ),
        ),
        SizedBox(height: 20,),
        TextButton.icon(
              style: TextButton.styleFrom(
                side: const BorderSide(
                  color: Color.fromRGBO(123, 191, 239, 1)
                ),
                backgroundColor: const Color.fromRGBO(123, 191, 239, 0.3),
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                if(answerController.text==null || answerController.text==''){
                  showSnackBar(context, '답변을 입력해 주세요 🥲');
                  return;
                }
                if(answerController.text.length<3){
                  showSnackBar(context, '답변이 너무 짧아요 🥲');
                  return;
                }
                if((answerController.text!=null || answerController.text!='') && answerController.text.length>3){
                  _addAnswer();
                }
              },
              icon: const Icon(Icons.edit, color: Colors.white,),
              label: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Text('등록하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'GangwonEduBold'
                  ),
                ),
              ),
        )
      ],
    );
  }
}
