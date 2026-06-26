import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/principle.dart';
import '../data/principles_data.dart';

class ApiService {
  static const String baseUrl = 'https://newstartapi-production.up.railway.app/api';
  static const String cacheKey = 'cached_principles';

  // Holds the last error message to show in the UI
  String? lastErrorMessage;

  Future<List<Principle>> fetchPrinciples() async {
    lastErrorMessage = null;
    try {
      debugPrint('ApiService: Starting fetch from $baseUrl');

      final response = await http.get(Uri.parse('$baseUrl/principles')).timeout(
        const Duration(seconds: 12),
      );

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);
        if (decoded is! List) {
          throw 'Unexpected API format: expected a list.';
        }

        final List<dynamic> data = decoded;
        debugPrint('ApiService: Found ${data.length} principles. Fetching details...');

        // Fetch details in parallel
        final List<Future<Principle?>> detailFutures = data.map((item) async {
          try {
            final id = item['id'];
            final detailResponse = await http.get(Uri.parse('$baseUrl/principles/$id'))
                .timeout(const Duration(seconds: 8));

            if (detailResponse.statusCode == 200) {
              return Principle.fromJson(json.decode(detailResponse.body));
            }
          } catch (e) {
            debugPrint('ApiService: Detail fetch failed for item: $e');
          }
          return null;
        }).toList();

        final List<Principle?> results = await Future.wait(detailFutures);
        final List<Principle> apiPrinciples = results.whereType<Principle>().toList();

        if (apiPrinciples.isEmpty) {
          lastErrorMessage = "No data found on server.";
          return _loadFromCache();
        }

        final mergedData = _mergeWithLocalData(apiPrinciples);
        _saveToCache(mergedData);
        return mergedData;
      } else {
        lastErrorMessage = "Server error: ${response.statusCode}";
        return _loadFromCache();
      }
    } on SocketException {
      lastErrorMessage = "No internet connection.";
      return _loadFromCache();
    } on HttpException {
      lastErrorMessage = "Could not find the health server.";
      return _loadFromCache();
    } catch (e) {
      debugPrint('ApiService Error: $e');
      lastErrorMessage = "Fetch failed: $e";
      return _loadFromCache();
    }
  }

  Future<void> _saveToCache(List<Principle> principles) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = json.encode(principles.map((p) => p.toJson()).toList());
      await prefs.setString(cacheKey, encoded);
      debugPrint('ApiService: Data saved to cache');
    } catch (e) {
      debugPrint('ApiService Cache Error: $e');
    }
  }

  Future<List<Principle>> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cached = prefs.getString(cacheKey);
      if (cached != null) {
        final List<dynamic> decoded = json.decode(cached);
        debugPrint('ApiService: Loaded data from cache');
        return decoded.map((item) => Principle.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('ApiService Load Cache Error: $e');
    }
    return principlesData;
  }

  Future<void> saveDeviceToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/save-token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'token': token}),
      );

      if (response.statusCode == 200) {
        debugPrint('ApiService: Device token saved to server');
      } else {
        debugPrint('ApiService: Failed to save token. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('ApiService Token Error: $e');
    }
  }

  List<Principle> _mergeWithLocalData(List<Principle> apiPrinciples) {
    List<Principle> merged = List.from(principlesData);
    for (var apiPrinciple in apiPrinciples) {
      int index = merged.indexWhere((p) => p.title.toLowerCase() == apiPrinciple.title.toLowerCase());
      if (index != -1) {
        // Only merge if the API actually provided lessons or quizzes.
        // If the API version is missing quizzes, keep the local ones as a fallback.
        final lessons = apiPrinciple.lessons.isNotEmpty ? apiPrinciple.lessons : merged[index].lessons;
        final quizzes = apiPrinciple.quizQuestions.isNotEmpty ? apiPrinciple.quizQuestions : merged[index].quizQuestions;

        merged[index] = Principle(
          id: apiPrinciple.id,
          title: apiPrinciple.title,
          heroImagePath: apiPrinciple.heroImagePath,
          lessons: lessons,
          quizQuestions: quizzes,
        );
      } else {
        merged.add(apiPrinciple);
      }
    }
    return merged;
  }
}
