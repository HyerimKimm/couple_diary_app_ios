import 'package:couple_diary_app/utils/snackBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/buttons.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _authentication = FirebaseAuth.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  String name='';
  String email='';
  String password='';
  String coupleId='';

  final _formKey = GlobalKey<FormState>();
  void _tryValidation(){
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(title: const Text('회원가입'),),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return '이름을 입력해 주세요!';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (value){
                    name = value!;
                  },
                  decoration: const InputDecoration(
                      labelText: '이름을 입력해 주세요.',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty || value.length<4){
                      return '최소 4글자 이상 입력해 주세요!';
                    }else if(!value.contains('@')){
                      return '유효한 이메일을 입력해 주세요!';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (value){
                    email = value!;
                  },
                  decoration: const InputDecoration(
                      labelText: '아이디(이메일)를 입력해 주세요.'
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty || value.length<6){
                      return '6자 이상 입력해 주세요!';
                    }
                    return null;
                  },
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (value){
                    password = value!;
                  },
                  decoration: const InputDecoration(labelText: '비밀번호를 입력하세요'),
                ),
                const SizedBox(height: 40,),
                Buttons(
                    text: const Text('가입하기'),
                    width: 200,
                    onPressed: () async {
                      _tryValidation();
                      if(name!='' && email!='' && password!=''){
                        try{
                          final newUser = await _authentication.createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          if(newUser.user != null) {
                            await FirebaseFirestore.instance.collection('user').doc(newUser.user!.uid)
                              .set({'name':name, 'email':email, 'coupleUid':coupleId});
                            showSnackBar(context, '회원가입 성공!');
                            Navigator.pop(context);
                          }
                        }catch(e){
                          showSnackBar(context, e.toString());
                        }
                      }
                    }),
                const SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

