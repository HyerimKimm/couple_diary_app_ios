import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      body: Container(
        child: const Center(
          child: Text(
            '준비중이예요!',
            style: TextStyle(
                color: Color.fromRGBO(90, 90, 90, 1),
                fontFamily: 'GangwonEduBold',
              fontSize: 24
            ),
          ),
        ),
      ),
    );
  }
}
