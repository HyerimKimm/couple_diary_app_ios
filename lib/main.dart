import 'package:couple_diary_app/pages/create_account_page.dart';
import 'package:couple_diary_app/pages/login_page.dart';
import 'package:couple_diary_app/pages/main_page.dart';
import 'package:couple_diary_app/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(123, 191, 239, 1),
        appBarTheme: const AppBarTheme(
          color: Color.fromRGBO(123, 191, 239, 1),
            titleTextStyle: TextStyle(fontFamily: 'GmarketSansMedium',fontSize: 20),
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
      initialRoute: '/login',
      routes: {
        '/login' : (context) => const LoginPage(),
        '/createAccount' : (context) => const CreateAccountPage(),
        '/main' : (context) => const MainPage(),
        '/settings' : (context) => const Settings(),
      },
    );
  }
}
