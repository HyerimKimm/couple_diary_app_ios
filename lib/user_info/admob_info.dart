import 'package:flutter/material.dart';

class AdmobInfo with ChangeNotifier{
  bool isLoaded = false;

  void change_isLoaded(bool isLoaded){
    this.isLoaded=isLoaded;
    notifyListeners();
  }
}