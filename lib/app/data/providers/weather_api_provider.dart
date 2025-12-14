import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApiProvider {
  final String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<Map<String, dynamic>?> fetchCurrentWeather({required double latitude, required double longitude}) async {
    try {
      final url = Uri.parse(
        '$_baseUrl?latitude=$latitude&longitude=$longitude'
        '&current=temperature_2m,weather_code'
        '&temperature_unit=celsius'
        '&timezone=auto',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 10), onTimeout: () => throw Exception('Weather request timeout'));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('Weather API error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Weather fetch error: $e');
      return null;
    }
  }
}
