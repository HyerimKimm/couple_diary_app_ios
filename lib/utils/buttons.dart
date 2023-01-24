import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final Text text;
  final double width;
  final VoidCallback onPressed;
  const Buttons({Key? key, required this.text, required this.onPressed, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(1, 1),
          )]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned.fill(
              child: Container(
                width: width,
                height: 40,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0xFF1E88E5),
                      Color(0xFF2196F3),
                      Color(0xFF64B5F6),
                    ],
                  ),
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(width, 45),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                textStyle: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'NotoSansKR-Regular'),
              ),
              onPressed: onPressed,
              child: text,
            ),
          ],
        ),
      ),
    );
  }
}

