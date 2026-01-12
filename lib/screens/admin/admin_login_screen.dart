import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_otp/email_otp.dart';
import 'admin_dashboard_screen.dart';
import '../../data/admin_manager.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final AdminManager _adminManager = AdminManager();

  bool _isOtpSent = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _configureEmailOtp();
  }

  void _configureEmailOtp() {
    EmailOTP.config(
      appName: 'Umusomyi Admin',
      otpType: OTPType.numeric,
      otpLength: 6,
      emailTheme: EmailTheme.v6,
    );

    EmailOTP.setSMTP(
      host: 'smtp.gmail.com',
      emailPort: EmailPort.port587,
      secureType: SecureType.tls,
      username: 'umugishaone@gmail.com',
      password: 'qdpqkhbaptqmemwp',
    );
  }

  void _requestOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Shyiramo email yawe")));
      return;
    }

    // Check if email is an allowed admin
    final isAdmin = await _adminManager.isAdmin(email);
    if (!isAdmin) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Iyi email ntabwo yemerewe ubuyobozi (Access Denied)",
            ),
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    bool result = await EmailOTP.sendOTP(email: email);

    setState(() {
      _isLoading = false;
      if (result) {
        _isOtpSent = true;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Kode yoherejwe kuri $email")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Ntibishobotse kohereza kode. Reba internet yawe."),
          ),
        );
      }
    });
  }

  void _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) return;

    setState(() => _isLoading = true);

    bool result = EmailOTP.verifyOTP(otp: otp);

    setState(() => _isLoading = false);

    if (result) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Kwinjira byagenze neza!")));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kode ntabwo ari yo. Ongera utangire.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine input color based on theme
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "KWINJIRA",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 18,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Injira nk'Umuyobozi",
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Shyiramo email yawe (Admin). Kode (OTP) irahita yoherezwa kuri iyo email.",
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Email Input
            TextField(
              controller: _emailController,
              enabled: !_isOtpSent,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: inputColor),
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: hintColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                prefixIcon: Icon(
                  Icons.email,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // OTP Input (Visible only after sending)
            if (_isOtpSent) ...[
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: inputColor),
                decoration: InputDecoration(
                  labelText: "Kode (OTP)",
                  labelStyle: TextStyle(color: hintColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Action Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : (_isOtpSent ? _verifyOtp : _requestOtp),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _isOtpSent
                            ? "EMEZA (Verify)"
                            : "OHEREZA KODE (Send OTP)",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),

            if (_isOtpSent)
              TextButton(
                onPressed: () {
                  setState(() {
                    _isOtpSent = false;
                    _otpController.clear();
                  });
                },
                child: Text("hindura email"),
              ),
          ],
        ),
      ),
    );
  }
}
