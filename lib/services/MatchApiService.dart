import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MatchApiService {
  static const String _apiKey =
      '64c672feb9msh32fff8f59fc234dp11c6cbjsndd5b38cb5943';
  static const String _host = 'api-football-v1.p.rapidapi.com';
  static const String _baseUrl = 'https://api-football-v1.p.rapidapi.com/v3';

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> fetchMatchesForLeagues() async {
    List<Map<String, dynamic>> leagues = [
      {'id': 203, 'name': 'Süper Lig'},
      {'id': 39, 'name': 'Premier League'},
      {'id': 140, 'name': 'La Liga'},
    ];

    for (var league in leagues) {
      await _fetchMatchesForLeague(league['id'], league['name']);
    }
    await _deletePastMatches();
  }


  Future<void> _fetchMatchesForLeague(int leagueId, String leagueName) async {
    try {
      final now = DateTime.now();
      final toDate = now.add(Duration(days: 2));

      final url = Uri.parse(
          '$_baseUrl/fixtures?league=$leagueId&season=2024&from=${_formatDate(now)}&to=${_formatDate(toDate)}'
      );

      final response = await http.get(
        url,
        headers: {'X-RapidAPI-Host': _host, 'X-RapidAPI-Key': _apiKey},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Fetched matches for $leagueName: ${data['response'].length}');

        for (var match in data['response']) {
          String homeName = match['teams']['home']['name'];
          String awayName = match['teams']['away']['name'];
          String date = match['fixture']['date'];

          int fixtureId = match['fixture']['id'];
          Map<String, double> odds = await fetchOdds(fixtureId);

          DocumentReference homeTeamRef = await _getOrCreateTeam(homeName);
          DocumentReference awayTeamRef = await _getOrCreateTeam(awayName);

          final existingMatch =
              await FirebaseFirestore.instance
                  .collection('matches')
                  .where('homeTeam', isEqualTo: homeTeamRef)
                  .where('awayTeam', isEqualTo: awayTeamRef)
                  .where(
                    'matchTime',
                    isEqualTo: Timestamp.fromDate(DateTime.parse(date)),
                  )
                  .where('league', isEqualTo: leagueName)
                  .get();

          if (existingMatch.docs.isNotEmpty) {
            print('Match already exists: $homeName vs $awayName');
            continue;
          }

          await FirebaseFirestore.instance.collection('matches').add({
            'homeTeam': homeTeamRef,
            'awayTeam': awayTeamRef,
            'matchTime': Timestamp.fromDate(DateTime.parse(date)),
            'homeOdds': odds['home'] ?? 0.0,
            'drawOdds': odds['draw'] ?? 0.0,
            'awayOdds': odds['away'] ?? 0.0,
            'league': leagueName,
            'fixtureId' : fixtureId,
          });

          print('Saved match: $homeName vs $awayName');
        }
      } else {
        print(
          'Failed to fetch matches for $leagueName: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching matches for $leagueName: $e');
    }
  }

  Future<Map<String, double>> fetchOdds(int fixtureId) async {
    final url = Uri.parse('$_baseUrl/odds?fixture=$fixtureId');

    final response = await http.get(
      url,
      headers: {'X-RapidAPI-Host': _host, 'X-RapidAPI-Key': _apiKey},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['response'].isNotEmpty) {
        var oddsData =
            data['response'][0]['bookmakers'][0]['bets'][0]['values'];

        double homeOdds = double.tryParse(oddsData[0]['odd']) ?? 0.0;
        double drawOdds = double.tryParse(oddsData[1]['odd']) ?? 0.0;
        double awayOdds = double.tryParse(oddsData[2]['odd']) ?? 0.0;

        return {'home': homeOdds, 'draw': drawOdds, 'away': awayOdds};
      }
    }
    return {'home': 0.0, 'draw': 0.0, 'away': 0.0};
  }

  Future<DocumentReference> _getOrCreateTeam(String teamName) async {
    final teamCollection = FirebaseFirestore.instance.collection('team');
    final querySnapshot =
        await teamCollection.where('name', isEqualTo: teamName).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.reference;
    } else {
      final newTeamDoc = await teamCollection.add({'name': teamName});
      return newTeamDoc;
    }
  }
}

Future<void> updateZeroOddsMatches() async {
  final matchesSnapshot =
      await FirebaseFirestore.instance.collection('matches').get();
  for (var matchDoc in matchesSnapshot.docs) {
    final matchData = matchDoc.data();
    if (matchData['homeOdds'] == 0.0 &&
        matchData['drawOdds'] == 0.0 &&
        matchData['awayOdds'] == 0.0 &&
        matchData.containsKey('fixtureId')) {

      final fixtureId = matchData['fixtureId'];

      final newOdds = await MatchApiService().fetchOdds(fixtureId);
      if (newOdds['home'] != 0.0 || newOdds['draw'] != 0.0 || newOdds['away'] != 0.0) {
        await matchDoc.reference.update({
          'homeOdds': newOdds['home'],
          'drawOdds': newOdds['draw'],
          'awayOdds': newOdds['away'],
        });
        print('Updated odds for match: $fixtureId');
      } else {
        print('Still no odds for match: $fixtureId');
      }

    }
  }
}
Future<void> _deletePastMatches() async {
  final now = DateTime.now();
  final matches = await FirebaseFirestore.instance.collection('matches').get();

  for (var doc in matches.docs) {
    final matchData = doc.data();
    if (matchData.containsKey('matchTime')) {
      Timestamp matchTime = matchData['matchTime'];
      if (matchTime.toDate().isBefore(now)) {
        await doc.reference.delete();
        print('Deleted past match: ${doc.id}');
      }
    }
  }
}
