import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Match.dart';
import '../widgets/MatchTile.dart';
import '../services/FavoriteService.dart';

class MatchService {
  final CollectionReference matchesCollection = FirebaseFirestore.instance
      .collection('matches');

  Future<List<Match>> fetchMatches() async {
    try {
      //ORDER THE MATCHES ACCORDİNG TO THE CLOSEST MATCH TİME
      QuerySnapshot snapshot =
          await matchesCollection.orderBy("matchTime").get();
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
          return Center(child: CircularProgressIndicator(color: Colors.green));
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
              return MatchTile(
                homeTeam: match.homeTeamName,
                awayTeam: match.awayTeamName,
                time: match.matchTimeFormatted,
                homeOdds: match.homeOdds,
                drawOdds: match.drawOdds,
                awayOdds: match.awayOdds,
                league: match.league,
              );
            },
          );
        }
      },
    );
  }

  Widget buildFavoriteMatchList() {
    return FutureBuilder<List<Match>>(
      future: fetchMatches(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.green));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No matches found.'));
        } else {
          final matches = snapshot.data!;

          return FutureBuilder<List<String>>(
            future: FavoriteService.getFavoriteTeamNames(),
            builder: (context, favoriteSnapshot) {
              if (!favoriteSnapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.green),
                );
              }

              final favoriteTeams = favoriteSnapshot.data!;

              final favoriteMatches =
                  matches
                      .where(
                        (match) =>
                            favoriteTeams.contains(match.homeTeamName) ||
                            favoriteTeams.contains(match.awayTeamName),
                      )
                      .toList();

              if (favoriteMatches.isEmpty) {
                return Center(
                  child: Text(
                    'No matches found for your favorite teams.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: favoriteMatches.length,
                itemBuilder: (context, index) {
                  final match = favoriteMatches[index];
                  return MatchTile(
                    homeTeam: match.homeTeamName,
                    awayTeam: match.awayTeamName,
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
        }
      },
    );
  }
}
