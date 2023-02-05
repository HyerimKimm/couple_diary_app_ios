import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_diary_app/utils/snackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchCouplePage extends StatefulWidget {
  const SearchCouplePage({Key? key}) : super(key: key);

  @override
  State<SearchCouplePage> createState() => _SearchCouplePageState();
}

class _SearchCouplePageState extends State<SearchCouplePage> {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  String searchInputData = '';
  String searchedCoupleUserUid = '';

  void _tryValidation(){
    bool isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(title: const Text('내 커플 찾기'),),
        ),
        body: Column(
          children: [
            //검색창
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width*0.7,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return '검색할 이메일을 입력해 주세요!';
                            }
                            return null;
                          },
                          onSaved: (value){
                            searchInputData = value!;
                          },
                          decoration: InputDecoration(
                            hintText: '상대방의 이메일로 검색하세요'
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: (){
                        _tryValidation();
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 23,
                      ),
                  ),
                ],
              ),
            ),
            //결과 리스트
          ],
        ),
      ),
    );
  }
}
