import 'package:flutter/material.dart';
import '../models/Team.dart';
import '../widgets/TeamTile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  List<Team> favoriteTeams = [];

  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    final collection = await FirebaseFirestore.instance.collection('team').get();
    final allteams = collection.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Team.fromMap(data, reference: doc.reference);
    }).toList();

    final prefs = await SharedPreferences.getInstance();
    final favoriteNames = prefs.getStringList('favorites') ?? [];

    setState(() {
      favoriteTeams = allteams.where((team) => favoriteNames.contains(team.name)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C2C2C),
        appBar: AppBar(
            title: Text(
              "Profile",
              style: TextStyle(
                fontSize: 23,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.green[800]
        ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Favorites",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.greenAccent, width: 2),
                ),
                padding: const EdgeInsets.all(8),
                child: favoriteTeams.isEmpty ? Center(
                  child: Text(
                    "No favorites yet.",
                    style: TextStyle(color: Colors.white70),
                  ),
                ) : ListView.builder(
                  itemCount: favoriteTeams.length,
                  itemBuilder: (context, index) {
                    return TeamTile(team: favoriteTeams[index]);
                  },
                )
              ),
            ),
          ],
        )
      ),
    );
  }
}