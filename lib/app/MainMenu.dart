import 'package:flutter/material.dart';
import '../pages/CouponsPage.dart';
import '../pages/FavoritesPage.dart';
import '../pages/HomePage.dart';
import '../widgets/CustomAppBar.dart';
import '../widgets/CustomBottomNavigationBar.dart';

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
      final entered = await Navigator.push(context, PageRouteBuilder(opaque: false, pageBuilder: (_, __, ___) => CheckboxPage()));
      if (entered == true) {
        setState(() {
          _selectedPage = 2;
          _pages[2] = CouponsPage();
        });
      }
    }
    else {
      setState(() {
      _selectedPage = newPage;
      });
    }
  }

  @override
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

class CheckboxPage extends StatefulWidget {
  const CheckboxPage({super.key});

  @override
  CheckboxState createState() => CheckboxState();
}

class CheckboxState extends State<CheckboxPage> {
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