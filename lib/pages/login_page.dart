import 'dart:math';
import 'package:couple_diary_app/utils/snackBar.dart';
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
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  void _tryValidation(){
    bool isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }
  }

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
                  int randomIndex = Random().nextInt(snapshot.data!.docs.length);
                  return Text('${snapshot.data!.docs[randomIndex]['contents']}',
                    style: TextStyle(
                      fontFamily: 'GangwonEduBold',
                      fontSize: 23,
                      color: Color.fromRGBO(91, 91, 91, 1),
                    ),);
                }
                return CircularProgressIndicator();
              }
            ),
            const SizedBox(height: 40,),
            //아이디,비밀번호 입력 / 로그인, 회원가입 버튼
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return '아이디(이메일)을 입력해 주세요!';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value){
                        email = value!;
                      },
                      decoration: const InputDecoration(labelText: '아이디(이메일)를 입력해 주세요.'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        if(value!.isEmpty || value.length<6){
                          return '비밀번호는 6자 이상입니다!';
                        }
                        return null;
                      },
                      onSaved: (value){
                        password = value!;
                      },
                      decoration: const InputDecoration(labelText: '비밀번호를 입력해 주세요.'),
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Buttons(
                            text: const Text('로그인'),
                            width:100,
                            onPressed: () async {
                              _tryValidation();
                              if(email=='' || password==''){
                                showSnackBar(context, '아이디, 비밀번호를 모두 입력해 주세요!');
                              }else{
                                try{
                                  final newUser =
                                      await _authentication
                                          .signInWithEmailAndPassword(
                                            email: email,
                                            password: password);
                                  if(newUser.user!=null){
                                    showSnackBar(context, '로그인 성공!');
                                    Navigator.pushReplacementNamed(context, '/main');
                                  }
                                }catch(e){
                                  showSnackBar(context, e.toString());
                                }
                              }
                            }),
                        const SizedBox(width: 15,),
                        Buttons(
                            text: const Text('회원가입'),
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
            ),
          ],
        ),
      ),
    );
  }
}
