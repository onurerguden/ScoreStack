import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C2C2C),
        appBar: AppBar(
            title: Text(
              "Profile",
              style: TextStyle(
                fontSize: 19,
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
          ),
        )
    );
  }
}