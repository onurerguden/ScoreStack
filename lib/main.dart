import 'package:flutter/material.dart';
import 'app/MainMenu.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ScoreStackApp());
}

class ScoreStackApp extends StatelessWidget {
  const ScoreStackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: CheckboxPage());
  }
}

class CheckboxPage extends StatefulWidget {
  const CheckboxPage({super.key});

  @override
  CheckboxState createState() => CheckboxState();
}

class CheckboxState extends State<CheckboxPage> {
  bool isChecked = false;

  void skip() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => MainMenu()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C2C2C),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "User Warning About Betting & Its Harms",
          style: TextStyle(
            fontSize: 19,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Betting is riskful and eventually leads to financial difficulties. It should never be seen as a financial problem solver and it is not reliable. Keep it at minimum, and try to quit as early as possible.",
              style: TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  activeColor: Colors.green[800],
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    "I understand how betting can end up harming me, and I know my limits on playing bet.",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: isChecked ? skip : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}