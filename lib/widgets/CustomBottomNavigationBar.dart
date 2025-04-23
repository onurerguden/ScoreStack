import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  Function(int) onClicked;

  CustomBottomNavigationBar({
  super.key,
  required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0xFF2C2C2C),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              print("Favorites button is clicked.");
              onClicked(0);
            },
            icon: Icon(Icons.star, color: Colors.white, size: 40),
          ),
          SizedBox(width: 20),
          IconButton(
            onPressed: () {
              print("Main menu button is clicked.");
              onClicked(1);
            },
            icon: Icon(Icons.home, color: Colors.white, size: 40),
          ),
          SizedBox(width: 20),
          IconButton(
            onPressed: () {
              print("Coupons button is clicked.");
              onClicked(2);
            },
            icon: Icon(Icons.receipt, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }
}
