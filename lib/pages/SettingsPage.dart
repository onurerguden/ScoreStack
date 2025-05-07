import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C2C2C),
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 23,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green[800]
      ),
      body: Center(
          child: Text(
            "To be continued...",
            style: TextStyle(
              fontSize: 19,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ))
    );
  }
}