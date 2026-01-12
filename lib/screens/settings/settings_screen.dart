import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import 'notifications_settings_screen.dart';
import 'text_settings_screen.dart';
import 'appearance_settings_screen.dart';

import 'about_settings_screen.dart';
import '../admin/admin_login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          "IMIKORERE",
          style: GoogleFonts.inter(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsItem(
            context,
            icon: Icons.notifications_outlined,
            title: "AMAKURU Y'UMUNSI",
            subtitle: "(Daily Notifications)",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsSettingsScreen(),
                ),
              );
            },
          ),
          _buildSettingsItem(
            context,
            icon: Icons.text_fields,
            title: "INYANDIKO",
            subtitle: "(Text Settings)",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TextSettingsScreen(),
                ),
              );
            },
          ),
          _buildSettingsItem(
            context,
            icon: Icons.brightness_6_outlined,
            title: "IMIGARAGARIRE",
            subtitle: "(Appearance)",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppearanceSettingsScreen(),
                ),
              );
            },
          ),

          _buildSettingsItem(
            context,
            icon: Icons.info_outline,
            title: "AMAKURU",
            subtitle: "(About)",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutSettingsScreen(),
                ),
              );
            },
          ),
          _buildSettingsItem(
            context,
            icon: Icons.admin_panel_settings,
            title: "UBUYOBOZI",
            subtitle: "(Admin)",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminLoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColors.black),
        title: Text(
          title,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.darkGray),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.darkGray,
        ),
        onTap: onTap,
      ),
    );
  }
}
