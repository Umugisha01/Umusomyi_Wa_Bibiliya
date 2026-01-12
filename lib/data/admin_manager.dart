import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminManager {
  static const String baseUrl = 'http://172.17.192.1:8080/api/admin';

  Future<bool> isAdmin(String email) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/check?email=$email'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['exists'] == true;
      }
      return false;
    } catch (e) {
      print('Error checking admin status: $e');
      // Fallback for default admin in case of connection error during dev?
      // Better to fail safe (false) or just log.
      if (email == 'umugishaone@gmail.com') return true;
      return false;
    }
  }

  Future<bool> addAdmin(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error adding admin: $e');
      return false;
    }
  }

  // Remove is not yet implemented on backend, placeholder
  Future<bool> removeAdmin(String email) async {
    // TODO: Implement remove endpoint on backend
    return false;
  }
}
