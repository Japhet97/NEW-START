import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BibleService {
  // Using a simpler, more reliable Bible API
  static const String apiUrl = 'https://bible-api.com/';
  static const String verseCacheKeyPrefix = 'cached_verse_v2_';

  // This list defines the references. The app will fetch the actual text from the API.
  // This makes the content "dynamic" as it pulls the latest translation text.
  final List<String> healthVerseReferences = [
    '3 John 1:2',
    '1 Corinthians 6:19',
    '1 Corinthians 10:31',
    'Proverbs 3:7-8',
    'Proverbs 4:20-22',
    'Exodus 15:26',
    'Psalm 103:2-3',
    'Isaiah 58:8',
    'Psalm 147:3',
    'Proverbs 17:22',
  ];

  Future<Map<String, String>> fetchRandomHealthVerse() async {
    final random = Random();
    final reference = healthVerseReferences[random.nextInt(healthVerseReferences.length)];
    final cacheKey = '$verseCacheKeyPrefix${reference.replaceAll(' ', '_')}';

    debugPrint('BibleService: Fetching verse for: $reference');

    try {
      // Encode the reference for the URL (e.g., "3 John 1:2" -> "3+John+1:2")
      final encodedRef = Uri.encodeComponent(reference);
      final response = await http.get(Uri.parse('$apiUrl$encodedRef')).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String text = data['text'].toString().trim();
        final String ref = data['reference'].toString();

        final verse = {
          'text': text,
          'reference': ref,
        };

        _saveToCache(cacheKey, verse);
        return verse;
      }
      throw 'Server error: ${response.statusCode}';
    } catch (e) {
      debugPrint('BibleService: API failed ($e). Checking cache...');
      final cached = await _loadFromCache(cacheKey);
      if (cached != null) return cached;

      // Ultimate fallback if even cache is empty
      return {
        'text': 'Beloved, I pray that you may prosper in all things and be in health, just as your soul prospers.',
        'reference': '3 John 1:2'
      };
    }
  }

  Future<void> _saveToCache(String key, Map<String, String> verse) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, json.encode(verse));
    } catch (e) {
      debugPrint('BibleService Cache Error: $e');
    }
  }

  Future<Map<String, String>?> _loadFromCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cached = prefs.getString(key);
      if (cached != null) {
        return Map<String, String>.from(json.decode(cached));
      }
    } catch (e) {
      debugPrint('BibleService Load Cache Error: $e');
    }
    return null;
  }
}
