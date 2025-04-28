import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Match.dart';
import '../widgets/MatchTile.dart';

class MatchService {
  final CollectionReference matchesCollection =
  FirebaseFirestore.instance.collection('matches');

  Future<List<Match>> fetchMatches() async {
    try {
      //ORDER THE MATCHES ACCORDİNG TO THE CLOSEST MATCH TİME
      QuerySnapshot snapshot = await matchesCollection.orderBy("matchTime").get();
      print('Fetched documents: ${snapshot.docs.length}');

      List<Match> matches = [];

      for (var doc in snapshot.docs) {
        final rawData = doc.data();
        if (rawData == null) {
          print('Warning: Null document data!');
          continue;
        }

        Map<String, dynamic> data = rawData as Map<String, dynamic>;

        try {
          Match match = Match.fromMap(data);
          matches.add(match);
        } catch (e) {
          print('Error parsing match: $e');
        }
      }

      print('Successfully parsed matches: ${matches.length}');
      return matches;
    } catch (e) {
      print('Error fetching matches: $e');
      return [];
    }
  }



  Widget buildMatchList() {
    return FutureBuilder<List<Match>>(
      future: fetchMatches(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.green,));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No matches found.'));
        } else {
          final matches = snapshot.data!;
          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return FutureBuilder<DocumentSnapshot>(
                future: match.homeTeamRef.get(),
                builder: (context, homeTeamSnapshot) {
                  if (!homeTeamSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator(color: Colors.green,));
                  }
                  final homeData = homeTeamSnapshot.data!.data() as Map<String, dynamic>;
                  final homeName = homeData['name'] ?? 'Unknown Home';

                  return FutureBuilder<DocumentSnapshot>(
                    future: match.awayTeamRef.get(),
                    builder: (context, awayTeamSnapshot) {
                      if (!awayTeamSnapshot.hasData) {
                        return Center(child: CircularProgressIndicator(color: Colors.green,));
                      }
                      final awayData = awayTeamSnapshot.data!.data() as Map<String, dynamic>;
                      final awayName = awayData['name'] ?? 'Unknown Away';

                      return MatchTile(
                        homeTeam: homeName,
                        awayTeam: awayName,
                        time: match.matchTimeFormatted,
                        homeOdds: match.homeOdds,
                        drawOdds: match.drawOdds,
                        awayOdds: match.awayOdds,
                        league: match.league,
                      );
                    },
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}