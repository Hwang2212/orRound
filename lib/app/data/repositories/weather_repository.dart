import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';

class WeatherRepository {
  final String _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  WeatherData? _cachedWeather;
  DateTime? _cacheTime;
  final Duration _cacheDuration = const Duration(minutes: 30);

  Future<WeatherData?> getCurrentWeather(
    double latitude,
    double longitude,
  ) async {
    // Check cache
    if (_cachedWeather != null &&
        _cacheTime != null &&
        DateTime.now().difference(_cacheTime!) < _cacheDuration) {
      return _cachedWeather;
    }

    try {
      final url = Uri.parse(
        '$_baseUrl?latitude=$latitude&longitude=$longitude&current=temperature_2m,weather_code',
      );

      final response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final weather = WeatherData.fromJson(data);

        // Cache the result
        _cachedWeather = weather;
        _cacheTime = DateTime.now();

        return weather;
      }

      return null;
    } catch (e) {
      print('Weather fetch error: $e');
      return null;
    }
  }

  void clearCache() {
    _cachedWeather = null;
    _cacheTime = null;
  }

  WeatherData? getCachedWeather() => _cachedWeather;
}
