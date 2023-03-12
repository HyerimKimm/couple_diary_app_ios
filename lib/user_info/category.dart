import 'package:flutter/material.dart';

class Category with ChangeNotifier{
  String category='';

  void changeCategory(String category){
    this.category=category;
    notifyListeners();
  }
}