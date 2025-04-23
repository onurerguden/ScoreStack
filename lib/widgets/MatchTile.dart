import 'package:flutter/material.dart';

class MatchTile extends StatelessWidget{
  String homeTeam;
  String awayTeam;
  String time;

   MatchTile({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.time,
});

  Widget build (BuildContext context){
    return ListTile(
      leading: Icon(Icons.sports_soccer),
      title: Text("$homeTeam vs $awayTeam"),
      subtitle: Text(time),
    );
  }
}