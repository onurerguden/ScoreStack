import 'package:flutter/material.dart';

class MatchTile extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String time;
  final double homeOdds;
  final double drawOdds;
  final double awayOdds;
  final String league;

  const MatchTile({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.time,
    required this.homeOdds,
    required this.drawOdds,
    required this.awayOdds,
    required this.league
  });

  String getLeagueLogo(String league) {
    switch (league) {
      case 'Süper Lig':
        return 'assets/logos/superLeagueLogo.png';
      case 'Premier League':
        return 'assets/logos/premierLeagueLogo.png';
      case 'La Liga':
        return 'assets/logos/laLigaLogo.png';
      default:
        return  'assets/images/ScoreStackLogo4-removebg-preview.png';// fallback
    }
  }

  String _formatOdds(double odds) {
    return odds > 0 ? odds.toString() : "-";
  }

  @override
  Widget build(BuildContext context) {
    final bool oddsNotAvailable =
        homeOdds == 0 && drawOdds == 0 && awayOdds == 0;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Container(
          child: Image.asset(
            getLeagueLogo(league),
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),

        title: Text(
          "$homeTeam vs $awayTeam",
          style: TextStyle(fontWeight: FontWeight.w800,fontSize: 14.5),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            oddsNotAvailable
                ? Text(
                  "Odds are not opened for this match yet!",
                  style: TextStyle(
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                )
                : Row(
                  children: [
                    Text(
                      "Home: ${_formatOdds(homeOdds)}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Draw: ${_formatOdds(drawOdds)}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Away: ${_formatOdds(awayOdds)}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            SizedBox(height: 2),
            Text(time, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
