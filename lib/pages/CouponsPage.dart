import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                onPressed: skip,
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


class Team {
  final String name;
  final DocumentReference reference;
  final String logoUrl;
  final String country;
  final String league;
  final List<String> last5Matches;

  Team({
    required this.name,
    required this.logoUrl,
    required this.country,
    required this.league,
    required this.reference,
    required this.last5Matches,
  });

  factory Team.fromMap(
    Map<String, dynamic> map, {
    DocumentReference? reference,
  }) {
    return Team(
      name: map['name'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
      country: map['country'] ?? '',
      league: map['league'] ?? '',
      last5Matches: List<String>.from(map['last5Matches'] ?? []),
      reference: reference!,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'logoUrl': logoUrl,
      'country': country,
      'league': league,
      'last5Matches': last5Matches,
    };
  }
}

class Match {
  final DocumentReference homeTeamRef;
  final DocumentReference awayTeamRef;
  final String homeTeamName;
  final String awayTeamName;
  final DateTime matchTime;
  final double homeOdds;
  final double drawOdds;
  final double awayOdds;
  final String league;

  Match({
    required this.homeTeamRef,
    required this.awayTeamRef,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.matchTime,
    required this.homeOdds,
    required this.drawOdds,
    required this.awayOdds,
    required this.league,
  });

  String get matchTimeFormatted =>
      'Date:  ${matchTime.day}/${matchTime.month} Time: ${matchTime.hour}:${matchTime.minute}';

  factory Match.fromMap(Map<String, dynamic> map) {
    if (map['matchTime'] == null) {
      throw Exception('MatchTime is missing');
    }
    return Match(
      homeTeamRef: map['homeTeam'] as DocumentReference,
      awayTeamRef: map['awayTeam'] as DocumentReference,
      homeTeamName: map['homeTeamName'] ?? 'Unknown Home',
      awayTeamName: map['awayTeamName'] ?? 'Unknown Away',
      matchTime: (map['matchTime'] as Timestamp).toDate(),
      homeOdds: (map['homeOdds'] as num).toDouble(),
      drawOdds: (map['drawOdds'] as num).toDouble(),
      awayOdds: (map['awayOdds'] as num).toDouble(),
      league: map['league'] ?? 'Unknown League',
    );
  }
}

class CouponItem {
  final Match match;
  final int selectedResult;

  CouponItem({required this.match, required this.selectedResult});

  double getSelectedOdd() {
    switch (selectedResult) {
      case 1:
        return match.homeOdds;
      case 0:
        return match.drawOdds;
      case 2:
        return match.awayOdds;
      default:
        throw Exception("No such result error!");
    }
  }
}

class Coupon {
  final List<CouponItem> selectedMatches;
  final double totalOdd;

  Coupon({required this.selectedMatches, required this.totalOdd});

  factory Coupon.create(List<CouponItem> matches) {
    double total = 1.0;
    for (var item in matches) {
      total = total * item.getSelectedOdd();
    }
    return Coupon(selectedMatches: matches, totalOdd: total);
  }
}

final demoMatch = Match(
  homeTeamRef: FirebaseFirestore.instance.doc('teams/home'),
  awayTeamRef: FirebaseFirestore.instance.doc('teams/away'),
  homeTeamName: 'Fenerbahçe',
  awayTeamName: 'Galatasaray',
  matchTime: DateTime.now().add(Duration(days: 1)),
  homeOdds: 1.95,
  drawOdds: 3.20,
  awayOdds: 2.75,
  league: 'Süper Lig',
);

final demoCoupon = Coupon.create([
  CouponItem(match: demoMatch, selectedResult: 1),
]);

final demoCoupon5Matches = Coupon.create([
  CouponItem(
    match: Match(
      homeTeamRef: FirebaseFirestore.instance.doc('teams/nice'),
      awayTeamRef: FirebaseFirestore.instance.doc('teams/psg'),
      homeTeamName: 'Nice',
      awayTeamName: 'PSG',
      matchTime: DateTime.now().add(Duration(days: 1)),
      homeOdds: 3.20,
      drawOdds: 3.00,
      awayOdds: 1.65,
      league: 'Ligue 1',
    ),
    selectedResult: 2,
  ),
  CouponItem(
    match: Match(
      homeTeamRef: FirebaseFirestore.instance.doc('teams/frankfurt'),
      awayTeamRef: FirebaseFirestore.instance.doc('teams/leverkusen'),
      homeTeamName: 'Frankfurt',
      awayTeamName: 'Leverkusen',
      matchTime: DateTime.now().add(Duration(days: 1)),
      homeOdds: 2.80,
      drawOdds: 3.20,
      awayOdds: 1.50,
      league: 'Bundesliga',
    ),
    selectedResult: 2,
  ),
  CouponItem(
    match: Match(
      homeTeamRef: FirebaseFirestore.instance.doc('teams/granada'),
      awayTeamRef: FirebaseFirestore.instance.doc('teams/osasuna'),
      homeTeamName: 'Granada',
      awayTeamName: 'Osasuna',
      matchTime: DateTime.now().add(Duration(days: 1)),
      homeOdds: 2.10,
      drawOdds: 2.90,
      awayOdds: 2.50,
      league: 'La Liga',
    ),
    selectedResult: 1,
  ),
  CouponItem(
    match: Match(
      homeTeamRef: FirebaseFirestore.instance.doc('teams/akhmat'),
      awayTeamRef: FirebaseFirestore.instance.doc('teams/lokomotiv'),
      homeTeamName: 'Akhmat',
      awayTeamName: 'Lokomotiv',
      matchTime: DateTime.now().add(Duration(days: 1)),
      homeOdds: 2.75,
      drawOdds: 3.10,
      awayOdds: 2.40,
      league: 'RPL',
    ),
    selectedResult: 0,
  ),
  CouponItem(
    match: Match(
      homeTeamRef: FirebaseFirestore.instance.doc('teams/barcelona'),
      awayTeamRef: FirebaseFirestore.instance.doc('teams/alba'),
      homeTeamName: 'Barcelona',
      awayTeamName: 'Alba Berlin',
      matchTime: DateTime.now().add(Duration(days: 1)),
      homeOdds: 1.45,
      drawOdds: 3.10,
      awayOdds: 3.50,
      league: 'Euroleague',
    ),
    selectedResult: 1,
  ),
]);

class CouponsPage extends StatelessWidget {
  const CouponsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(
      viewportFraction: 0.65,
      initialPage: 1,
    );
    final List<Coupon> coupons = [demoCoupon, demoCoupon5Matches];

