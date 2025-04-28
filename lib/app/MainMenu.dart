import 'package:flutter/material.dart';
import 'package:scorestack/widgets/CustomBottomNavigationBar.dart';


import '../pages/CouponsPage.dart';
import '../pages/FavoritesPage.dart';
import '../pages/HomePage.dart';
import '../widgets/CustomAppBar.dart';
import '../widgets/CustomBottomNavigationBar.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  State<MainMenu> createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu> {
  int _selectedPage = 1;

  List<Widget> _pages = [FavoritesPage(), HomePage(), CouponsPage()];
  void onClicked(int newPage) {
    setState(() {
      _selectedPage = newPage;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],

      //APPBAR CUSTOM
      appBar: CustomAppBar(),

      //BOTTOM NAVIGATION BAR
      bottomNavigationBar: CustomBottomNavigationBar(
        onClicked: onClicked,
      ),

    );
  }
}