import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../pages/post.dart';

class Question extends StatefulWidget {
  Question({Key? key}) : super(key: key);

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  late int randomIndex;

  @override
  void initState(){
    super.initState();
    randomIndex=0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('coupleQnA').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting) return Text('');
          final snapshotDocs = snapshot.data!.docs;
          randomIndex = (randomIndex==0)?Random().nextInt(snapshotDocs.length):randomIndex;
          String data = snapshotDocs[randomIndex]['question'];
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                child: SizedBox(
                  height: 100,
                  child: Center(
                      child: Text(
                        '${data}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontFamily: 'GangwonEduBold'
                        ),
                      )
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(123, 191, 239, 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      )
                    ),
                    onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Post(question: data,))
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 24.0,
                    ),
                    label: const Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '답변 쓰기',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'GangwonEduBold',
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(143, 232, 136, 0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        )
                    ),
                    onPressed: (){
                      setState(() {
                        randomIndex=Random().nextInt(snapshotDocs.length);
                      });
                    },
                    icon: const Icon(
                      Icons.refresh,
                      size: 24.0,
                    ),
                    label: const Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '새로고침',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'GangwonEduBold',
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50,)

            ],
          );
        },
      ),
    );
  }
}
