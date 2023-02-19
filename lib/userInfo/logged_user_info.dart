import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class LoggedUserInfo with ChangeNotifier{
  var logger = Logger(printer: PrettyPrinter());
  final _authentication = FirebaseAuth.instance;
  String userUid='';
  String userName='';
  String userEmail='';
  String userProfileUrl='';
  String senderorreceiver='';
  String coupleState='none';
  String coupleUserUid='';

  LoggedUserInfo(){
    getUserInfo();
  }

  void getUserInfo(){
    userUid = _authentication.currentUser!.uid;
    logger.d(userUid);
    var documentSnapshot = FirebaseFirestore.instance.collection('user').doc(userUid).get()
        .then((value){
      logger.d(value.data());
      userName = value.get('name');
      userEmail = value.get('email');
      userProfileUrl = value.get('profileUrl');

      var coupleSnapshot = FirebaseFirestore.instance.collection('couple').where('senderUid',isEqualTo: userUid).get()
      .then((value){
        if(value.size>0) {
          logger.d(value.docs[0].data());
          senderorreceiver='sender';
          coupleUserUid = value.docs[0].get('receiverUid');
          coupleState = value.docs[0].get('state');
          notifyListeners();
          return;
        }
      });
      coupleSnapshot = FirebaseFirestore.instance.collection('couple').where('receiverUid',isEqualTo: userUid).get()
      .then((value){
        if(value.size>0){
          logger.d(value.docs[0].data());
          senderorreceiver='receiver';
          coupleUserUid = value.docs[0].get('senderUid');
          coupleState = value.docs[0].get('state');
          notifyListeners();
          return;
        }
      });
      notifyListeners();
    });
  }
}