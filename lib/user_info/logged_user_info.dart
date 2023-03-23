import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoggedUserInfo with ChangeNotifier{
  final _authentication = FirebaseAuth.instance;
  String userUid='';
  String userName='';
  String userEmail='';
  String userProfileUrl='';
  String coupleId='';
  String senderOrReceiver='';
  String coupleState='none';
  String coupleUserUid='';
  DateTime? coupleStartDate;
  String coupleChatUid='';

  LoggedUserInfo(){
    getUserInfo();
  }

  void getUserInfo(){
    if(_authentication.currentUser!=null){
      userUid = _authentication.currentUser!.uid;

      //user collection 데이터 조회
      var documentSnapshot = FirebaseFirestore.instance.collection('user').doc(userUid).get()
          .then((value){
        userName = value.get('name');
        userEmail = value.get('email');
        userProfileUrl = value.get('profileUrl');

        //couple collection - 로그인한 user가 sender일 경우의 데이터 조회
        var coupleSnapshot = FirebaseFirestore.instance.collection('couple').where('senderUid',isEqualTo: userUid).get()
            .then((value){
          if(value.size>0) {
            coupleId=value.docs[0].id;
            senderOrReceiver='sender';
            coupleUserUid = value.docs[0].get('receiverUid');
            coupleState = value.docs[0].get('state');
            if(coupleState=='couple'){
              if(value.docs[0].get('startDate')!=null){
                coupleStartDate = (value.docs[0].get('startDate')).toDate();
              }
              if(value.docs[0].get('chatUid')!=null) coupleChatUid = value.docs[0].get('chatUid');
            }
            notifyListeners();
            return;
          }
        });

        //couple collection - 로그인한 user가 receiver일 경우의 데이터 조회
        coupleSnapshot = FirebaseFirestore.instance.collection('couple').where('receiverUid',isEqualTo: userUid).get()
            .then((value){
          if(value.size>0){
            senderOrReceiver='receiver';
            coupleId=value.docs[0].id;
            coupleUserUid = value.docs[0].get('senderUid');
            coupleState = value.docs[0].get('state');
            if(coupleState=='couple'){
              if(value.docs[0].get('startDate')!=null){
                coupleStartDate = (value.docs[0].get('startDate')).toDate();
              }
              if(value.docs[0].get('chatUid')!=null) coupleChatUid = value.docs[0].get('chatUid');
            }
            notifyListeners();
            return;
          }
        });
        senderOrReceiver='';
        coupleId='';
        coupleState='none';
        coupleUserUid='';
        coupleStartDate=null;
        coupleChatUid='';
        notifyListeners();
      });
    }
  }

  void deleteUser(){
    FirebaseFirestore.instance.collection('coupleChat').doc(coupleChatUid).delete();
    FirebaseFirestore.instance.collection('couple').doc(coupleId).delete();
    FirebaseFirestore.instance.collection('user').doc(userUid).delete();
    _authentication.currentUser!.delete();
    notifyListeners();
  }
}