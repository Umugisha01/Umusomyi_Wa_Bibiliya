import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutSettingsScreen extends StatelessWidget {
  const AboutSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Amakuru",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AMAKURU YA APLIKASIYO
            _buildMainHeader(
              context,
              "AMAKURU YA APLIKASIYO",
              "(About the App)",
            ),
            const SizedBox(height: 16),
            _buildSubHeader(context, "UMUSOMYI WA BIBILIYA"),
            const SizedBox(height: 8),
            _buildBodyText(
              context,
              "Umusomyi wa Bibiliya ni aplikasiyo igenewe gufasha abakristo gusoma, gusobanukirwa, no gutekereza ku Ijambo ry’Imana buri munsi, mu buryo bworoshye kandi bugezweho.",
            ),
            const SizedBox(height: 8),
            _buildBodyText(context, "Iyi aplikasiyo itanga:"),
            _buildBulletPoint(context, "Gusoma Bibiliya mu Kinyarwanda"),
            _buildBulletPoint(context, "Inyigisho n’ibitekerezo by’umunsi"),
            _buildBulletPoint(context, "Ubutumwa bwo kwibutsa gusoma"),
            _buildBulletPoint(
              context,
              "Uburyo bworoshye bwo gushaka ibice bya Bibiliya",
            ),
            _buildBulletPoint(context, "Igenamiterere ryorohereza umukoresha"),
            _buildDivider(context),

            // ABAYITEGUYE
            _buildMainHeader(context, "ABAYITEGUYE", "(Prepared by)"),
            const SizedBox(height: 16),
            _buildSubHeader(
              context,
              "Scripture Union Rwanda",
              textAlign: TextAlign.start,
            ),
            _buildItalicText(
              context,
              "(Ligue pour la Lecture de la Bible Rwanda – LLBR)",
            ),
            const SizedBox(height: 8),
            _buildBodyText(
              context,
              "Scripture Union Rwanda ni umuryango wa gikirisitu ugamije gufasha abantu bose, cyane cyane urubyiruko n’imiryango, gukunda no gusoma Bibiliya, no kuyigira umusingi w’imibereho ya buri munsi.",
            ),
            _buildDivider(context),

            // ICYICARO GIKURU
            _buildMainHeader(context, "ICYICARO GIKURU", "(Head Office)"),
            const SizedBox(height: 16),
            _buildBodyText(context, "BP 426, Kigali, Rwanda"),
            _buildBodyText(context, "Iherereye mu gace Ka Kacyiru"),
            _buildDivider(context),

            // TUVUGISHE
            _buildMainHeader(context, "TUVUGISHE", "(Contact Information)"),
            const SizedBox(height: 16),
            _buildLabelValue(
              context,
              "Telefone:",
              "+250 728 592 149\n+250 788 740 489",
            ),
            const SizedBox(height: 8),
            _buildLabelValue(context, "Email:", "surwanda1@gmail.com"),
            _buildDivider(context),

            // IMBUGA NKORANYAMBAGA
            _buildMainHeader(context, "IMBUGA NKORANYAMBAGA", "(Social Media)"),
            const SizedBox(height: 16),
            _buildBodyText(
              context,
              "Kurikirana ibikorwa n’amakuru mashya ya Scripture Union Rwanda kuri:",
            ),
            const SizedBox(height: 8),
            _buildLabelValue(context, "Facebook:", "Scripture Union Rwanda"),
            _buildLabelValue(context, "Instagram:", "@su_rwanda"),
            _buildDivider(context),

            // ABAYITEJE IMBERE
            _buildMainHeader(
              context,
              "ABAYITEJE IMBERE (Developer)",
              "(Technical Development)",
            ),
            const SizedBox(height: 16),
            _buildBodyText(
              context,
              "Iyi aplikasiyo yakozwe inatezwa imbere n'umugeni wa porogaramu wigenga ku bufatanyhe n'abateguye umushinga.",
            ),
            const SizedBox(height: 8),
            _buildLabelValue(context, "Email:", "umugishaone@gmail.com"),
            _buildLabelValue(context, "Telefone:", "+250 780 453 841"),
            _buildDivider(context),

            // AMATEGEKO N’AMABWIRIZA
            _buildMainHeader(
              context,
              "AMATEGEKO N’AMABWIRIZA",
              "(Terms & Privacy)",
            ),
            const SizedBox(height: 16),
            _buildBodyText(
              context,
              "Amakuru yawe ararinzwe kandi akubahiriza amabwiriza agenga umutekano w’amakuru. Iyi aplikasiyo ntabwo ikusanya amakuru yihariye atari ngombwa, kandi ntisangiza amakuru yawe n’abandi batabifitiye uburenganzira bwemewe n’amategeko.",
            ),
            _buildDivider(context),

            // SABA INKUNGA
            // SABA INKUNGA => TANGA INKUNGA
            _buildMainHeader(context, "TANGA INKUNGA", "(Rate the App)"),
            const SizedBox(height: 16),
            _buildBodyText(
              context,
              "Niba Umusomyi wa Bibiliya wagufashije cyangwa wawukunze:",
            ),
            const SizedBox(height: 8),
            _buildBulletPoint(
              context,
              "Dusigire igitekerezo cyawe kuri Google Play Store",
            ),
            _buildBulletPoint(context, "Cyangwa Apple App Store"),
            const SizedBox(height: 8),
            _buildBodyText(
              context,
              "Igitekerezo cyawe kidufasha kongera kunoza no kugurura aplikasiyo.",
            ),
            _buildDivider(context),

            // VIGURURA APLIKASIYO
            _buildMainHeader(
              context,
              "VIGURURA APLIKASIYO",
              "(Check for Updates)",
            ),
            const SizedBox(height: 16),
            _buildBodyText(context, "Dukomeza kongeramo:"),
            _buildBulletPoint(context, "Inyigisho nshya"),
            _buildBulletPoint(context, "Ibyoroshya imikoreshereze"),
            _buildBulletPoint(context, "Gukosora amakosa"),
            const SizedBox(height: 8),
            _buildBodyText(
              context,
              "Jya ugenzura verisiyo nshya kuri Play Store cyangwa App Store.",
            ),
            _buildDivider(context),

            // UBUTUMWA
            _buildMainHeader(context, "UBUTUMWA", "(Message)"),
            const SizedBox(height: 16),
            _buildBodyText(
              context,
              "Twishimiye kugufasha kugirana umubano mwiza n'Imana binyuze mu Ijambo Ryayo",
            ),
            const SizedBox(height: 4),
            Text(
              "Umusomyi wa Bibiliya - Gusoma Bibiliya, Gutekereza, no Kubaho mu ijambo.",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMainHeader(BuildContext context, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSubHeader(
    BuildContext context,
    String title, {
    TextAlign textAlign = TextAlign.start,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        title,
        textAlign: textAlign,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildBodyText(
    BuildContext context,
    String text, {
    bool isBold = false,
    TextAlign textAlign = TextAlign.start,
  }) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: Theme.of(context).colorScheme.secondary,
        height: 1.5,
      ),
    );
  }

  Widget _buildItalicText(
    BuildContext context,
    String text, {
    TextAlign textAlign = TextAlign.start,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        text,
        textAlign: textAlign,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0),
      child: Divider(color: Theme.of(context).dividerColor),
    );
  }

  Widget _buildLabelValue(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
