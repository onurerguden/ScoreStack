import 'package:flutter/material.dart';

void main() {
  runApp(ScoreStackApp());
}

class ScoreStackApp extends StatelessWidget {
  const ScoreStackApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMenu(),
    );
  }
}

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _pages[_selectedPage],
        backgroundColor: Colors.grey,
        appBar: AppBar(
          toolbarHeight: 75,
          leading: Center(
            child: IconButton(
              onPressed: () {print("Settings button is clicked.");},
              icon: Icon(Icons.settings, color : Colors.white,),
              iconSize: 40,
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 30),
              Image.asset(
                'assets/images/ScoreStackLogo4-removebg-preview.png',
                width: 40,
              ),
              SizedBox(width: 2),
              const Text(
                "ScoreStack",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
                ),
              ),
              SizedBox(
                width: 42,
              )
            ],
          ),
          backgroundColor: Color(0xFF2C2C2C),
        ),

        bottomNavigationBar: BottomAppBar(
          color: Color(0xFF2C2C2C),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(onPressed: () {
                print("Favorites button is clicked.");
                onClicked(0);
                },
                  icon: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 40,
                  )
              ),
              SizedBox(width: 20),
              IconButton(onPressed: () {
                print("Main menu button is clicked.");
                onClicked(1);

                },
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 40,
                  )
              ),
              SizedBox(width: 20),
              IconButton(onPressed: (){
                print("Coupons button is clicked.");
                onClicked(2);
                },
                  icon: Icon(
                    Icons.receipt,
                    color :Colors.white,
                    size: 40,
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  State<FavoritesPage> createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Text("Favorites"),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Text("Home"),
      ),
    );
  }
}

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  State<CouponsPage> createState() => CouponsPageState();
}

class CouponsPageState extends State<CouponsPage> {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Text("Coupons"),
      ),
    );
  }
}