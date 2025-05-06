import 'package:flutter/material.dart';
import '../models/Team.dart';
import '../services/FavoriteService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeamTile extends StatefulWidget {
  final Team team;
  final bool? isFavorite;
  final VoidCallback? onStarPressed;

  const TeamTile({
    super.key,
    required this.team,
    this.isFavorite,
    this.onStarPressed,
  });

  @override
  State<TeamTile> createState() => _TeamTileState();
}

class _TeamTileState extends State<TeamTile> {
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      isFavorited = favorites.contains(widget.team.name);
    });
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    setState(() {
      if (isFavorited) {
        favorites.remove(widget.team.name);
      } else {
        favorites.add(widget.team.name);
      }
      isFavorited = !isFavorited;
    });

    await prefs.setStringList('favorites', favorites);

    if (widget.onStarPressed != null) {
      widget.onStarPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool displayFavorite = widget.isFavorite ?? isFavorited;
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Container(
          child: Image.network(
            widget.team.logoUrl,
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(
          widget.team.name,
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.team.country} • ${widget.team.league}',
              style: TextStyle(color: Colors.grey[600],fontSize: 13),
            ),
            SizedBox(height: 4),
            widget.team.last5Matches != null && widget.team.last5Matches!.isNotEmpty
                ? Row(
              children: widget.team.last5Matches!.map((match) {
                Color color;
                String result = match.substring(0, 1);
                if (result == "W") {
                  color = Colors.green;
                } else if (result == "D") {
                  color = Color(0xFFFFC107);
                } else {
                  color = Colors.red;
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: CircleAvatar(
                    backgroundColor: color,
                    radius: 10,
                    child: Text(
                      result,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            )
                : Text(
              'No recent matches',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 1,)
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            displayFavorite ? Icons.star : Icons.star_border,
            color: displayFavorite ? Color(0xFFFFC107) : null,size: 30,
          ),
          onPressed: _toggleFavorite,
        ),
      ),
    );
  }
}
