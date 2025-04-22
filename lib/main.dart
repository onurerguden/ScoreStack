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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {print("Selected team has been added to favorites.");},
                  child: Text(
                    "Add to favorites",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
                height: 40
            ),
          ],
        ),
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
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                    height: 40
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: 400,
                  height: 400,
                  color: Colors.grey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        color: Colors.black54,
                        child: Text(
                          "Today's Matches",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children:[
                            ListTile(
                              leading: Icon(Icons.sports_soccer),
                              title: Text("Fenerbahçe vs Galatasaray"),
                              subtitle: Text("21.00"),
                            ),
                            ListTile(
                              leading: Icon(Icons.sports_soccer),
                              title: Text("Fenerbahçe vs Galatasaray"),
                              subtitle: Text("21.00"),
                            ),
                            ListTile(
                              leading: Icon(Icons.sports_soccer),
                              title: Text("Fenerbahçe vs Galatasaray"),
                              subtitle: Text("21.00"),
                            ),
                            ListTile(
                              leading: Icon(Icons.sports_soccer),
                              title: Text("Fenerbahçe vs Galatasaray"),
                              subtitle: Text("21.00"),
                            ),
                            ListTile(
                              leading: Icon(Icons.sports_soccer),
                              title: Text("Fenerbahçe vs Galatasaray"),
                              subtitle: Text("21.00"),
                            ),
                            ListTile(
                              leading: Icon(Icons.sports_soccer),
                              title: Text("Fenerbahçe vs Galatasaray"),
                              subtitle: Text("21.00"),
                            ),
                            ListTile(
                              leading: Icon(Icons.sports_soccer),
                              title: Text("Fenerbahçe vs Galatasaray"),
                              subtitle: Text("21.00"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ),
                SizedBox(
                    height: 30
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: 400,
                  height: 200,
                  color: Colors.lightGreen,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        color: Colors.green,
                        child: Text("Favorite Team's Matches",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children:[
                            ListTile(
                              leading: Icon(Icons.sports_soccer),
                              title: Text("Fenerbahçe vs Galatasaray"),
                              subtitle: Text("21.00"),
                            ),
                            ListTile(
                              leading: Icon(Icons.sports_soccer),
                              title: Text("Fenerbahçe vs Galatasaray"),
                              subtitle: Text("21.00"),
                            ),
                            ListTile(
                              leading: Icon(Icons.sports_soccer),
                              title: Text("Fenerbahçe vs Galatasaray"),
                              subtitle: Text("21.00"),
                            ),
                            ListTile(
                              leading: Icon(Icons.sports_soccer),
                              title: Text("Fenerbahçe vs Galatasaray"),
                              subtitle: Text("21.00"),
                            ),
                            ListTile(
                              leading: Icon(Icons.sports_soccer),
                              title: Text("Fenerbahçe vs Galatasaray"),
                              subtitle: Text("21.00"),
                            ),
                            ListTile(
                              leading: Icon(Icons.sports_soccer),
                              title: Text("Fenerbahçe vs Galatasaray"),
                              subtitle: Text("21.00"),
                            ),
                            ListTile(
                              leading: Icon(Icons.sports_soccer),
                              title: Text("Fenerbahçe vs Galatasaray"),
                              subtitle: Text("21.00"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                )
              ],
            ),
          ]
        ),
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                SizedBox(
                    width: 58
                ),
                IconButton(
                  onPressed: () {print("Previous coupon...");},
                  icon: Icon(Icons.arrow_back_ios_sharp, size: 30),
                ),
                SizedBox(
                  width: 20
                ),
                ElevatedButton(
                  onPressed: () {print("Selected coupon is saved.");},
                  child: Text(
                    "Save coupon",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                    width: 20
                ),
                IconButton(
                  onPressed: () {print("Next coupon...");},
                  icon: Icon(Icons.arrow_forward_ios_sharp, size: 30),
                ),
              ],
            ),
            SizedBox(
              height: 35
            ),
          ],
        ),
      ),
    );
  }
}