import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _keyFavorites = 'favorite_readings';

  Future<bool> toggleFavorite(String date) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_keyFavorites) ?? [];

    if (favorites.contains(date)) {
      favorites.remove(date);
      await prefs.setStringList(_keyFavorites, favorites);
      return false; // Removed
    } else {
      favorites.add(date);
      await prefs.setStringList(_keyFavorites, favorites);
      return true; // Added
    }
  }

  Future<bool> isFavorite(String date) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_keyFavorites) ?? [];
    return favorites.contains(date);
  }

  Future<List<String>> getFavoriteDates() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyFavorites) ?? [];
  }
}
