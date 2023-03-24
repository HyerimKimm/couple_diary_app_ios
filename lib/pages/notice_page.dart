import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(title: Text('공지사항'),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text('준비중이예요!', style: TextStyle(fontFamily: 'GangwonEduBold', fontSize: 20),)),
      )
    );
  }
}

void doNothing(BuildContext context) {}