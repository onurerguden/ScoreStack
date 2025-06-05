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
  int totalExpenses = 0;
  List<Team> favoriteTeams = [];
  List<String> savedCoupons = [];

  @override
  void initState() {
    super.initState();
    fetchFavorites();
    fetchSavedCoupons();
    loadTotalExpenses();
  }

  Future<void> fetchFavorites() async {
    final collection = await FirebaseFirestore.instance.collection('team').get();
    final allteams = collection.docs.map((doc) {
      final data = doc.data();
      return Team.fromMap(data, reference: doc.reference);
    }).toList();

    final prefs = await SharedPreferences.getInstance();
    final favoriteNames = prefs.getStringList('favorites') ?? [];

    setState(() {
      favoriteTeams = allteams.where((team) => favoriteNames.contains(team.name)).toList();
    });
  }

  Future<void> fetchSavedCoupons() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedCoupons = prefs.getStringList('savedCoupons') ?? [];
    });
  }

  Future<void> loadTotalExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('costMap') ?? [];

    int total = 0;
    for (var entry in list) {
      final parts = entry.split(":");
      if (parts.length == 2) {
        total += int.tryParse(parts[1]) ?? 0;
      }
    }

    setState(() {
      totalExpenses = total;
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
                color: Colors.amber,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amberAccent, width: 2),
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
                    return TeamTile(
                      team: favoriteTeams[index],
                      showStar: false,
                    );
                  },
                )
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Saved Coupons",
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.greenAccent, width: 2),
              ),
              padding: const EdgeInsets.all(8),
              child: savedCoupons.isEmpty
                  ? Center(
                child: Text(
                  "No saved coupons.",
                  style: TextStyle(color: Colors.white70),
                ),
              )
                  : ListView.builder(
                itemCount: savedCoupons.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      savedCoupons[index],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              )
            ),
            SizedBox(height: 20),
            Text(
              "         Total Expenditures: \$${totalExpenses.toString()}",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ],
        )
      ),
    );
  }
}