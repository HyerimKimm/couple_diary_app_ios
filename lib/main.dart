import 'package:couple_diary_app/pages/create_account_page.dart';
import 'package:couple_diary_app/pages/login_page.dart';
import 'package:couple_diary_app/pages/main_page.dart';
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
        appBarTheme: AppBarTheme(titleTextStyle: TextStyle(fontFamily: 'GmarketSansMedium',fontSize: 20)),
        fontFamily: 'NotoSansKR-Regular'
      ),
      initialRoute: '/login',
      routes: {
        '/login' : (context) => const LoginPage(),
        '/createAccount' : (context) => const CreateAccountPage(),
        '/main' : (context) => const MainPage(),
      },
    );
  }
}
