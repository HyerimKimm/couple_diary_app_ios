import 'package:couple_diary_app/pages/login_page.dart';
import 'package:couple_diary_app/pages/main_page.dart';
import 'package:couple_diary_app/user_info/logged_user_info.dart';
import 'package:couple_diary_app/utils/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';
import '../utils/buttons.dart';
import 'chattingroom_page.dart';
import 'list_page.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _authentication = FirebaseAuth.instance; //로그아웃용

  @override
  Widget build(BuildContext context) {
    String coupleState = Provider.of<LoggedUserInfo>(context).coupleState;

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
                onPressed: (){
                  Navigator.pushNamed(context, '/notice');
                },
              ),
              SettingsButton(
                text: '문의하기',
                width: MediaQuery.of(context).size.width,
                onPressed: (){
                  _sendEmail();
                },
              ),
              SettingsButton(
                text: '로그아웃',
                width: MediaQuery.of(context).size.width,
                onPressed: (){
                  _signOut();
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
                if(coupleState=='couple'){
                  Navigator.pushReplacement(context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => ListPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                } else{
                  showSnackBar(context, '커플 등록 후 이용 가능합니다!');
                };
                break;
              case 2:
                if(coupleState=='couple'){
                  Navigator.pushReplacement(context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => ChattingRoomPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                }else{
                  showSnackBar(context, '커플 등록 후 이용 가능합니다!');
                }
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

  void _sendEmail() async{
    final Email email = Email(
      body: '',
      subject: '[커플문답 앱 문의]',
      recipients: ['helim01033@naver.com'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    try{
      await FlutterEmailSender.send(email);
    }catch(e){
      print(e);
    }
  }

  void _signOut() async{
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
