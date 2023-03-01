import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  double width;
  double height;
  Question({Key? key, required this.width, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/demian.jpeg'),
        ),
      ),
    );
  }
}
