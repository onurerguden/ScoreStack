import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MatchApiService {
  int fetchMatchsinXdays = 3;
  static const String _apiKey =
      '64c672feb9msh32fff8f59fc234dp11c6cbjsndd5b38cb5943';
  static const String _host = 'api-football-v1.p.rapidapi.com';
  static const String _baseUrl = 'https://api-football-v1.p.rapidapi.com/v3';

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<List<String>> fetchLast5Matches(int teamId) async {
    final url = Uri.parse('$_baseUrl/fixtures?team=$teamId&season=2024'); // DEĞİŞTİ

    final response = await http.get(
      url,
      headers: {'X-RapidAPI-Host': _host, 'X-RapidAPI-Key': _apiKey},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<String> matches = [];

      for (var fixture in data['response']) {
        // Yalnızca biten maçlar
        if (fixture['fixture']['status']['short'] != 'FT') continue;

        bool isHome = fixture['teams']['home']['id'] == teamId;
        int homeGoals = fixture['goals']['home'];
        int awayGoals = fixture['goals']['away'];

        if (homeGoals == awayGoals) {
          matches.add('D');
        } else if ((isHome && homeGoals > awayGoals) || (!isHome && awayGoals > homeGoals)) {
          matches.add('W');
        } else {
          matches.add('L');
        }
      }

      // En son 5 maçı al
      if (matches.length > 5) {
        matches = matches.sublist(matches.length - 5);
      }

      return matches;
    } else {
      print('Failed to fetch last 5 matches for teamId $teamId');
      return [];
    }
  }

  Future<void> fetchMatchesForLeagues() async {
    List<Map<String, dynamic>> leagues = [
      {'id': 203, 'name': 'Süper Lig'},
      {'id': 39, 'name': 'Premier League'},
      {'id': 140, 'name': 'La Liga'},
    ];

    for (var league in leagues) {
      await _fetchMatchesForLeague(league['id'], league['name']);
      await Future.delayed(Duration(milliseconds: 200)); // Add delay
    }
    await _deletePastMatches();
  }


  Future<void> _fetchMatchesForLeague(int leagueId, String leagueName) async {
    try {
      final now = DateTime.now();
      final toDate = now.add(Duration(days: fetchMatchsinXdays));

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
          String homeLogo = match['teams']['home']['logo'];
          String awayName = match['teams']['away']['name'];
          String awayLogo = match['teams']['away']['logo'];
          int homeTeamId = match['teams']['home']['id'];
          int awayTeamId = match['teams']['away']['id'];
          String date = match['fixture']['date'];

          String country = match['league']['country'];
          String leagueNameFromApi = match['league']['name'];

          int fixtureId = match['fixture']['id'];
          Map<String, double> odds = await fetchOdds(fixtureId);

          DocumentReference homeTeamRef = await _getOrCreateTeam(homeName, homeLogo, country, leagueNameFromApi, homeTeamId);
          DocumentReference awayTeamRef = await _getOrCreateTeam(awayName, awayLogo, country, leagueNameFromApi, awayTeamId);

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
            'homeTeamName': homeName,
            'awayTeamName': awayName,
            'matchTime': Timestamp.fromDate(DateTime.parse(date)),
            'homeOdds': odds['home'] ?? 0.0,
            'drawOdds': odds['draw'] ?? 0.0,
            'awayOdds': odds['away'] ?? 0.0,
            'league': leagueName,
            'fixtureId': fixtureId,
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

  Future<DocumentReference> _getOrCreateTeam(String teamName, String logoUrl, String country, String league, int teamId) async {
    final teamCollection = FirebaseFirestore.instance.collection('team');
    final querySnapshot = await teamCollection.where('name', isEqualTo: teamName).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.reference;
    } else {
      final last5Matches = await fetchLast5Matches(teamId);

      final newTeamDoc = await teamCollection.add({
        'name': teamName,
        'logoUrl': logoUrl,
        'country': country,
        'league': league,
        'last5Matches': last5Matches,
      });
      print('Created new team: $teamName');
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
