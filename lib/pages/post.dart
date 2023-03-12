import 'package:couple_diary_app/couple_info/answer.dart';
import 'package:couple_diary_app/user_info/logged_user_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Post extends StatefulWidget {
  final String question;
  final String category;

  Post({Key? key, required this.question, required this.category}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    final String userId = Provider.of<LoggedUserInfo>(context).userUid;
    final String userName = Provider.of<LoggedUserInfo>(context).userName;
    final String coupleId = Provider.of<LoggedUserInfo>(context).coupleId;

    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('답변 쓰기'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                fit:BoxFit.cover,
                image: AssetImage('assets/images/ansansky.jpeg')
            ),
          ),
          child: Column(
            children: [
              Answer(question: widget.question, category: widget.category, coupleId: coupleId, userId: userId, userName: userName,)
            ],
          ),
        ),
      ),
    );
  }
}
