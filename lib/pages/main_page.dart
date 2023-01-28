import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_diary_app/utils/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;
  String loggedUserEmail='';
  String loggedUserUid='';

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
        loggedUserEmail = loggedUser!.email.toString();
        loggedUserUid = loggedUser!.uid.toString();
        print(loggedUserEmail);
      }catch(e){
        showSnackBar(context, e.toString());
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0),
        titleTextStyle: TextStyle(
            color: Color.fromRGBO(91, 91, 91, 1),
            fontFamily: 'NotoSansKR-Bold',
            fontSize: 23),
        elevation: 0,
        centerTitle: false,
        title: FutureBuilder(
            future: FirebaseFirestore.instance.collection('user')
                .doc(loggedUserUid).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
              if(snapshot.hasData){
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.only(left:10),
                  child: Text('안녕하세요, ${data['name']}님 🫠',),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(left:10),
                child: Text('안녕하세요 🫠'),
              );
            },
        )
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          switch(index){
            case 0:
              break;
            case 1:
              break;
            case 2:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'home'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
            label: 'list'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
            label: 'settings'
          ),
        ],
      ),
    );
  }
}
