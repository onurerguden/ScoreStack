import 'package:flutter/material.dart';
import 'app/MainMenu.dart';


void main() {
  runApp(ScoreStackApp());
}

class ScoreStackApp extends StatelessWidget {
  const ScoreStackApp({super.key});

  Widget build(BuildContext context) {
    //Return MaterialApp
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainMenu());
  }
}
