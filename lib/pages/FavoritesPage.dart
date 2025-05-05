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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              alignment: Alignment.topCenter,
              width: size.width * 0.95,
              height: size.height * 0.74,
              color: CupertinoColors.systemGrey3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: const Color(0xFF2C2C2C),
                    child: Text(
                      "All Teams",
                      style: TextStyle(
                        fontSize: size.width * 0.055,
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
        ),
      ),
    );
  }
}