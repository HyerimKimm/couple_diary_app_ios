import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoggedUserInfo with ChangeNotifier{
  String userUid;
  String username='';
  String useremail='';
  String coupleState='';
  String coupleUserUid='';
  String coupleUserName='';

  LoggedUserInfo({required this.userUid});

  void ChangeUserInfo(){
    Future userInfo = FirebaseFirestore.instance.collection('user')
        .doc(userUid).get().then((value){
          username = value['name'];
          useremail = value['email'];
    });
  }

  void ChangeCoupleInfo(){
    Future coupleInfo = FirebaseFirestore.instance.collection('couple')
        .where('sender',isEqualTo: userUid)
        .where('state',isEqualTo: 'wait')
        .get().then((value) {
          if(value!=null){
            coupleState='wait';
          }
    });
  }
}