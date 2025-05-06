import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scorestack/services/MatchService.dart';
import '../models/Match.dart';
import '../services/MatchApiService.dart';
import '../services/UpdateCheckerService.dart';
import '../pages/CouponsPage.dart';

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
      _isLoading = false;
      _matchesFuture = _matchService.fetchMatches();
    });
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                        "New Matches are loading..",
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
                      SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          alignment: Alignment.topCenter,
                          width: size.width * 0.95,
                          height: size.height * 0.46,
                          color: CupertinoColors.systemGrey3,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                color: Color(0xFF2C2C2C),
                                child: Row(
                                  children: [
                                    SizedBox(width: 27.8),
                                    Icon(Icons.calendar_month_rounded, color: Colors.white, size: 28),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Upcoming Matches",
                                          style: TextStyle(
                                            fontSize: size.width * 0.05,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 44.8),
                                  ],
                                ),
                              ),
                              Expanded(child: _matchService.buildMatchList()),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          alignment: Alignment.topCenter,
                          width: size.width * 0.95,
                          height: size.height * 0.265,
                          color: Colors.lightGreen,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                color: Colors.green[800],
                                child: Row(
                                  children: [
                                    SizedBox(width: 27.8,),
                                    Icon(Icons.star, color: Color(0xFFFFC107),size: 28,),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Favorite Team's Matches",
                                          style: TextStyle(
                                            fontSize: size.width * 0.05,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 22.4),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: MatchService().buildFavoriteMatchList(),
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
