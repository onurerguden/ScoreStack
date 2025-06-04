import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Coupon.dart';
import '../services/GlobalLog.dart';

class Match {
  final DocumentReference? homeTeamRef;
  final DocumentReference? awayTeamRef;
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


Future<List<Coupon>> getCoupons() async {
  final coupons = await FirebaseFirestore.instance.collection("coupons").get();

  return coupons.docs.map((doc) {
    final matches = (doc["matches"] as List).map((matchMap) {
      return CouponItem(
        match: Match(
          homeTeamRef: null,
          awayTeamRef: null,
          homeTeamName: matchMap["team1"],
          awayTeamName: matchMap["team2"],
          matchTime: DateTime.parse(matchMap['startTime']),
          homeOdds: matchMap['odd'],
          drawOdds: matchMap['odd'],
          awayOdds: matchMap['odd'],
          league: 'Unknown',
        ),
        selectedResult: 1,
      );
    }).toList();

    return Coupon.create(matches, title: doc['title'] ?? 'Coupon');
  }).toList();
}
