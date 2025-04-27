import 'Team.dart';

class Match{
  final Team homeTeam;
  final Team awayTeam;
  final DateTime matchTime;
  final double homeOdds;
  final double drawOdds;
  final double awayOdds;

  Match({
    required this.homeTeam,
    required this.awayTeam,
    required this.matchTime,
    required this.homeOdds,
    required this.drawOdds,
    required this.awayOdds
});

}