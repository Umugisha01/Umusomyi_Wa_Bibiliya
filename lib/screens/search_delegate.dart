import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/reading_model.dart';
import 'daily_reading_screen.dart';

class ReadingSearchDelegate extends SearchDelegate<String> {
  final List<Reading> readings;

  ReadingSearchDelegate(this.readings);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.primary),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: Theme.of(context).colorScheme.primary,
        size: 20,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    // Filter logic
    final results = readings.where((reading) {
      final q = query.toLowerCase();
      return reading.title.toLowerCase().contains(q) ||
          reading.content.toLowerCase().contains(q) ||
          reading.reference.toLowerCase().contains(q) ||
          reading.date.toLowerCase().contains(q);
    }).toList();

    if (results.isEmpty) {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: Text(
            query.isEmpty ? "Andika icyo ushaka..." : "Nta kintu cyabonetse.",
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      );
    }

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final reading = results[index];
          return Card(
            elevation: 0,
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(
                reading.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              subtitle: Text(
                "${reading.date} - ${reading.reference}",
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onTap: () {
                // Navigate to the reading
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DailyReadingScreen(reading: reading),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: theme.iconTheme.copyWith(color: theme.colorScheme.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: theme.colorScheme.secondary),
        border: InputBorder.none,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: theme.colorScheme.primary,
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: TextStyle(color: theme.colorScheme.primary, fontSize: 20),
      ),
    );
  }
}
