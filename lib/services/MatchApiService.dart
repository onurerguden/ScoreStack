import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//SARP DEMİRTAS - 20220601016
//ONUR ERGÜDEN - 20220601030

class MatchApiService {
  int fetchMatchsinXdays = 1;
  static const String _apiKey =
      '2fb2b575b5msh4cbb2a0204661dep1b2879jsn33d0c3db9ba2';
  static const String _host = 'api-football-v1.p.rapidapi.com';
  static const String _baseUrl = 'https://api-football-v1.p.rapidapi.com/v3';

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<http.Response> _getWithRetry(Uri url, {int maxRetries = 3}) async {
    int attempt = 0;
    while (true) {
      final response = await http.get(
        url,
        headers: {'X-RapidAPI-Host': _host, 'X-RapidAPI-Key': _apiKey},
      );
      if (response.statusCode != 429 || attempt >= maxRetries) {
        return response;
      }
      final delaySec = 1 << attempt;
      print('429 received, retrying in ${delaySec}s (attempt ${attempt + 1})');
      await Future.delayed(Duration(seconds: delaySec));
      attempt++;
    }
  }

  Future<void> _deletePastMatches() async {
    final now = DateTime.now();
    final batch = FirebaseFirestore.instance.batch();
    final oldMatches =
        await FirebaseFirestore.instance
            .collection('matches')
            .where('matchTime', isLessThan: Timestamp.fromDate(now))
            .get();
    for (var doc in oldMatches.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    print('Deleted ${oldMatches.docs.length} past matches in batch');
  }

  static int getResult() {
    final random = Random();
    return random.nextInt(3);
  }

  Future<List<String>> fetchLast5Matches(int teamId) async {
    final url = Uri.parse('$_baseUrl/fixtures?team=$teamId&season=2025');

    final response = await _getWithRetry(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<String> matches = [];

      for (var fixture in data['response']) {
        if (fixture['fixture']['status']['short'] != 'FT') continue;

        bool isHome = fixture['teams']['home']['id'] == teamId;
        int homeGoals = fixture['goals']['home'];
        int awayGoals = fixture['goals']['away'];

        if (homeGoals == awayGoals) {
          matches.add('D');
        } else if ((isHome && homeGoals > awayGoals) ||
            (!isHome && awayGoals > homeGoals)) {
          matches.add('W');
        } else {
          matches.add('L');
        }
        if (matches.length >= 5) break;
      }

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
      {'id': 71, 'name': 'Brasileiro Serie A'},
      {'id': 909, 'name': 'MLS'},
      {'id': 203, 'name': 'Süper Lig'},
      {'id': 39, 'name': 'Premier League'},
      {'id': 140, 'name': 'La Liga'},
    ];

    await _deletePastMatches();
    for (var league in leagues) {
      await _fetchMatchesForLeague(league['id'], league['name']);
      await Future.delayed(Duration(seconds: 1));
    }
  }

  Future<void> _fetchMatchesForLeague(int leagueId, String leagueName) async {
    try {
      final now = DateTime.now();

      final Set<int> updatedTeamIds = {};
      final Map<int, DocumentReference> teamRefs = {};
      final toDate = now.add(Duration(days: fetchMatchsinXdays));

      final url = Uri.parse(
        '$_baseUrl/fixtures?league=$leagueId&season=2025&from=${_formatDate(now)}&to=${_formatDate(toDate)}',
      );

      final response = await _getWithRetry(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Fetched matches for $leagueName: ${data['response'].length}');

        final batch = FirebaseFirestore.instance.batch();

        final List<DocumentReference> newMatchRefs = [];

        for (var match in data['response']) {
          String homeName = match['teams']['home']['name'];
          String homeLogo = match['teams']['home']['logo'];
          String awayName = match['teams']['away']['name'];
          String awayLogo = match['teams']['away']['logo'];
          int homeTeamId = match['teams']['home']['id'];
          int awayTeamId = match['teams']['away']['id'];
          String date = match['fixture']['date'];
          final matchDate = DateTime.parse(date);
          if (matchDate.isBefore(now)) continue;

          String country = match['league']['country'];
          String leagueNameFromApi = match['league']['name'];

          int fixtureId = match['fixture']['id'];
          Map<String, double> odds = await fetchOdds(fixtureId);

          DocumentReference homeTeamRef = await _getOrCreateTeam(
            homeName,
            homeLogo,
            country,
            leagueNameFromApi,
            homeTeamId,
          );
          DocumentReference awayTeamRef = await _getOrCreateTeam(
            awayName,
            awayLogo,
            country,
            leagueNameFromApi,
            awayTeamId,
          );

          updatedTeamIds.add(homeTeamId);
          teamRefs[homeTeamId] = homeTeamRef;
          updatedTeamIds.add(awayTeamId);
          teamRefs[awayTeamId] = awayTeamRef;

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

          final matchDocRef =
              FirebaseFirestore.instance.collection('matches').doc();
          batch.set(matchDocRef, {
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

          newMatchRefs.add(matchDocRef);

          print('Saved match: $homeName vs $awayName');
        }

        await batch.commit();

        final today = DateTime.now();
        for (final matchRef in newMatchRefs) {
          final snapshot = await matchRef.get();
          final data = snapshot.data() as Map<String, dynamic>;
          final matchTime = (data['matchTime'] as Timestamp).toDate();
          if (matchTime.year == today.year &&
              matchTime.month == today.month &&
              matchTime.day == today.day) {
            bool needsOdds =
                (data['homeOdds'] == 0.0 ||
                    data['drawOdds'] == 0.0 ||
                    data['awayOdds'] == 0.0);
            if (needsOdds && data.containsKey('fixtureId')) {
              final newOdds = await fetchOdds(data['fixtureId']);
              await matchRef.update({
                'homeOdds': newOdds['home']!,
                'drawOdds': newOdds['draw']!,
                'awayOdds': newOdds['away']!,
              });
              print('Updated missing odds for match: ${data['fixtureId']}');
            }
          }
        }

        Map<int, List<String>> teamResults = {};

        for (var match in data['response']) {
          if (match['fixture']['status']['short'] != 'FT') continue;

          int homeId = match['teams']['home']['id'];
          int awayId = match['teams']['away']['id'];
          int homeGoals = match['goals']['home'];
          int awayGoals = match['goals']['away'];

          String homeResult =
              homeGoals == awayGoals
                  ? 'D'
                  : homeGoals > awayGoals
                  ? 'W'
                  : 'L';
          String awayResult =
              homeGoals == awayGoals
                  ? 'D'
                  : awayGoals > homeGoals
                  ? 'W'
                  : 'L';

          if (!teamResults.containsKey(homeId)) {
            final doc = await teamRefs[homeId]!.get();
            final existing =
                (doc['last5Matches'] as List?)?.cast<String>() ?? [];
            teamResults[homeId] = existing;
          }
          if (!teamResults.containsKey(awayId)) {
            final doc = await teamRefs[awayId]!.get();
            final existing =
                (doc['last5Matches'] as List?)?.cast<String>() ?? [];
            teamResults[awayId] = existing;
          }

          if (teamResults[homeId]!.isEmpty ||
              teamResults[homeId]!.first != homeResult) {
            teamResults[homeId]!.insert(0, homeResult);
          }
          if (teamResults[awayId]!.isEmpty ||
              teamResults[awayId]!.first != awayResult) {
            teamResults[awayId]!.insert(0, awayResult);
          }

          if (teamResults[homeId]!.length > 5) {
            teamResults[homeId] = teamResults[homeId]!.sublist(0, 5);
          }
          if (teamResults[awayId]!.length > 5) {
            teamResults[awayId] = teamResults[awayId]!.sublist(0, 5);
          }
        }

        for (final entry in teamResults.entries) {
          final teamId = entry.key;
          final last5 = entry.value;
          if (teamRefs.containsKey(teamId)) {
            await teamRefs[teamId]!.update({'last5Matches': last5});
          }
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

    final response = await _getWithRetry(url);

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

  Future<DocumentReference> _getOrCreateTeam(
    String teamName,
    String logoUrl,
    String country,
    String league,
    int teamId,
  ) async {
    final teamCollection = FirebaseFirestore.instance.collection('team');
    final querySnapshot =
        await teamCollection.where('name', isEqualTo: teamName).get();

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
      if (newOdds['home'] != 0.0 ||
          newOdds['draw'] != 0.0 ||
          newOdds['away'] != 0.0) {
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
