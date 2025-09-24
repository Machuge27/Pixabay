import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_profile.dart';

class ProfileService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<int> submitProfile(UserProfile profile) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(profile.toJson()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['id'];
      } else {
        throw Exception('Failed to submit profile');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}