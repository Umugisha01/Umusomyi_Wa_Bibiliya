import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/reading_model.dart';
import '../data/reading_service.dart';
import '../data/favorites_service.dart';

import 'calendar_screen.dart';
import 'favorites_screen.dart';
import 'settings/settings_screen.dart';
import 'search_delegate.dart';

class DailyReadingScreen extends StatefulWidget {
  final Reading? reading;
  // If reading is passed, show it. If null, fetch today's reading.
  final DateTime? dateToFetch;

  const DailyReadingScreen({super.key, this.reading, this.dateToFetch});

  @override
  State<DailyReadingScreen> createState() => _DailyReadingScreenState();
}

class _DailyReadingScreenState extends State<DailyReadingScreen> {
  late Future<Reading?> _readingFuture;
  final ReadingService _readingService = ReadingService();
  final FavoritesService _favoritesService = FavoritesService();
  List<Reading> _allReadings = [];

  @override
  void initState() {
    super.initState();
    if (widget.reading != null) {
      _readingFuture = Future.value(widget.reading);
    } else {
      _readingFuture = _fetchReading();
    }
  }

  Future<Reading?> _fetchReading() async {
    try {
      _allReadings = await _readingService.getAllReadings();
      DateTime targetDate = widget.dateToFetch ?? DateTime.now();
      String dateStr = DateFormat('yyyy-MM-dd').format(targetDate);

      final reading = _allReadings.firstWhere(
        (r) => r.date == dateStr,
        orElse: () => Reading(
          date: dateStr,
          title: "Nta nyigisho ihari",
          reference: "",
          content: "Nta nyigisho yateganyijwe kuri uyu munsi.",
        ),
      );

      // Check if it's a favorite
      reading.isBookmarked = await _favoritesService.isFavorite(reading.date);
      return reading;
    } catch (e) {
      return Reading(
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        title: "Error",
        reference: "",
        content:
            "Hari ikibazo mu gushaka inyigisho. Reba niba internet ihari cyangwa niba backend irimo gukora.",
      );
    }
  }

  void _showMenuOptions(Reading reading) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => MenuBottomSheet(reading: reading),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder<Reading?>(
        future: _readingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }

          final reading = snapshot.data;
          if (reading == null) return SizedBox();

          // Safely parse date
          DateTime dateObj;
          try {
            dateObj = DateTime.parse(reading.date);
          } catch (e) {
            dateObj = DateTime.now();
          }

          final dateDisplay =
              "${dateObj.day} Ukwezi kwa ${dateObj.month} ${dateObj.year}";

          return SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          dateDisplay,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      SizedBox(width: 40),
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          size: 24,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: ReadingSearchDelegate(_allReadings),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            reading.title,
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (reading.reference.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              reading.reference,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Center(
                          child: Container(
                            width: 100,
                            height: 1,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildStyledContent(reading.content),
                        const SizedBox(height: 40),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(
                                  reading.isBookmarked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: reading.isBookmarked
                                      ? Colors.red
                                      : Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () async {
                                  bool isFav = await _favoritesService
                                      .toggleFavorite(reading.date);
                                  setState(() {
                                    reading.isBookmarked = isFav;
                                  });
                                },
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.chevron_left),
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    onPressed: () {
                                      final prevDate = dateObj.subtract(
                                        const Duration(days: 1),
                                      );
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DailyReadingScreen(
                                                dateToFetch: prevDate,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CalendarScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "INYIGISHO",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.chevron_right),
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    onPressed: () {
                                      final nextDate = dateObj.add(
                                        const Duration(days: 1),
                                      );
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DailyReadingScreen(
                                                dateToFetch: nextDate,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () => _showMenuOptions(reading),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStyledContent(String content) {
    // Remove vertical bars
    final cleanedContent = content.replaceAll('|', '');

    // List of titles to bold
    final titles = [
      "Inama",
      "Indir.",
      "Imbuzi",
      "Gusenga",
      "Zirikana",
      "Icyifuzo",
    ];

    // Create a regex pattern to match any of the titles
    // We use capturing group () to keep the delimiter in the split result if we were using split,
    // but here we can just find matches and ranges.
    // A simpler approach for RichText with multiple patterns:
    List<InlineSpan> spans = [];

    // We will split the text by the keywords.
    // Since Dart's split doesn't keep delimiters easily in a way that preserves order for reassembly
    // (unless we look ahead/behind), let's use a manual scan or multiple replacement strategy.

    // Alternative: Use a RegEx to find all occurrences and text between them.
    final pattern = RegExp(titles.map((t) => RegExp.escape(t)).join('|'));

    int lastMatchEnd = 0;

    for (final match in pattern.allMatches(cleanedContent)) {
      // Add text before the match
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: cleanedContent.substring(lastMatchEnd, match.start),
            style: GoogleFonts.sourceSerif4(
              fontSize: 18,
              height: 1.6,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        );
      }

      // Add the matched keyword (Bold)
      spans.add(
        TextSpan(
          text: match.group(0),
          style: GoogleFonts.sourceSerif4(
            fontSize: 18,
            height: 1.6,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );

      lastMatchEnd = match.end;
    }

    // Add remaining text
    if (lastMatchEnd < cleanedContent.length) {
      spans.add(
        TextSpan(
          text: cleanedContent.substring(lastMatchEnd),
          style: GoogleFonts.sourceSerif4(
            fontSize: 18,
            height: 1.6,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      );
    }

    return RichText(text: TextSpan(children: spans));
  }
}

class MenuBottomSheet extends StatelessWidget {
  final Reading? reading;
  const MenuBottomSheet({super.key, this.reading});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios, size: 20),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Hitamo",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 24),
          _buildMenuOption(
            context,
            Icons.favorite,
            "INYIGISHO ZAKUNZWE",
            onTap: () {
              Navigator.pop(context); // Close bottom sheet
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 12),
          _buildMenuOption(
            context,
            Icons.share,
            "SANGIZA",
            onTap: () {
              Navigator.pop(context); // Close main menu
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => ShareOptionsBottomSheet(reading: reading),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildMenuOption(
            context,
            Icons.settings,
            "IMIKORERE",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context,
    IconData icon,
    String label, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShareOptionsBottomSheet extends StatelessWidget {
  final Reading? reading;
  const ShareOptionsBottomSheet({super.key, this.reading});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios, size: 20),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Sangiza",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 24),
          _buildOption(
            context,
            Icons.share,
            "Izindi Porogaramu (Apps)",
            onTap: () {
              Navigator.pop(context);
              if (reading != null) {
                final cleanedContent = reading!.content.replaceAll('|', '');
                final text =
                    "${reading!.date}\n${reading!.title}\n${reading!.reference}\n\n$cleanedContent";
                Share.share(text, subject: reading!.title);
              }
            },
          ),
          const SizedBox(height: 12),
          _buildOption(
            context,
            Icons.copy,
            "Gukoporora",
            onTap: () {
              Navigator.pop(context);
              if (reading != null) {
                final cleanedContent = reading!.content.replaceAll('|', '');
                final text =
                    "${reading!.date}\n${reading!.title}\n${reading!.reference}\n\n$cleanedContent";
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Byakoporowe!", style: GoogleFonts.inter()),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    IconData icon,
    String label, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
