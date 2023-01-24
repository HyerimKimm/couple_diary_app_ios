import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white)),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.blue,
    ),
  );
}