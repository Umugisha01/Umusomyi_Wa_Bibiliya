import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_colors.dart';

class TextSettingsScreen extends StatefulWidget {
  const TextSettingsScreen({super.key});

  @override
  State<TextSettingsScreen> createState() => _TextSettingsScreenState();
}

class _TextSettingsScreenState extends State<TextSettingsScreen> {
  // 0: A-, 1: A, 2: A+, 3: A++
  int _fontSizeLevel = 1;
  double _lineSpacing = 0.5; // 0.0 to 1.0 mapping to visual slider
  String _margin = 'Gitoya'; // Gitoya, Hagati, Kinini
  String _fontFamily = 'Ubwoko bw\'ibanze'; // Default, Sans-serif, Serif
  String _alignment = 'Ibumoso: Iburyo'; // LTR, RTL

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSizeLevel = prefs.getInt('text_font_size_level') ?? 1;
      _lineSpacing = prefs.getDouble('text_line_spacing') ?? 0.5;
      _margin = prefs.getString('text_margin') ?? 'Gitoya';
      _fontFamily = prefs.getString('text_font_family') ?? 'Ubwoko bw\'ibanze';
      _alignment = prefs.getString('text_alignment') ?? 'Ibumoso: Iburyo';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('text_font_size_level', _fontSizeLevel);
    await prefs.setDouble('text_line_spacing', _lineSpacing);
    await prefs.setString('text_margin', _margin);
    await prefs.setString('text_font_family', _fontFamily);
    await prefs.setString('text_alignment', _alignment);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Settings Saved!')));
    Navigator.pop(context);
  }

  Future<void> _resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    // Remove specific keys
    await prefs.remove('text_font_size_level');
    await prefs.remove('text_line_spacing');
    await prefs.remove('text_margin');
    await prefs.remove('text_font_family');
    await prefs.remove('text_alignment');

    // Reload defaults
    setState(() {
      _fontSizeLevel = 1;
      _lineSpacing = 0.5;
      _margin = 'Gitoya';
      _fontFamily = 'Ubwoko bw\'ibanze';
      _alignment = 'Ibumoso: Iburyo';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings Reset to Defaults!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          "Igenamiterere ry'Inyandiko",
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
            // Font Size
            Text(
              "Ingano y'inyuguti:",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFontSizeOption("A-", 0),
                _buildFontSizeOption("A", 1),
                _buildFontSizeOption("A+", 2),
                _buildFontSizeOption("A++", 3),
              ],
            ),
            const SizedBox(height: 24),

            // Line Spacing
            Text(
              "Intera hagati y'imyandikire:",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _lineSpacing,
              onChanged: (val) => setState(() => _lineSpacing = val),
              activeColor: AppColors.black,
              inactiveColor: AppColors.border,
            ),
            const SizedBox(height: 24),

            // Margins
            Text(
              "Margini:",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            _buildRadioItem(
              "Gitoya",
              _margin,
              (val) => setState(() => _margin = val),
            ),
            _buildRadioItem(
              "Hagati",
              _margin,
              (val) => setState(() => _margin = val),
            ),
            _buildRadioItem(
              "Kinini",
              _margin,
              (val) => setState(() => _margin = val),
            ),
            const SizedBox(height: 24),

            // Font Family
            Text(
              "Ubwoko bw'inyuguti:",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            _buildRadioItem(
              "Ubwoko bw'ibanze",
              _fontFamily,
              (val) => setState(() => _fontFamily = val),
            ),
            _buildRadioItem(
              "Sans-serif",
              _fontFamily,
              (val) => setState(() => _fontFamily = val),
            ),
            _buildRadioItem(
              "Serif",
              _fontFamily,
              (val) => setState(() => _fontFamily = val),
            ),
            const SizedBox(height: 24),

            // Alignment
            Text(
              "Icyerekezo:",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            _buildRadioItem(
              "Ibumoso: Iburyo",
              _alignment,
              (val) => setState(() => _alignment = val),
            ),
            _buildRadioItem(
              "Iburyo: Ibumoso",
              _alignment,
              (val) => setState(() => _alignment = val),
            ),

            const SizedBox(height: 40),

            // Buttons: EMEZA, IMIMERERE ISANZWE, SUBIKA
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _saveSettings,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "EMEZA",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _resetSettings,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(
                    color: AppColors.border,
                  ), // Same style or different?
                  // Maybe red text or different style for reset? Keeping similar for consistency
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "IMIMERERE ISANZWE",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

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

  Widget _buildFontSizeOption(String label, int index) {
    bool isSelected = _fontSizeLevel == index;
    return GestureDetector(
      onTap: () => setState(() => _fontSizeLevel = index),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14 + (index * 2),
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.black),
              color: isSelected ? AppColors.black : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioItem(
    String label,
    String groupValue,
    Function(String) onChanged,
  ) {
    return RadioListTile<String>(
      title: Text(label, style: GoogleFonts.inter()),
      value: label,
      groupValue: groupValue,
      onChanged: (val) => onChanged(val!),
      activeColor: AppColors.black,
      contentPadding: EdgeInsets.zero,
    );
  }
}
