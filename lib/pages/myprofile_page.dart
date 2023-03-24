import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_diary_app/user_info/logged_user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';
import '../utils/buttons.dart';
import '../utils/snackBar.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'login_page.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String loggedUserUid='';
  String loggedUserPassword='';
  String loggedUserEmail='';
  String loggedUserName='';
  String loggedUserProfileUrl='';
  String coupleId='';
  String coupleChatId='';
  File? pickedImage;

  void _tryValidation(){
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }
  }

  void _pickImage() async{
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxHeight: 300,
    );
    setState(() {
      if(pickedImageFile != null){
        pickedImage = File(pickedImageFile.path);
      }
    });
  }

  void getCurrentUser(){
    loggedUserUid = Provider.of<LoggedUserInfo>(context).userUid;
    loggedUserPassword = Provider.of<LoggedUserInfo>(context).userPassword;
    loggedUserName = Provider.of<LoggedUserInfo>(context).userName;
    loggedUserEmail = Provider.of<LoggedUserInfo>(context).userEmail;
    loggedUserProfileUrl = Provider.of<LoggedUserInfo>(context).userProfileUrl;
    coupleId = Provider.of<LoggedUserInfo>(context).coupleId;
    coupleChatId = Provider.of<LoggedUserInfo>(context).coupleChatUid;
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    return  Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            title: const Text('내정보', style: TextStyle(color: Color.fromRGBO(123, 191, 239, 1)),),
          ),
      ),
      body: GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(//프로필이미지
                          padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                          child: Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Stack(
                                    children:[
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Color.fromRGBO(123, 191, 239, 1),
                                        backgroundImage: loggedUserProfileUrl!=''?NetworkImage(loggedUserProfileUrl):null,
                                      ),
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Color.fromRGBO(123, 191, 239, 0),
                                        backgroundImage: pickedImage!=null?FileImage(pickedImage!):null,
                                        //
                                      ),
                                    ]
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: (){
                                    _pickImage();
                                  },
                                  icon: Icon(Icons.image,size: 20,),
                                  label: Text('사진 선택', style: TextStyle(fontSize: 13),),
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30.0)
                                          )
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(//이름
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width*0.05,
                            bottom: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right:  MediaQuery.of(context).size.width*0.05,),
                                child: SizedBox(
                                  width:  MediaQuery.of(context).size.width*0.15,
                                  child: Text('이름',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width:MediaQuery.of(context).size.width * 0.65,
                                  child: TextFormField(
                                    initialValue: loggedUserName,
                                    validator: (value){
                                      if(value!.isEmpty){
                                        loggedUserName='';
                                        return '이름을 입력해 주세요!';
                                      }
                                      loggedUserName = value;
                                      return null;
                                    },
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    onSaved: (value){
                                      loggedUserName = value!;
                                    },
                                  )
                              ),
                            ],
                          ),
                        ),//이름
                        Padding(//이메일
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width*0.05,
                            bottom: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right:  MediaQuery.of(context).size.width*0.05,),
                                child: SizedBox(
                                  width:  MediaQuery.of(context).size.width*0.15,
                                  child: Text('이메일',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width:MediaQuery.of(context).size.width * 0.65,
                                  child: TextFormField(
                                    initialValue: loggedUserEmail,
                                    enabled: false,
                                  )
                              ),
                            ],
                          ),
                        ),//이메일
                      ],
                    ),
                    const SizedBox(height: 25,),
                    Buttons(
                      text: Text('수정하기'),
                      onPressed: () async {
                        _tryValidation();
                        if(loggedUserName != ''){
                          if(pickedImage!=null){
                            final refImage = FirebaseStorage.instance.ref().child('user_profile').child(loggedUserUid!+'.png');
                            await refImage.putFile(pickedImage!);
                            final url = await refImage.getDownloadURL();
                            await FirebaseFirestore.instance.collection('user').doc(loggedUserUid)
                                .set({'profileUrl':url,},SetOptions(merge: true));
                          }
                          await FirebaseFirestore.instance.collection('user').doc(loggedUserUid).set({
                            'name': loggedUserName,},SetOptions(merge: true));
                          showSnackBar(context, '수정되었습니다 💞');
                          Provider.of<LoggedUserInfo>(context,listen: false).getUserInfo();
                        }
                      },
                      width: 300,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          )
                        ),
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top:1.0, bottom: 16.0),
                                          child: Text('회원 탈퇴',
                                            style: TextStyle(
                                                color: Color.fromRGBO(123, 191, 239, 1),
                                                fontFamily: 'GmarketSansMedium',
                                                fontSize: 20,
                                            )
                                          ),
                                        ),
                                        const Text('회원 탈퇴하시겠습니까? 🥲'),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(//'네'버튼
                                                  style:TextButton.styleFrom(
                                                    minimumSize: const Size(100,50),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20)
                                                    )
                                                  ),
                                                  onPressed: () async {
                                                    try {
                                                      final user = await FirebaseAuth.instance.currentUser!;
                                                      var result = await user.reauthenticateWithCredential(
                                                          EmailAuthProvider.credential(
                                                              email: loggedUserEmail,
                                                              password: loggedUserPassword
                                                          )
                                                      );
                                                      result.user!.delete();
                                                      if(coupleId!='') FirebaseFirestore.instance.collection('couple').doc(coupleId).delete();
                                                      if(coupleChatId!='') FirebaseFirestore.instance.collection('coupleChat').doc(coupleChatId).delete();
                                                      FirebaseFirestore.instance.collection('user').doc(loggedUserUid).delete();
                                                      FirebaseAuth.instance.signOut();
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pushReplacementNamed(context, '/loading');
                                                    } catch(e){
                                                      print(e);
                                                    }
                                                  },
                                                  child: const Text('네',
                                                      style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 16
                                                  ),)
                                              ),
                                              TextButton(//'아니요'버튼
                                                  style:TextButton.styleFrom(
                                                      minimumSize: Size(100,50),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20)
                                                      )
                                                  ),
                                                  onPressed: (){
                                                    Navigator.pop(context,'Cancel');
                                                  },
                                                  child: const Text('아니요',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                      fontSize: 16
                                                    ),
                                                  )
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ),
                                );
                              },
                          );
                        },
                        child: const Text('회원 탈퇴하기',
                          style: TextStyle(
                              color: Colors.red),
                        )
                      ),
                    )
                  ],
                ),
              ),
          )
        ),
    );
  }
}
