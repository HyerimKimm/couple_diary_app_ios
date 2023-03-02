import 'package:couple_diary_app/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'dart:io';
import 'chattingroom_page.dart';
import 'main_page.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final String iosTestUnitId = 'ca-app-pub-3940256099942544/2934735716';
  final String androidTestUnitId = 'ca-app-pub-3940256099942544/6300978111';

  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  void _loadAd() async{
    final Size screenSize = MediaQuery.of(context).size;

    final AnchoredAdaptiveBannerAdSize? size
        = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        screenSize.width.truncate());

    if(size == null){
      print('Unable to get height of anchored banner');
      return;
    }

    _bannerAd = BannerAd(
        size: size,
        adUnitId: Platform.isAndroid?androidTestUnitId:iosTestUnitId,
        request: AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad){
            setState(() {
              _bannerAd = ad as BannerAd;
              _isLoaded = true;
            });
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error){
            var logger = Logger(printer: PrettyPrinter());
            logger.d(error);
            ad.dispose();
          }
        ),
    );

    _bannerAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text('목록', style: TextStyle(color: Theme.of(context).primaryColor),),
        ),
      ),
      body: (_bannerAd !=null && _isLoaded)?
        Container(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ):Container(),
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
