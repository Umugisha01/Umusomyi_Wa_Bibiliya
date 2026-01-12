import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class AppearanceSettingsScreen extends StatefulWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  State<AppearanceSettingsScreen> createState() =>
      _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends State<AppearanceSettingsScreen> {
  String _theme = "Umunsi"; // Umunsi, Nijoro, Kugana Imana
  Color _backgroundColor = Colors.white; // Icyera, Icyatsi kibisi, Umukara
  Color _textColor =
      Colors.black; // Umukara, Icyatsi, Umuhondo (Brown/Yellowish)
  bool _showImages = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          "Imigaragarire",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme
            Text(
              "Uburyo bw'uruhanga:",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            _buildThemeOption("☀️  Umunsi", "Umunsi"),
            _buildThemeOption("🌙  Nijoro", "Nijoro"),
            _buildThemeOption("🔄  Kugana Imana", "Kugana Imana"),
            const SizedBox(height: 24),

            // Background Color
            Text(
              "Ibara ry'inyuma:",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildColorOption(
              "Icyera",
              Colors.white,
              _backgroundColor,
              (c) => setState(() => _backgroundColor = c),
            ),
            _buildColorOption(
              "Icyatsi kibisi",
              const Color(0xFFE8F5E9),
              _backgroundColor,
              (c) => setState(() => _backgroundColor = c),
            ),
            _buildColorOption(
              "Umukara",
              Colors.black,
              _backgroundColor,
              (c) => setState(() => _backgroundColor = c),
            ),
            const SizedBox(height: 24),

            // Text Color
            Text(
              "Ibara ry'inyandiko:",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildColorOption(
              "Umukara",
              Colors.black,
              _textColor,
              (c) => setState(() => _textColor = c),
            ),
            _buildColorOption(
              "Icyatsi",
              Colors.green[800]!,
              _textColor,
              (c) => setState(() => _textColor = c),
            ),
            _buildColorOption(
              "Umuhondo",
              Colors.brown,
              _textColor,
              (c) => setState(() => _textColor = c),
            ),
            const SizedBox(height: 24),

            // Images
            Text(
              "Amashusho:",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            CheckboxListTile(
              title: Text("Reka amashusho", style: GoogleFonts.inter()),
              value: !_showImages,
              activeColor: AppColors.black,
              onChanged: (val) => setState(() => _showImages = !val!),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: Text("Ongeraho ibishushanyo", style: GoogleFonts.inter()),
              value: _showImages,
              activeColor: AppColors.black,
              onChanged: (val) => setState(() => _showImages = val!),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),

            const SizedBox(height: 40),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "SUBIKA",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(String label, String value) {
    return RadioListTile<String>(
      title: Text(label, style: GoogleFonts.inter()),
      value: value,
      groupValue: _theme,
      onChanged: (val) => setState(() => _theme = val!),
      activeColor: AppColors.black,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildColorOption(
    String label,
    Color color,
    Color groupValue,
    Function(Color) onTap,
  ) {
    bool isSelected = groupValue == color;
    return InkWell(
      onTap: () => onTap(color),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: color == Colors.black
                          ? Colors.white
                          : Colors.black,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(label, style: GoogleFonts.inter()),
          ],
        ),
      ),
    );
  }
}
