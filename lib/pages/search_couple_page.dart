import 'package:flutter/material.dart';

class SearchCouplePage extends StatefulWidget {
  const SearchCouplePage({Key? key}) : super(key: key);

  @override
  State<SearchCouplePage> createState() => _SearchCouplePageState();
}

class _SearchCouplePageState extends State<SearchCouplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(title: const Text('내 커플 찾기'),),
      ),
    );
  }
}
