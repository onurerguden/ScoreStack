import 'package:flutter/material.dart';
import 'package:scorestack/pages/CouponCheckboxPage.dart';
import '../pages/CouponsPage.dart';
import '../pages/FavoritesPage.dart';
import '../pages/HomePage.dart';
import '../widgets/CustomAppBar.dart';
import '../widgets/CustomBottomNavigationBar.dart';

//SARP DEMİRTAŞ - 20220601016
//ONUR ERGÜDEN - 20220601030

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu> {
  int _selectedPage = 1;

  final List<Widget> _pages = [FavoritesPage(), HomePage(), SizedBox()];

  void onClicked(int newPage) async {
    if (newPage == 2) {
      if (_selectedPage == 2) return;
      final entered = await Navigator.push(
        context,
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (_, __, ___) => CouponCheckboxPage(),
        ),
      );
      if (entered == true) {
        setState(() {
          _selectedPage = 2;
          _pages[2] = CouponsPage();
        });
      }
    } else {
      setState(() {
        _selectedPage = newPage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],

      appBar: CustomAppBar(),

      bottomNavigationBar: CustomBottomNavigationBar(onClicked: onClicked),
    );
  }
}
