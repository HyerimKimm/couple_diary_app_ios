import 'package:couple_diary_app/utils/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/buttons.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _authentication = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('설정'),),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children:[
            SettingsButton(
              text: '내 정보',
              width: 400,
              onPressed: (){},
            ),
            SettingsButton(
              text: '공지사항',
              width: 400,
              onPressed: (){},
            ),
            SettingsButton(
              text: '문의하기',
              width: 400,
              onPressed: (){},
            ),
            SettingsButton(
              text: '로그아웃',
              width: 400,
              onPressed: (){
                signOut();
              },
            ),
          ]
        ),
      )
    );
  }

  void signOut() async{
    try{
      await _authentication.signOut();
      if(_authentication.currentUser==null){
        showSnackBar(context, '로그아웃 되었습니다.');
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/login');
      }
    }catch(e){
      showSnackBar(context, e.toString());
    }
  }
}
