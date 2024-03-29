import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_diary_app/pages/settings_page.dart';
import 'package:couple_diary_app/user_info/category.dart';
import 'package:couple_diary_app/user_info/logged_user_info.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../couple_info/answer_list.dart';
import 'chattingroom_page.dart';
import 'main_page.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final BannerAd _bannerAd = BannerAd(
    size: AdSize.banner,
    adUnitId: 'ca-app-pub-6773853153851132/9031257149',
    listener: BannerAdListener(
        onAdLoaded: (Ad ad){
          print('loaded ad');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error){
          print('load ad failed, $error');
        }
    ),
    request: AdRequest(),
  )..load();

  @override
  Widget build(BuildContext context) {
    final String coupleId = Provider.of<LoggedUserInfo>(context).coupleId;

    return Scaffold(
      appBar : PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text('문답 기록', style: TextStyle(color: Theme.of(context).primaryColor),),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(123, 191, 239, 1),
              ),
              child: AnswerList(coupleId: coupleId,),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            alignment: Alignment.center,
            child: AdWidget(ad: _bannerAd,),
            width: _bannerAd.size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Theme.of(context).primaryColorLight,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedFontSize: 10,
          selectedFontSize: 10,
          currentIndex: 1,
          onTap: (index){
            Provider.of<Category>(context,listen: false).changeCategory('');
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
