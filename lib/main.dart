import 'package:couple_diary_app/pages/chattingroom_page.dart';
import 'package:couple_diary_app/pages/create_account_page.dart';
import 'package:couple_diary_app/pages/list_page.dart';
import 'package:couple_diary_app/pages/loading_page.dart';
import 'package:couple_diary_app/pages/login_page.dart';
import 'package:couple_diary_app/pages/main_page.dart';
import 'package:couple_diary_app/pages/myprofile_page.dart';
import 'package:couple_diary_app/pages/notice_page.dart';
import 'package:couple_diary_app/pages/search_couple_page.dart';
import 'package:couple_diary_app/pages/settings_page.dart';
import 'package:couple_diary_app/user_info/category.dart';
import 'package:couple_diary_app/user_info/logged_user_info.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (value)=>LoggedUserInfo()
        ),
        ChangeNotifierProvider(
            create: (value)=>Category()
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: const Color.fromRGBO(123, 191, 239, 1),
          primaryColorDark: const Color.fromRGBO(91, 91, 91, 1),
          primaryColorLight: const Color.fromRGBO(215, 215, 215, 1),
          appBarTheme: const AppBarTheme(
            color: Color.fromRGBO(255, 255, 255, 1),
            titleTextStyle: TextStyle(fontFamily: 'GmarketSansMedium',fontSize: 20, color: Color.fromRGBO(123, 191, 239, 1)),
            elevation: 0.5,
            shadowColor: Color.fromRGBO(215, 215, 215, 1),
            iconTheme: IconThemeData(color: Color.fromRGBO(123, 191, 239, 1))
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: const Color.fromRGBO(123, 191, 239, 1),
          ),
          focusColor: const Color.fromRGBO(123, 191, 239, 1),
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(color : Color.fromRGBO(150, 150, 150, 1),),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(215, 215, 215, 1),)
            )
          ),
          fontFamily: 'NotoSansKR-Regular'
        ),
        initialRoute: '/loading',
        routes: {
          '/loading' : (context) => const LoadingPage(),
          '/login' : (context) => const LoginPage(),
          '/createAccount' : (context) => const CreateAccountPage(),
          '/main' : (context) => const MainPage(),
          '/list' : (context) => const ListPage(),
          '/chatting' : (context) =>const ChattingRoomPage(),
          '/settings' : (context) => const SettingsPage(),
          '/myProfile' : (context) => const MyProfilePage(),
          '/searchCouple' : (context) => const SearchCouplePage(),
          '/notice' : (context) => const NoticePage(),
        },
      ),
    );
  }
}
/*
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}*/