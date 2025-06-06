import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/TeamTile.dart';
import '../models/Team.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  final ScrollController _scrollController = ScrollController();

  List<Team> allTeams = [];
  List<Team> favoriteTeams = [];

  Future<void> fetchTeams() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('team').get();

    final teams = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Team.fromMap(data, reference: doc.reference);
    }).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    setState(() {
      allTeams = teams;

      Map<String, int> favoriteOrder = {
        for (int i = 0; i < favorites.length; i++) favorites[i]: i
      };

      allTeams.sort((a, b) {
        final aFav = favorites.contains(a.name);
        final bFav = favorites.contains(b.name);

        if (aFav && bFav) {
          return favoriteOrder[a.name]!.compareTo(favoriteOrder[b.name]!);
        }
        if (aFav && !bFav) return -1;
        if (!aFav && bFav) return 1;

        return 0; // maintain original order for non-favorites
      });
    });
    print("All teams fetched: ${allTeams.length}");
  }

  bool isFavorite(Team team) {
    return favoriteTeams.contains(team);
  }

  void toggleFavorite(Team team) {
    setState(() {
      if (favoriteTeams.contains(team)) {
        favoriteTeams.remove(team);
      } else {
        favoriteTeams.add(team);
      }

      allTeams.sort((a, b) {
        final aFav = favoriteTeams.contains(a);
        final bFav = favoriteTeams.contains(b);
        if (aFav && !bFav) return -1;
        if (!aFav && bFav) return 1;
        return 0;
      });
    });
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
              height: size.height * 0.72,
              color: CupertinoColors.systemGrey3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    color: const Color(0xFF2C2C2C),
                    child: Row(
                      children: [
                        SizedBox(width: 27.8),
                        Icon(Icons.list, color: Colors.white, size: 28),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "All Teams",
                              style: TextStyle(
                                fontSize: size.width * 0.05,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(width: 45.8),
                      ],
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      transitionBuilder: (child, animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, 0.06),
                            end: Offset.zero,
                          ).animate(animation),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: ListView.builder(
                        key: ValueKey(allTeams.map((e) => e.name).join()),
                        controller: _scrollController,
                        itemCount: allTeams.length,
                        itemBuilder: (context, index) {
                          final team = allTeams[index];
                          return TeamTile(
                            key: ValueKey(team.name),
                            team: team,
                            onStarPressed: () async {
                              await fetchTeams();
                              _scrollController.animateTo(
                                0,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          );
                        },
                      ),
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
