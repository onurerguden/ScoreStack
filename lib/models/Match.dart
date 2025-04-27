import 'package:cloud_firestore/cloud_firestore.dart';

class Match {
  final DocumentReference homeTeamRef;
  final DocumentReference awayTeamRef;
  final DateTime matchTime;
  final double homeOdds;
  final double drawOdds;
  final double awayOdds;

  Match({
    required this.homeTeamRef,
    required this.awayTeamRef,
    required this.matchTime,
    required this.homeOdds,
    required this.drawOdds,
    required this.awayOdds,
  });


  String get matchTimeFormatted => 'Date:  ${matchTime.day}/${matchTime.month} Time: ${matchTime.hour}:${matchTime.minute}';


  factory Match.fromMap(Map<String, dynamic> map) {
    if (map['matchTime'] == null) {
      throw Exception('MatchTime is missing');
    }
    return Match(
      homeTeamRef: map['homeTeam'] as DocumentReference,
      awayTeamRef: map['awayTeam'] as DocumentReference,
      matchTime: (map['matchTime'] as Timestamp).toDate(),
      homeOdds: (map['homeOdds'] as num).toDouble(),
      drawOdds: (map['drawOdds'] as num).toDouble(),
      awayOdds: (map['awayOdds'] as num).toDouble(),
    );
  }
}