import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../upload_content_screen.dart';
import '../calendar_screen.dart';
import 'add_admin_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Amategeko ya Admin",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Theme.of(context).colorScheme.primary,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: ListView(
          children: [
            _buildDashboardButton(
              context,
              icon: Icons.file_upload_outlined,
              label: "ONGERA FAYIRO",
              subtitle: "Shyiramo inyandiko na Bible",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadContentScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildDashboardButton(
              context,
              icon: Icons.calendar_today_outlined,
              label: "REBA KALANDARI",
              subtitle: "Gahunda y'amasomo",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalendarScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildDashboardButton(
              context,
              icon: Icons.edit_outlined,
              label: "HINDURA INYIGISHO",
              subtitle: "Kosora inyandiko",
              onTap: () {
                // Reuse Calendar for Edit selection (MVP)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalendarScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildDashboardButton(
              context,
              icon: Icons.analytics_outlined,
              label:
                  "SIBANURA", // User requested this label for Analytics logic
              subtitle: "Reba imibare n'ibyifatizo", // "Analytics/Stats"
              onTap: () {
                // Reuse Calendar or Placeholder for MVP
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Imibare iracyategurwa (Analytics coming soon)",
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildDashboardButton(
              context,
              icon: Icons.person_add_outlined,
              label: "ONGERA ADMIN",
              subtitle: "Ohereza invitation kuri admin",
              isHighlight: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddAdminScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    bool isHighlight = false,
  }) {
    // Determine colors based on theme
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Highlight colors (Green/Black contrast)
    final Color borderColor = isHighlight
        ? (isDark ? Colors.green : Colors.black)
        : (isDark ? Colors.white : Colors.black);

    final Color iconColor = isHighlight
        ? (isDark ? Colors.green : Colors.black)
        : (isDark ? Colors.white : Colors.black);

    final Color textColor = isDark ? Colors.white : Colors.black;

    return Container(
      width: double.infinity,
      // Increase height for subtitle
      // height: 80,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: isHighlight ? 2.0 : 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isHighlight) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "ISHYA",
                  style: TextStyle(
                    color: isDark ? Colors.black : Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8),
            ],
            Icon(Icons.arrow_forward_ios, color: iconColor, size: 16),
          ],
        ),
      ),
    );
  }
}
