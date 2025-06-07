import 'package:shared_preferences/shared_preferences.dart';

//SARP DEMİRTAS - 20220601016
//ONUR ERGÜDEN - 20220601030

class FavoriteService {
  static const String _favoritesKey = 'favorites';

  static Future<List<String>> getFavoriteTeams() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  static Future<void> addFavorite(String teamName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    if (!favorites.contains(teamName)) {
      favorites.add(teamName);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  static Future<void> removeFavorite(String teamName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    favorites.remove(teamName);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  static Future<List<String>> getFavoriteTeamNames() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }
}
