import 'dart:async';
import 'package:couple_diary_app/pages/login_page.dart';
import 'package:couple_diary_app/pages/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transition/transition.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        Transition(
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return const MainPage();
              }else {
                return const LoginPage();
              }
            },
          ),
          transitionEffect: TransitionEffect.FADE,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/images/neon_heart.png')),
            const SizedBox(
              height: 50,
            ),
            const Text(
              '우리를 기록하는 공간',
              style: TextStyle(
                  color: Color.fromRGBO(91, 91, 91, 1),
                  fontSize: 25,
                  fontFamily: 'GangwonEduBold'),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 50),
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(123, 191, 239, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
