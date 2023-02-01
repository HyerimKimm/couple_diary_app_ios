import 'package:couple_diary_app/pages/login_page.dart';
import 'package:couple_diary_app/pages/main_page.dart';
import 'package:couple_diary_app/utils/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transition/transition.dart';
import '../utils/buttons.dart';
import 'chatting_page.dart';
import 'list_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _authentication = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text('설정', style: TextStyle(color: Theme.of(context).primaryColor),),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children:[
              SettingsButton(
                text: '내 정보',
                width: MediaQuery.of(context).size.width,
                onPressed: (){
                  Navigator.pushNamed(context, '/myProfile');
                },
              ),
              SettingsButton(
                text: '공지사항',
                width: MediaQuery.of(context).size.width,
                onPressed: (){},
              ),
              SettingsButton(
                text: '문의하기',
                width: MediaQuery.of(context).size.width,
                onPressed: (){},
              ),
              SettingsButton(
                text: '로그아웃',
                width: MediaQuery.of(context).size.width,
                onPressed: (){
                  signOut();
                },
              ),
            ]
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Theme.of(context).primaryColorLight,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedFontSize: 10,
          selectedFontSize: 10,
          currentIndex: 3,
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
                    pageBuilder: (context, animation1, animation2) => ChattingPage(),
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

  void signOut() async{
    try{
      await _authentication.signOut();
      if(_authentication.currentUser==null){
        showSnackBar(context, '로그아웃 되었습니다.');
        Navigator.pushReplacement(context,
            Transition(
              child: LoginPage(),
              transitionEffect: TransitionEffect.FADE
            )
        );
      }
    }catch(e){
      showSnackBar(context, e.toString());
    }
  }
}
