import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/snackBar.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;
  String loggedUserUid='';
  String loggedUserEmail='';
  String loggedUserName='';
  String loggedUserProfile='';
  String coupleUserUid='';

  @override
  void initState(){
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser(){
    final user = _authentication.currentUser;
    if(user != null){ //로그인 정보가 있으면
      try{
        loggedUser = user;
        loggedUserUid = loggedUser!.uid.toString();
        loggedUserEmail = loggedUser!.email.toString();
        loggedUserName = '';
      }catch(e){
        showSnackBar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            title: const Text('내정보', style: TextStyle(color: Color.fromRGBO(123, 191, 239, 1)),),
          ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 30, bottom: 15
            ),
            child: Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.asset('assets/images/edit-info.png'),
              ),
            ),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            initialValue: loggedUserName,
            decoration: const InputDecoration(
              labelText: '이름을 입력해 주세요.',
            ),
          ),
        ]
      ),
    );
  }
}
