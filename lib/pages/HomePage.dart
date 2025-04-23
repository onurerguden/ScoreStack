import 'package:flutter/material.dart';
import '../widgets/MatchTile.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: 40),
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
                        children: [
                          MatchTile(homeTeam: "Fenerbahçe", awayTeam: "Galatasaray", time: "19.00"),
                          MatchTile(homeTeam: "Fenerbahçe", awayTeam: "Galatasaray", time: "19.00"),
                          MatchTile(homeTeam: "Fenerbahçe", awayTeam: "Galatasaray", time: "19.00"),
                          MatchTile(homeTeam: "Fenerbahçe", awayTeam: "Galatasaray", time: "19.00"),
                          MatchTile(homeTeam: "Fenerbahçe", awayTeam: "Galatasaray", time: "19.00"),
                          MatchTile(homeTeam: "Fenerbahçe", awayTeam: "Galatasaray", time: "19.00"),
                          MatchTile(homeTeam: "Fenerbahçe", awayTeam: "Galatasaray", time: "19.00"),
                          MatchTile(homeTeam: "Fenerbahçe", awayTeam: "Galatasaray", time: "19.00"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
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
                      child: Text(
                        "Favorite Team's Matches",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          MatchTile(homeTeam: "Fenerbahçe", awayTeam: "Galatasaray", time: "19.00"),
                          MatchTile(homeTeam: "Fenerbahçe", awayTeam: "Galatasaray", time: "19.00"),
                          MatchTile(homeTeam: "Fenerbahçe", awayTeam: "Galatasaray", time: "19.00"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}