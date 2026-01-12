import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/reading_model.dart';
import '../data/reading_service.dart';
import '../data/favorites_service.dart';
import 'daily_reading_screen.dart';
import 'package:intl/intl.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Reading>> _favoritesFuture;
  final ReadingService _readingService = ReadingService();
  final FavoritesService _favoritesService = FavoritesService();

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _fetchFavorites();
  }

  Future<List<Reading>> _fetchFavorites() async {
    try {
      final favDates = await _favoritesService.getFavoriteDates();
      final allReadings = await _readingService.getAllReadings();

      // Filter readings that are in favorites
      return allReadings.where((r) => favDates.contains(r.date)).toList();
    } catch (e) {
      print("Error fetching favorites: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "INYIGISHO ZAKUNZWE",
          style: GoogleFonts.inter(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Reading>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }

          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return Center(
              child: Text(
                "Nta nyigisho zakunzwe.",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            padding: EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final reading = favorites[index];
              DateTime dateObj;
              try {
                dateObj = DateTime.parse(reading.date);
              } catch (_) {
                dateObj = DateTime.now();
              }

              final dateDisplay = DateFormat('yyyy-MM-dd').format(dateObj);

              return Card(
                elevation: 0,
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    reading.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    dateDisplay,
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DailyReadingScreen(reading: reading),
                      ),
                    );
                    // Refresh in case one was removed
                    setState(() {
                      _favoritesFuture = _fetchFavorites();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
