import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
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
              icon: Icon(Icons.settings),
            label: 'settings'
          ),
        ],
      ),
    );
  }
}
