import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_diary_app/pages/settings_page.dart';
import 'package:couple_diary_app/user_info/logged_user_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../couple_chat/message.dart';
import '../couple_chat/new_messsage.dart';
import 'list_page.dart';
import 'main_page.dart';

class ChattingRoomPage extends StatefulWidget {
  const ChattingRoomPage({Key? key}) : super(key: key);

  @override
  State<ChattingRoomPage> createState() => _ChattingRoomPageState();
}

class _ChattingRoomPageState extends State<ChattingRoomPage> {
  Widget bodyWidgetReturn(){
    return Provider.of<LoggedUserInfo>(context).coupleChatUid==''?NoChatRoom():ChatWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text('채팅', style: TextStyle(color: Theme.of(context).primaryColor),),
        ),
      ),
      body: bodyWidgetReturn(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Theme.of(context).primaryColorLight,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedFontSize: 10,
          selectedFontSize: 10,
          currentIndex: 2,
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

//채팅 시작하기 버튼 보여주는 위젯임
class NoChatRoom extends StatelessWidget {
  const NoChatRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 178, 217, 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 250,
            height: 250,
            child: Image.asset('assets/images/chat_start.png'),
          ),
          SizedBox(height: 20,),
          Text(
            '사랑은 대화를 통해서 \n서로의 존재를 확인해야 한다',
            textAlign: TextAlign.center,
            style: TextStyle(
                color:Color.fromRGBO(90, 90, 90, 1),
                fontSize: 23,fontFamily: 'GangwonEduBold'
            ),
          ),
          SizedBox(height: 20,),
          SizedBox(
            width: 250,
            height: 70,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
                ),
              ),
                onPressed: () async{
                  String coupleUid = Provider.of<LoggedUserInfo>(context,listen: false).coupleId!;
                  await FirebaseFirestore.instance.collection('coupleChat').add({})
                  .then((value) {
                    FirebaseFirestore.instance.collection('coupleChat').doc(value.id).collection('chat').add({});
                    FirebaseFirestore.instance.collection('couple').doc(coupleUid).set({'chatUid':value.id},SetOptions(merge: true))
                      .then((value) {
                        Provider.of<LoggedUserInfo>(context,listen: false).getUserInfo();
                      }
                    );
                  });
                },
                child: Text(
                  '채팅 시작하기',
                  style: TextStyle(
                    color: Colors.blue,
                      fontSize: 30,
                      fontFamily: 'GangwonEduBold',
                      shadows: [
                        Shadow(
                          offset: Offset(3.0,3.0),
                          blurRadius: 15,
                          color: Colors.white
                        ),
                        Shadow(
                            offset: Offset(-3.0,-3.0),
                            blurRadius: 10,
                            color: Colors.white
                        ),
                      ]),
                )
            ),
          )
        ],
      ),
    );
  }
}

//커플 채팅방
class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(
        children: [
          Expanded(
            child: Messages(),
          ),
          NewMessage(),
        ],
      ),
    );;
  }
}



