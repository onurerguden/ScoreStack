import 'package:flutter/material.dart';

class CouponCheckboxPage extends StatefulWidget {
  const CouponCheckboxPage({super.key});

  @override
  CheckboxState createState() => CheckboxState();
}

class CheckboxState extends State<CouponCheckboxPage> {
  bool isChecked = false;

  void skip() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C2C2C),
      appBar: AppBar(
        centerTitle: true,
        title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/ScoreStackLogo4-removebg-preview.png",
                height: 32,
              ),
              const SizedBox(width: 8),
              Text(
                "Warning About Betting",
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ]
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