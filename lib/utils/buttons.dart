import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final Text text;
  final VoidCallback onPressed;
  const Buttons({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.6,1),
                  colors: <Color>[
                    Color(0xFF64B5F6),
                    Color(0xFF2196F3),
                    Color(0xFF1E88E5),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              textStyle: const TextStyle(fontSize: 16,fontFamily: 'NotoSansKR-Regular'),
            ),
            onPressed: onPressed,
            child: text,
          ),
        ],
      ),
    );
  }
}

