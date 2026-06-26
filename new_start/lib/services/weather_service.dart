import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherService {
  static const String baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<double?> getCurrentTemperature() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('WeatherService: Location services are disabled.');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('WeatherService: Location permissions are denied.');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('WeatherService: Location permissions are permanently denied.');
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 5),
      );

      final url = '$baseUrl?latitude=${position.latitude}&longitude=${position.longitude}&current=temperature_2m';
      debugPrint('WeatherService: Fetching weather from $url');

      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['current'] != null && data['current']['temperature_2m'] != null) {
          final temp = double.tryParse(data['current']['temperature_2m'].toString());
          debugPrint('WeatherService: Current temperature is $temp°C');
          return temp;
        }
      }
    } catch (e) {
      debugPrint('WeatherService Error: $e');
    }
    return null;
  }
}
