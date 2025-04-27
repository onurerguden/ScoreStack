import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  final String name;
  final DocumentReference reference;
  Team ({required this.name, required this.reference});


  factory Team.fromMap(Map<String,dynamic> map){
    return Team(
        name: map['name'],
        reference: map['reference'] as DocumentReference,
    );
  }
}
