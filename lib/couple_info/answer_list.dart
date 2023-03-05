import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnswerList extends StatefulWidget {
  final String coupleId;

  AnswerList({Key? key, required this.coupleId}) : super(key: key);

  @override
  State<AnswerList> createState() => _AnswerListState();
}

class _AnswerListState extends State<AnswerList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('couple').doc(widget.coupleId)
          .collection('QnAanswer').orderBy('add_datetime',descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return const CircularProgressIndicator(color: Colors.white,);
        }
        final answerDocs = snapshot!.data.docs;
        return ListView.builder(
          itemCount: answerDocs.length,
          itemBuilder: (BuildContext context, int index) {
            print(answerDocs[index]['question']);
            return AnswerListCard(
              question: answerDocs[index]['question'],
              userName: answerDocs[index]['userName'],
              answer: answerDocs[index]['answer'],
              addDateTime: answerDocs[index]['add_datetime'].toDate(),
            );
          },
        );
      },
    );
  }
}

class AnswerListCard extends StatelessWidget {
  final String question;
  final String answer;
  final String userName;
  final DateTime? addDateTime;
  const AnswerListCard({Key? key, required this.question, required this.userName, required this.answer, required this.addDateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: Color.fromRGBO(255, 255, 255, 0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0)
        ),
        elevation: 3.0,
        child: SizedBox(
          width: MediaQuery.of(context).size.width*0.9,
          height: 130,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:8.0,left: 8.0, right: 8.0),
                child: Text(
                  'Q. ${question}',
                  style: TextStyle(
                    color: Color.fromRGBO(80, 80, 80, 1),
                    fontFamily: 'GangwonEduBold',
                    fontSize: 18
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 80,
                      child: Text(userName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color.fromRGBO(123, 191, 239, 1),
                            fontFamily: 'NotoSansKR-Regular',
                            fontSize: 13
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.calendar_month, color: Colors.grey,),
                  Text(DateFormat('yyyy-MM-dd HH시 mm분').format(addDateTime!),
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontFamily: 'NotoSansKR-Regular'
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(answer,
                    style: const TextStyle(
                      color: Color.fromRGBO(80, 80, 80, 1),
                      fontFamily: 'GangwonEduBold',
                      fontSize: 15
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
