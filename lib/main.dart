import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../pages/InitialCheckboxPage.dart';

//SARP DEMİRTAŞ - 20220601016
//ONUR ERGÜDEN - 20220601030

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ScoreStackApp());
}

class ScoreStackApp extends StatelessWidget {
  const ScoreStackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InitialCheckboxPage(),
    );
  }
}
