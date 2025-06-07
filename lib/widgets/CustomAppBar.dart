import 'package:flutter/material.dart';
import '../pages/SettingsPage.dart';
import '../pages/ProfilePage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 75,
      leading: Center(
        child: IconButton(
          onPressed: () {
            print("Settings button is clicked.");
            Navigator.of(context).push(_slideFromLeft(SettingsPage()));
          },
          icon: Icon(Icons.settings, color: Colors.white),
          iconSize: 40,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(
            'assets/images/ScoreStackLogo4-removebg-preview.png',
            width: 40,
          ),
          SizedBox(width: 2),
          const Text(
            "ScoreStack",
            style: TextStyle(
              fontSize: 31,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),

      backgroundColor: Color(0xFF2C2C2C),
      actions: [
        IconButton(
          onPressed: () {
            print("profile button clicked");
            Navigator.of(context).push(_slideFromRight(ProfilePage()));
          },
          icon: Icon(Icons.account_circle, color: Colors.white),
          iconSize: 40,
        ),
        SizedBox(width: 5),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(75);
}

Route _slideFromRight(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offset = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation);
      return SlideTransition(position: offset, child: child);
    },
  );
}

Route _slideFromLeft(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offset = Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(animation);
      return SlideTransition(position: offset, child: child);
    },
  );
}
