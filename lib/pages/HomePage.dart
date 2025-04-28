import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scorestack/services/MatchService.dart';
import '../widgets/MatchTile.dart';
import '../models/Match.dart';
import '../services/MatchApiService.dart';
import '../services/UpdateCheckerService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final MatchService _matchService = MatchService();
  late Future<List<Match>> _matchesFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    checkAndUpdateMatches();
  }

  void checkAndUpdateMatches() async {
    if (await UpdateCheckerService.shouldUpdate()) {
      setState(() {
        _isLoading = true;
      });
      print("[HomePage]  API'den veri çekiliyor...");
      await MatchApiService().fetchMatchesForLeagues();
      await UpdateCheckerService.saveLastUpdateTime();
      print("[HomePage]  Yeni güncelleme zamanı kaydedildi.");
    } else {
      print("[HomePage]  API çağrılmadı, local veriler kullanılacak.");

    }

    setState(() {
      _isLoading=false;
      _matchesFuture = _matchService.fetchMatches();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.green[800]),
                      SizedBox(height: 20),
                      Text(
                        "Yeni maçlar yükleniyor...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
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
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(child: _matchService.buildMatchList()),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          alignment: Alignment.topCenter,
                          width: 390,
                          height: 255,
                          color: Colors.lightGreen,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                color: Colors.green[800],
                                child: Text(
                                  "Favorite Team's Matches",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
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
                                      league: "Süperlig",
                                    ),
                                    MatchTile(
                                      homeTeam: "Fenerbahçe",
                                      awayTeam: "Beşiktaş",
                                      time: "19.00",
                                      homeOdds: 2.05,
                                      drawOdds: 3.10,
                                      awayOdds: 2.80,
                                      league: "Türkiye Kupası",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
