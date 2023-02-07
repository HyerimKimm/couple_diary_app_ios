import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/buttons.dart';
import '../utils/snackBar.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

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

  File? pickedImage;

  void _pickImage() async{
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 150,
    );
    setState(() {
      if(pickedImageFile != null){
        pickedImage = File(pickedImageFile.path);
      }
    });
  }

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
      body: GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('user').doc(loggedUserUid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              loggedUserName = snapshot.data['name'].toString();
              return Column(
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
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Color.fromRGBO(123, 191, 239, 1),
                                  backgroundImage: pickedImage!=null?FileImage(pickedImage!):null,
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
                  SizedBox(height: 25,),
                  Buttons(
                    text: Text('수정하기'),
                    onPressed: () {
                      FirebaseFirestore.instance.collection('user')
                          .doc(loggedUserUid).set(
                        {'name': loggedUserName},
                      );
                      //pickedImage!=null? FirebaseStorage.instance.ref(pickedImage!.path):null;
                    },
                    width: 300,
                  ),
                ],
              );
            },
          )
        ),
      ),
    );
  }
}
