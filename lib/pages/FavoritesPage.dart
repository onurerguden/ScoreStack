import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/Team.dart';
import '../widgets/TeamTile.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  List<Team> allTeams = []; // Tüm takımlar
  List<Team> favoriteTeams = []; // Favori takımlar


  void fetchTeams() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('team').get();

    final teams = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Team.fromMap(data, reference: doc.reference);
    }).toList();

    setState(() {
      allTeams = teams;
    });
    print("All teams fetched: ${allTeams.length}");
  }

  @override
  void initState() {
    super.initState();
    fetchTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              // All Teams Section
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  alignment: Alignment.topCenter,
                  width: 390,
                  height: 670,
                  color: CupertinoColors.systemGrey3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        color: const Color(0xFF2C2C2C),
                        child: const Text(
                          "All Teams",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: allTeams.length,
                          itemBuilder: (context, index) {
                            return TeamTile(team: allTeams[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}