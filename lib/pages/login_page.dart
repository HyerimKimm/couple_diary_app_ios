import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인', style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100,),
            //로그인 화면 이미지
            SizedBox(
                width: 100,
                height: 100,
                child: Image.asset('assets/images/wedding.png')
            ),
            const SizedBox(height: 40,),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('lessons').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if(snapshot.hasData){
                  int itemCount = snapshot.data!.docs.length;
                  final contents = snapshot.data!.docs!;

                  return Text(contents[Random().nextInt(itemCount)]['contents'],
                        style: const TextStyle(fontSize: 23, fontFamily: 'GangwonEduBold'),);
                }
                return const CircularProgressIndicator();
              }
            ),
            const SizedBox(height: 40,),
            //아이디,비밀번호 입력 / 로그인, 회원가입 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: '아이디(이메일)를 입력하세요'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(labelText: '비밀번호를 입력하세요'),
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Buttons(text: Text('로그인'),width:100,onPressed: (){}),
                      SizedBox(width: 15,),
                      Buttons(
                          text: Text('회원가입'),
                          width: 100,
                          onPressed: (){
                            Navigator.pushNamed(context, '/createAccount');
                          }),
                    ],
                  ),
                  const SizedBox(height: 30,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
