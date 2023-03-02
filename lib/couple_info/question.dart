import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  double width;
  double height;
  Question({Key? key, required this.width, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
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
          int randomIndex = Random().nextInt(snapshotDocs.length);
          String data = snapshotDocs[randomIndex]['question'];
          print(data);
          return Center(child: Text('${data}', style: TextStyle(color: Colors.white),));
        },
      ),
    );
  }
}
