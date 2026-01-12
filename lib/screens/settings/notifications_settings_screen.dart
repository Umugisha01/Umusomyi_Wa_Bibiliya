import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../../utils/app_colors.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _notificationsEnabled = false;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 7, minute: 0);

  // Frequency (Days)
  bool _allDays = false;
  bool _monday = false;
  bool _tuesday = false;
  bool _wednesday = false;
  bool _thursday = false;
  bool _friday = false;
  bool _saturday = false;
  bool _sunday = false;

  // Content
  bool _includeDate = true;
  bool _includeTitle = true;
  bool _includeSnippet = true;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _initializeNotifications();
    await _configureLocalTimeZone();
    await _loadSettings();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
      int hour = prefs.getInt('notification_hour') ?? 7;
      int minute = prefs.getInt('notification_minute') ?? 0;
      _notificationTime = TimeOfDay(hour: hour, minute: minute);

      _monday = prefs.getBool('notify_monday') ?? false;
      _tuesday = prefs.getBool('notify_tuesday') ?? false;
      _wednesday = prefs.getBool('notify_wednesday') ?? false;
      _thursday = prefs.getBool('notify_thursday') ?? false;
      _friday = prefs.getBool('notify_friday') ?? false;
      _saturday = prefs.getBool('notify_saturday') ?? false;
      _sunday = prefs.getBool('notify_sunday') ?? false;

      _checkAllDaysState();

      _includeDate = prefs.getBool('content_date') ?? true;
      _includeTitle = prefs.getBool('content_title') ?? true;
      _includeSnippet = prefs.getBool('content_snippet') ?? true;
    });

    // If enabled in prefs but permission not granted (e.g. revoked), check properly
    // For now, we assume if boolean is true, user expects it ON.
  }

  Future<void> _requestPermissions() async {
    final bool? granted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    if (granted != null && granted) {
      setState(() {
        _notificationsEnabled = true;
      });
      // Save immediately? Or wait for confirm?
      // User expects switch to toggle.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notifications_enabled', true);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Notifications enabled!')));
    } else {
      setState(() {
        _notificationsEnabled = false;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notifications_enabled', false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Permission denied.')));
    }
  }

  Future<void> _confirmSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Save all settings
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setInt('notification_hour', _notificationTime.hour);
    await prefs.setInt('notification_minute', _notificationTime.minute);

    await prefs.setBool('notify_monday', _monday);
    await prefs.setBool('notify_tuesday', _tuesday);
    await prefs.setBool('notify_wednesday', _wednesday);
    await prefs.setBool('notify_thursday', _thursday);
    await prefs.setBool('notify_friday', _friday);
    await prefs.setBool('notify_saturday', _saturday);
    await prefs.setBool('notify_sunday', _sunday);

    await prefs.setBool('content_date', _includeDate);
    await prefs.setBool('content_title', _includeTitle);
    await prefs.setBool('content_snippet', _includeSnippet);

    // 2. Schedule Notifications
    await flutterLocalNotificationsPlugin.cancelAll(); // Clear old scheduling

    if (_notificationsEnabled) {
      if (_monday) _scheduleDay(DateTime.monday);
      if (_tuesday) _scheduleDay(DateTime.tuesday);
      if (_wednesday) _scheduleDay(DateTime.wednesday);
      if (_thursday) _scheduleDay(DateTime.thursday);
      if (_friday) _scheduleDay(DateTime.friday);
      if (_saturday) _scheduleDay(DateTime.saturday);
      if (_sunday) _scheduleDay(DateTime.sunday);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings Saved & Notifications Scheduled!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings Saved (Notifications Disabled)'),
        ),
      );
    }
  }

  Future<void> _scheduleDay(int dayOfWeek) async {
    // 1 = Monday, 7 = Sunday
    await flutterLocalNotificationsPlugin.zonedSchedule(
      dayOfWeek, // ID based on day
      "Amakuru y'umunsi",
      "Soma inyigisho yawe y'uyu munsi.", // Dynamic content would require background fetch workManager, keeping simple for now
      _nextInstanceOfDay(dayOfWeek),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reading_channel',
          'Daily Readings',
          channelDescription: 'Daily reading notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  tz.TZDateTime _nextInstanceOfDay(int dayOfWeek) {
    // dayOfWeek: DateTime.monday (1) to DateTime.sunday (7)
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      _notificationTime.hour,
      _notificationTime.minute,
    );

    while (scheduledDate.weekday != dayOfWeek) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _notificationTime,
    );
    if (picked != null && picked != _notificationTime) {
      setState(() {
        _notificationTime = picked;
      });
    }
  }

  void _toggleAllDays(bool? value) {
    setState(() {
      _allDays = value ?? false;
      _monday = _allDays;
      _tuesday = _allDays;
      _wednesday = _allDays;
      _thursday = _allDays;
      _friday = _allDays;
      _saturday = _allDays;
      _sunday = _allDays;
    });
  }

  void _checkAllDaysState() {
    if (_monday &&
        _tuesday &&
        _wednesday &&
        _thursday &&
        _friday &&
        _saturday &&
        _sunday) {
      if (!_allDays) {
        // Only update if needed to avoid loops if set inside build
        _allDays = true;
      }
    } else {
      if (_allDays) {
        _allDays = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          "Amakuru y'umunsi",
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
            // Enable Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ONGERA UBUTUMWA",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _notificationsEnabled,
                  activeColor: AppColors.black,
                  onChanged: (bool value) {
                    if (value) {
                      _requestPermissions();
                    } else {
                      setState(() {
                        _notificationsEnabled = false;
                      });
                      // Optionally save immediately
                      SharedPreferences.getInstance().then(
                        (prefs) =>
                            prefs.setBool('notifications_enabled', false),
                      );
                    }
                  },
                ),
              ],
            ),
            Text(
              "(Enable notifications)",
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.darkGray),
            ),
            const SizedBox(height: 24),

            // Time Picker
            Text(
              "Isaha y'ubutumwa:",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _notificationsEnabled ? () => _selectTime(context) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _notificationTime.format(context),
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.unfold_more, color: AppColors.darkGray),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Frequency (Days)
            Text(
              "Hitamo Iminsi:",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            CheckboxListTile(
              title: Text(
                "Iminsi yose",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
              value: _allDays,
              activeColor: AppColors.black,
              onChanged: _notificationsEnabled ? _toggleAllDays : null,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            _buildDayCheckbox("Kuwa mbere", _monday, (val) {
              setState(() => _monday = val!);
              _checkAllDaysState();
            }),
            _buildDayCheckbox("Kuwa kabiri", _tuesday, (val) {
              setState(() => _tuesday = val!);
              _checkAllDaysState();
            }),
            _buildDayCheckbox("Kuwa gatatu", _wednesday, (val) {
              setState(() => _wednesday = val!);
              _checkAllDaysState();
            }),
            _buildDayCheckbox("Kuwa kane", _thursday, (val) {
              setState(() => _thursday = val!);
              _checkAllDaysState();
            }),
            _buildDayCheckbox("Kuwa gatanu", _friday, (val) {
              setState(() => _friday = val!);
              _checkAllDaysState();
            }),
            _buildDayCheckbox("Kuwa gatandatu", _saturday, (val) {
              setState(() => _saturday = val!);
              _checkAllDaysState();
            }),
            _buildDayCheckbox("Ku Cyumweru", _sunday, (val) {
              setState(() => _sunday = val!);
              _checkAllDaysState();
            }),

            const SizedBox(height: 24),

            // Content
            Text(
              "Ibiri mu butumwa:",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            CheckboxListTile(
              title: Text("Itariki", style: GoogleFonts.inter()),
              value: _includeDate,
              activeColor: AppColors.black,
              onChanged: _notificationsEnabled
                  ? (val) => setState(() => _includeDate = val!)
                  : null,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: Text("Umutwe w'inyigisho", style: GoogleFonts.inter()),
              value: _includeTitle,
              activeColor: AppColors.black,
              onChanged: _notificationsEnabled
                  ? (val) => setState(() => _includeTitle = val!)
                  : null,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: Text(
                "Igice gito cy'inyandiko",
                style: GoogleFonts.inter(),
              ),
              value: _includeSnippet,
              activeColor: AppColors.black,
              onChanged: _notificationsEnabled
                  ? (val) => setState(() => _includeSnippet = val!)
                  : null,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),

            const SizedBox(height: 40),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _notificationsEnabled ? _confirmSettings : null,
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCheckbox(
    String title,
    bool value,
    Function(bool?) onChanged,
  ) {
    return SizedBox(
      height: 40,
      child: CheckboxListTile(
        title: Text(title, style: GoogleFonts.inter(fontSize: 14)),
        value: value,
        activeColor: AppColors.black,
        onChanged: _notificationsEnabled ? onChanged : null,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.only(left: 16),
      ),
    );
  }
}
