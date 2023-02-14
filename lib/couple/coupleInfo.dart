import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CoupleInfo with ChangeNotifier{
   String sender;
   String receiver;
   String state;

  CoupleInfo({required this.sender, required this.receiver, required this.state});

  void changeCoupleInfo(){
    sender = '1';
    receiver = '2';
    notifyListeners();
  }
}