import 'package:couple_diary_app/pages/list_page.dart';
import 'package:couple_diary_app/pages/settings_page.dart';
import 'package:flutter/material.dart';
import '../userInfo/user_info.dart';
import 'chattingroom_page.dart';
import 'package:provider/provider.dart';


class MainPage extends StatefulWidget{
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('userUid : ${Provider.of<LoggedUserInfo>(context).userUid}'),
            Text('userName : ${Provider.of<LoggedUserInfo>(context).username}'),
            Text('userEmail : ${Provider.of<LoggedUserInfo>(context).useremail}'),
            Text('coupleState : ${Provider.of<LoggedUserInfo>(context).coupleState}'),
            Text('coupleUserUid : ${Provider.of<LoggedUserInfo>(context).coupleUserUid}'),
            Text('coupleUserName : ${Provider.of<LoggedUserInfo>(context).coupleUserName}'),
          ],
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

