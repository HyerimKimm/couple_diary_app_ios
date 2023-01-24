import 'package:couple_diary_app/utils/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/buttons.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  String name='';
  String email='';
  String password='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입'),),
      body: Form(
        key: GlobalKey<FormState>(),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: '이름을 입력하세요',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: '아이디(이메일)를 입력하세요'
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: pwController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: '비밀번호를 입력하세요'),
                ),
                const SizedBox(height: 40,),
                Buttons(
                    text: const Text('가입하기'),
                    width: 200,
                    onPressed: (){
                      if(nameController.text.isEmpty){
                        showSnackBar(context, '이름을 입력해 주세요!');
                      }else if(emailController.text.isEmpty){
                        showSnackBar(context, '아이디(이메일)을 입력해 주세요!');
                      }else if(pwController.text.isEmpty){
                        showSnackBar(context, '비밀번호를 입력해 주세요!');
                      }else{
//firebase authentication  기능 구현하기
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

