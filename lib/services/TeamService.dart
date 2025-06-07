import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Team.dart';

//SARP DEMİRTAŞ - 20220601016
//ONUR ERGÜDEN - 20220601030

class TeamService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Team> fetchTeam(DocumentReference teamRef) async {
    try {
      DocumentSnapshot snapshot = await teamRef.get();

      if (!snapshot.exists) {
        throw Exception('Team not found');
      }

      final data = snapshot.data() as Map<String, dynamic>;

      return Team.fromMap({...data, 'reference': snapshot.reference});
    } catch (e) {
      throw Exception('Failed to fetch team: $e');
    }
  }
}