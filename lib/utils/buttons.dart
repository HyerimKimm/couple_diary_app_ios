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
                      Color.fromRGBO(123, 191, 239, 1),
                      Color.fromRGBO(123, 191, 239, 1),
                      Color.fromRGBO(186, 221, 246, 1),
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

class SettingsButton extends StatelessWidget {
  final String text;
  final double width;
  final VoidCallback onPressed;

  const SettingsButton({Key? key, required this.text, required this.width, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1.0, color: Color.fromRGBO(215, 215, 215, 1)
            )
          )
        ),
        child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              minimumSize: Size(width, 60),
            ),
            child: Text(text,
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'NotoSansKR-Regular',
                  color: Color.fromRGBO(91, 91, 91, 1),
              ),
              textAlign: TextAlign.left,
            ),
        ),
      ),
    );
  }
}
