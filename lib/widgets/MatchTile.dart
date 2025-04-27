import 'package:flutter/material.dart';

class MatchTile extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String time;
  final double homeOdds;
  final double drawOdds;
  final double awayOdds;

  MatchTile({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.time,
    required this.homeOdds,
    required this.drawOdds,
    required this.awayOdds,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        leading: Icon(Icons.sports_soccer),
        title: Text(
          "$homeTeam vs $awayTeam",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Home: $homeOdds", style: TextStyle(fontSize: 14)),
                SizedBox(width: 8),
                Text("Draw: $drawOdds", style: TextStyle(fontSize: 14)),
                SizedBox(width: 8),
                Text("A️way: $awayOdds", style: TextStyle(fontSize: 14)),
              ],
            ),
            SizedBox(height: 2),
            Text(time),
          ],
        ),
      ),
    );
  }
}