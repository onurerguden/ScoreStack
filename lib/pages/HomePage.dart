import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scorestack/services/MatchService.dart';
import '../widgets/MatchTile.dart';
import '../models/Match.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final MatchService _matchService = MatchService();
  late Future<List<Match>> _matchesFuture;

  void initState() {
    super.initState();
    _matchesFuture = _matchService.fetchMatches();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: 20),
              Container(
                alignment: Alignment.topCenter,
                width: 390,
                height: 400,
                color: CupertinoColors.systemGrey3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      color: Color(0xFF2C2C2C),
                      child: Text(
                        "Upcoming Matches",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(child: _matchService.buildMatchList()),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.topCenter,
                width: 390,
                height: 255,
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
                          MatchTile(
                            homeTeam: "Fenerbahçe",
                            awayTeam: "Galatasaray",
                            time: "19.00",
                            homeOdds: 2.05,
                            drawOdds: 3.10,
                            awayOdds: 2.80,
                          ),
                          MatchTile(
                            homeTeam: "Fenerbahçe",
                            awayTeam: "Beşiktaş",
                            time: "19.00",
                            homeOdds: 2.05,
                            drawOdds: 3.10,
                            awayOdds: 2.80,
                          )
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
      backgroundColor: Colors.black54,
    );
  }
}