    final size = MediaQuery.of(context).size;
    final width = size.width * 0.95;
    final height = size.height * 0.74;
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              alignment: Alignment.topCenter,
              width: width,
              height: height,
              color: CupertinoColors.systemGrey3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: const Color(0xFF2C2C2C),
                    child: Row(
                      children: [
                        SizedBox(width: 28.8),
                        Icon(
                          Icons.request_quote,
                          color: Colors.white,
                          size: 28,
                        ),

                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Current Coupons",
                              style: TextStyle(
                                fontSize: size.width * 0.05,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(width: 46.8),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CouponStack(controller: controller, coupons: coupons),

                          Container(
                            height: 2,
                            margin: EdgeInsets.symmetric(horizontal: 25),
                            color: Colors.black54,
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 12,
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.green[800]!,
                                width: 5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[800],
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(16),
                                  ),
                                  onPressed: () {
                                    controller.previousPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: Icon(
                                    Icons.keyboard_arrow_left_outlined,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[800],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 14,
                                    ),
                                  ),
                                  onPressed: () {
                                    final currentIndex =
                                        controller.page!.round() %
                                        coupons.length;
                                    final coupon = coupons[currentIndex];
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Saved: ${coupon.totalOdd.toStringAsFixed(2)}x | ${coupon.selectedMatches.length} Maç",
                                        ),
                                        duration: Duration(
                                          microseconds: 800000,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Save Coupon!",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[800],
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(16),
                                  ),
                                  onPressed: () {
                                    controller.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    color: Colors.white,
                                    size: 25,
                                  ),
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
            ),
          ),
        ),
      ),
    );
  }
}

class CouponStack extends StatefulWidget {
  final PageController controller;
  final List<Coupon> coupons;

  const CouponStack({
    super.key,
    required this.controller,
    required this.coupons,
  });

  @override
  _CouponStackState createState() => _CouponStackState();
}

class _CouponStackState extends State<CouponStack> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.45,
      child: PageView.builder(
        controller: widget.controller,
        itemCount: widget.coupons.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: widget.controller,
            builder: (context, child) {
              double value = 1.0;
              if (widget.controller.position.haveDimensions) {
                value = (widget.controller.page! - index).abs();
                value = (1 - (value * 0.2)).clamp(0.8, 1);
              }
              final coupon = widget.coupons[index];
              return Center(
                child: Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: SizedBox(
                        width: size.width * 0.9,
                        height: size.height * 0.58,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 6),
                                  Image.asset(
                                    'assets/images/ScoreStackLogo4-removebg-preview.png',
                                    width: 29,
                                    height: 29,
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'Coupon',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 29),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Divider(
                                  thickness: 1.3,
                                  color: Colors.lightGreen,
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: coupon.selectedMatches.length,
                                  itemBuilder: (context, i) {
                                    final item = coupon.selectedMatches[i];
                                    final match = item.match;
                                    String prediction;
                                    switch (item.selectedResult) {
                                      case 1:
                                        prediction = '01';
                                        break;
                                      case 0:
                                        prediction = 'X';
                                        break;
                                      case 2:
                                        prediction = '02';
                                        break;
                                      default:
                                        prediction = '?';
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${match.homeTeamName} - ${match.awayTeamName}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${match.matchTime.day}/${match.matchTime.month} ${match.matchTime.hour}:${match.matchTime.minute.toString().padLeft(2, '0')}  |  Bet: $prediction  | Odd: ${item.getSelectedOdd().toStringAsFixed(2)}',
                                          ),
                                          Divider(thickness: 1.3),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Total Odd: ${coupon.totalOdd.toStringAsFixed(2)}x | ${coupon.selectedMatches.length} Matches',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

