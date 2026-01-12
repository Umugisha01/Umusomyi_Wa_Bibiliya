import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reading_model.dart';

class ReadingService {
  // Use localhost for Web. For Android Emulator use 10.0.2.2.
  // We can switch based on platform if needed, but for now user is on Web mainly.
  // 10.0.2.2 won't work on Web. localhost won't work on Android Emulator.
  // Simple heuristic:
  static String get baseUrl {
    // We use the LAN IP for everything now.
    // This allows:
    // 1. Android Emulator (accessing host IP).
    // 2. Physical device (accessing host IP).
    // 3. Web browser on Phone (accessing host IP).
    // Note: This requires the PC and Phone to be on the same WiFi.
    return 'http://172.17.192.1:8080/api/readings';
  }

  Future<List<Reading>> getAllReadings() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Reading.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load readings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching readings: $e');
      return [];
    }
  }

  Future<String> uploadReadings(List<int> bytes, String filename) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));

    request.files.add(
      http.MultipartFile.fromBytes('file', bytes, filename: filename),
    );

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to upload file: ${response.body}');
      }
    } catch (e) {
      print('Error uploading file: $e');
      throw Exception('Error uploading file: $e');
    }
  }
}
