import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_diary_app/couple_info/d_day.dart';
import 'package:couple_diary_app/pages/list_page.dart';
import 'package:couple_diary_app/pages/settings_page.dart';
import 'package:couple_diary_app/utils/buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../user_info/logged_user_info.dart';
import 'chattingroom_page.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';


class MainPage extends StatefulWidget{
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String loggedUserUid='';
  String loggedUserEmail='';
  String loggedUserName='';
  String loggedUserProfileUrl='';
  String coupleId = '';
  String senderOrReceiver='';
  String coupleState='';
  String coupleUserUid='';
  DateTime? coupleStartDate;
  final String iosTestUnitId = 'ca-app-pub-3940256099942544/2934735716';
  final String androidTestUnitId = 'ca-app-pub-3940256099942544/6300978111';

  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  //애드몹 광고를 불러왔을 때 화면 갱신해줌
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

  //커플 컬랙션의 state에 따라 다른 위젯을 return함
  Widget bodyWidgetReturn(){
    return coupleState=='none'?SearchMyCouple()
        :coupleState=='couple'?CoupleUser(startDate: coupleStartDate,coupleID: coupleId,)
        :senderOrReceiver=='sender'?CoupleSenderUser()
        :CoupleReceiverUser(coupleId: coupleId,coupleUserUid: coupleUserUid,);
  }

  void getCurrentUser(){
    loggedUserUid = Provider.of<LoggedUserInfo>(context).userUid;
    loggedUserName = Provider.of<LoggedUserInfo>(context).userName;
    loggedUserEmail = Provider.of<LoggedUserInfo>(context).userEmail;
    loggedUserProfileUrl = Provider.of<LoggedUserInfo>(context).userProfileUrl;
    coupleId = Provider.of<LoggedUserInfo>(context).coupleId;
    senderOrReceiver=Provider.of<LoggedUserInfo>(context).senderOrReceiver;
    coupleState = Provider.of<LoggedUserInfo>(context).coupleState;
    coupleUserUid = Provider.of<LoggedUserInfo>(context).coupleUserUid;
    coupleStartDate = Provider.of<LoggedUserInfo>(context).coupleStartDate;
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor : Color.fromRGBO(0, 0, 0, 0),
          elevation: 0,
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${loggedUserName}님, 안녕하세요🫠', style: TextStyle(color: Colors.black,),),
          ),
        ),
      ),
      body: Column(
          children: [
            (_bannerAd !=null && _isLoaded)?
            Container(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ):Container(),
            Expanded(child: Center(child: bodyWidgetReturn())),
          ]
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
      child: SingleChildScrollView(
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
      ),
    );
  }
}

//커플 등록이 완료된 유저의 화면
class CoupleUser extends StatefulWidget {
  DateTime? startDate;
  String coupleID;

  CoupleUser({Key? key, required this.startDate, required this.coupleID}) : super(key: key);

  @override
  State<CoupleUser> createState() => _CoupleUserState();
}
class _CoupleUserState extends State<CoupleUser> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DDay(
          coupleId: widget.coupleID,
          startDate:widget.startDate,
          width: MediaQuery.of(context).size.width*0.8,
          height: 80,
        ),
      ],
    );
  }
}

//커플 신청을 받은 유저의 화면
class CoupleReceiverUser extends StatefulWidget {
  String coupleId;
  String coupleUserUid;

  CoupleReceiverUser({Key? key, required this.coupleId,required this.coupleUserUid}) : super(key: key);

  @override
  State<CoupleReceiverUser> createState() => _CoupleReceiverUserState();
}
class _CoupleReceiverUserState extends State<CoupleReceiverUser> {
  @override
  Widget build(BuildContext context) {
    var logger = Logger(printer: PrettyPrinter());

    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('user').doc(widget.coupleUserUid).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        var logger = Logger(printer: PrettyPrinter());
        if(snapshot.hasData){
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('커플 신청이 있습니다!', style: TextStyle(fontSize: 20, fontFamily: 'NotoSansKR-Regular'),),
                const SizedBox(height: 45,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: const Color.fromRGBO(123, 191, 239, 1),
                        backgroundImage: NetworkImage(snapshot.data!['profileUrl']),
                      ),
                      const SizedBox(width: 15,),
                      Text(snapshot.data!['name'],style: TextStyle(fontSize: 20, fontFamily: 'NotoSansKR-Regular'),),
                    ],
                  ),
                ),
                SizedBox(height: 45,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Buttons(
                        text: Text(
                          '내 커플이 맞아요 😍',
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () async{
                          var logger = Logger(printer: PrettyPrinter());
                          logger.d('docId : ${widget.coupleId}');
                          await FirebaseFirestore.instance.collection('couple').doc(widget.coupleId).set({
                            'state': 'couple',},SetOptions(merge: true))
                              .then((value){
                            Provider.of<LoggedUserInfo>(context,listen: false).getUserInfo();
                              });
                        },
                        width: MediaQuery.of(context).size.width*0.45),
                    Buttons(
                        text: Text(
                          '내 커플이 아니예요ㅠ',
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: (){},
                        width: MediaQuery.of(context).size.width*0.45
                    ),
                  ],
                )
              ],
            ),
          );
        }
        return Column();
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
