import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  final String name;
  final DocumentReference reference;
  final String logoUrl;
  final String country;
  final String league;
  final List<String> last5Matches;

  Team({
    required this.name,
    required this.logoUrl,
    required this.country,
    required this.league,
    required this.reference,
    required this.last5Matches,
  });

  factory Team.fromMap(Map<String, dynamic> map, {DocumentReference? reference}) {
    return Team(
      name: map['name'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
      country: map['country'] ?? '',
      league: map['league'] ?? '',
      last5Matches: List<String>.from(map['last5Matches'] ?? []),
      reference: reference!,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'logoUrl': logoUrl,
      'country': country,
      'league': league,
      'last5Matches': last5Matches,
    };
  }
}