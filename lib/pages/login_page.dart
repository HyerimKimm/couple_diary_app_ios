import 'package:flutter/material.dart';
import '../utils/buttons.dart';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 100,
              height: 100,
              child: Image.asset('assets/images/wedding.png')
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: '아이디를 입력하세요'),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(labelText: '비밀번호를 입력하세요'),
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Buttons(text: Text('로그인'),onPressed: (){}),
              SizedBox(width: 15,),
              Buttons(
                  text: Text('회원가입'),
                  onPressed: (){
                    Navigator.pushNamed(context, '/createAccount');
              }),
            ],
          ),
        ],
      ),
    );
  }
}
