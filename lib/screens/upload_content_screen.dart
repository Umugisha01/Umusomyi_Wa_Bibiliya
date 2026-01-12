import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../data/reading_service.dart';

class UploadContentScreen extends StatefulWidget {
  const UploadContentScreen({super.key});

  @override
  State<UploadContentScreen> createState() => _UploadContentScreenState();
}

class _UploadContentScreenState extends State<UploadContentScreen> {
  int _selectedOption = 0;
  PlatformFile? _selectedFile; // Use PlatformFile instead of File
  final ReadingService _readingService = ReadingService();
  bool _isLoading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'txt'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.single;
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) return;

    setState(() => _isLoading = true);
    try {
      List<int>? fileBytes;
      String fileName = _selectedFile!.name;

      if (kIsWeb) {
        fileBytes = _selectedFile!.bytes;
      } else {
        // On mobile, bytes might be null, so read from path
        if (_selectedFile!.path != null) {
          fileBytes = await File(_selectedFile!.path!).readAsBytes();
        }
      }

      if (fileBytes == null) {
        throw Exception("Could not read file data");
      }

      String message = await _readingService.uploadReadings(
        fileBytes,
        fileName,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Ongera Inyigisho",
          style: GoogleFonts.inter(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hitamo uburyo:",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            RadioListTile(
              value: 0,
              groupValue: _selectedOption,
              onChanged: (val) => setState(() => _selectedOption = val as int),
              title: Text("CSV/Excel"),
              activeColor: AppColors.black,
            ),
            RadioListTile(
              value: 1,
              groupValue: _selectedOption,
              onChanged: null,
              title: Text("PDF (Coming Soon)"),
              activeColor: AppColors.black,
            ),
            RadioListTile(
              value: 2,
              groupValue: _selectedOption,
              onChanged: null,
              title: Text("Word (Coming Soon)"),
              activeColor: AppColors.black,
            ),
            const SizedBox(height: 32),

            InkWell(
              onTap: _pickFile,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.mediumGray,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.background,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_open,
                      size: 48,
                      color: AppColors.mediumGray,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedFile != null
                          ? _selectedFile!.name
                          : "FATA IFAYIRO",
                      style: GoogleFonts.inter(color: AppColors.mediumGray),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Inyandiko yuzuye:",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "2026-01-01 | Umusi mwiza | Gen 1:1-5\n2026-01-02 | ...",
              style: GoogleFonts.sourceCodePro(
                fontSize: 12,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (_selectedFile != null && !_isLoading)
                    ? _uploadFile
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  foregroundColor: AppColors.white,
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: AppColors.white)
                    : Text(
                        "EMEZA",
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
