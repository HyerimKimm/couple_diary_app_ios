import 'dart:developer';
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
  String coupleState='none'; //sender, receiver, couple, none
  bool initFinish=false;

  @override
  void initState(){
    super.initState();
    getCurrentUser();
  }

  //로그인한 유저의 회원정보를 조회
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

  //coupleState의 값에 따라 body 위젯을 리턴함
  Widget getWidget(){
    print('getWidget : ${coupleState}');
    if(coupleState=='sender') return CoupleSenderUser();
    if(coupleState=='receiver') return CoupleReceiverUser();
    if(coupleState=='couple') return CoupleUser();
    return SearchMyCouple();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 0),
          titleTextStyle: const TextStyle(
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
                return const Padding(
                  padding: EdgeInsets.only(left:10),
                  child: Text(''),
                );
              },
          )
        ),
      ),
      body: SearchMyCouple(),
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

//등록한 커플 정보가 없는 유저의 화면
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

//커플 등록이 완료된 유저의 화면
class CoupleUser extends StatefulWidget {
  const CoupleUser({Key? key}) : super(key: key);

  @override
  State<CoupleUser> createState() => _CoupleUserState();
}
class _CoupleUserState extends State<CoupleUser> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Text('커플입니다.');
      },
    );
  }
}

//커플 신청을 받은 유저의 화면
class CoupleReceiverUser extends StatefulWidget {
  const CoupleReceiverUser({Key? key}) : super(key: key);

  @override
  State<CoupleReceiverUser> createState() => _CoupleReceiverUserState();
}
class _CoupleReceiverUserState extends State<CoupleReceiverUser> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Text('커플 신청이 있습니다.');
      },
    );
  }
}

//커플 신청을 한 유저의 화면
class CoupleSenderUser extends StatefulWidget {
  const CoupleSenderUser({Key? key}) : super(key: key);

  @override
  State<CoupleSenderUser> createState() => _CoupleSenderUserState();
}
class _CoupleSenderUserState extends State<CoupleSenderUser> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Text('커플 수락 대기중입니다.');
      },
    );
  }
}

