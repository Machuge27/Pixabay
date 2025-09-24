import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pixabay_image.dart';
import '../config/api_config.dart';

class PixabayService {
  static const String _baseUrl = 'https://pixabay.com/api/';
  static const String _apiKey = ApiConfig.pixabayApiKey;

  Future<List<PixabayImage>> searchImages(
    String query, {
    int page = 1,
    String order = 'popular',
    String category = 'all',
    int perPage = 20,
  }) async {
    try {
      final uri = Uri.parse(_baseUrl).replace(queryParameters: {
        'key': _apiKey,
        'q': query.isEmpty ? '' : query,
        'image_type': 'photo',
        'orientation': 'all',
        'category': category,
        'order': order,
        'page': page.toString(),
        'per_page': perPage.toString(),
        'safesearch': 'true',
      });

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> hits = data['hits'] ?? [];
        return hits.map((hit) => PixabayImage(
          id: hit['id'],
          webformatURL: hit['webformatURL'],
          previewURL: hit['previewURL'],
          user: hit['user'],
          tags: hit['tags'],
          views: hit['views'],
          downloads: hit['downloads'],
          likes: hit['likes'],
        )).toList();
      } else {
        throw Exception('Failed to load images: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<PixabayImage>> getTrendingImages() async {
    return searchImages('', order: 'popular');
  }
}