import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_diary_app/utils/buttons.dart';
import 'package:flutter/material.dart';

class Question extends StatefulWidget {
  double width;
  double height;

  Question({Key? key, required this.width, required this.height}) : super(key: key);

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
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/demian.jpeg'),
        ),
      ),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('coupleQnA').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting) return Text('');
          final snapshotDocs = snapshot.data!.docs;

          randomIndex = (randomIndex==0)?Random().nextInt(snapshotDocs.length):randomIndex;
          String data = snapshotDocs[randomIndex]['question'];
          print(data);
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                        '${data}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontFamily: 'GangwonEduBold'
                        ),
                      )
                  ),
                ),
              ),

            ],
          );
        },
      ),
    );
  }
}
