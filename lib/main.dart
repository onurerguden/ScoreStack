import 'package:flutter/material.dart';
import 'app/MainMenu.dart';
import 'package:firebase_core/firebase_core.dart';
import '../pages/InitialCheckboxPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ScoreStackApp());
}

class ScoreStackApp extends StatelessWidget {
  const ScoreStackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: InitialCheckboxPage());
  }
}
