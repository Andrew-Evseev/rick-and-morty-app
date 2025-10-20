import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';

class ApiService {
  static const String _baseUrl = 'https://rickandmortyapi.com/api';

  Future<List<Character>> getCharacters(int page) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/character?page=$page'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List characters = data['results'];
        
        return characters.map((json) => Character.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load characters');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
