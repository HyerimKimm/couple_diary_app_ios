import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_diary_app/pages/chatting_page.dart';
import 'package:couple_diary_app/pages/list_page.dart';
import 'package:couple_diary_app/pages/settings_page.dart';
import 'package:couple_diary_app/utils/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chattingroom_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;
  String loggedUserUid='';
  String loggedUserName='';
  String loggedUserCoupleId='';
  String loggedUserCoupleState='';

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
      }catch(e){
        showSnackBar(context, e.toString());
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0),
          titleTextStyle: TextStyle(
              color: Color.fromRGBO(91, 91, 91, 1),
              fontFamily: 'NotoSansKR-Bold',
              fontSize: 23),
          elevation: 0,
          centerTitle: false,
          title: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('user').doc(loggedUserUid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                if(snapshot.hasData){
                  loggedUserName = snapshot.data!['name'];
                  return Padding(
                    padding: const EdgeInsets.only(left:10),
                    child: Text('안녕하세요, ${loggedUserName}님 🫠',),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(left:10),
                  child: Text(''),
                );
              },
          )
        ),
      ),
      body: MakeCouple(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Theme.of(context).primaryColorLight,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedFontSize: 10,
          selectedFontSize: 10,
          onTap: (index){
            switch(index){
              case 0:
                Navigator.pushReplacement(context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => MainPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
                break;
              case 1:
                Navigator.pushReplacement(context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => ListPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
                break;
              case 2:
                Navigator.pushReplacement(context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => ChattingRoomPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
                break;
              case 3:
                Navigator.pushReplacement(context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => SettingsPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
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
                icon: Icon(Icons.chat),
                label: 'chat'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'settings'
            ),
          ],
        ),
      ),
    );
  }
}

class MakeCouple extends StatelessWidget {
  const MakeCouple({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('couple')
          .where("senderUid",isEqualTo: "loggedUserUid").get(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){

        }
        return SearchMyCouple();
      },
    );
  }
}

class SearchMyCouple extends StatelessWidget {
  const SearchMyCouple({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('커플을 등록해 보세요!', style: TextStyle(fontFamily: 'GangwonEduBold', fontSize: 23),),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: OutlinedButton.icon(
              onPressed: (){
                Navigator.pushNamed(context, '/searchCouple');
              },
              icon: Icon(Icons.search),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('내 커플 찾기',style: TextStyle(fontFamily: 'GangwonEduBold',fontSize: 21),),
              ),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )
                  )
              ),
            ),
          )
        ],
      ),
    );
  }
}

