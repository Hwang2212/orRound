class WeatherData {
  final double temperature;
  final String condition;
  final int weatherCode;

  WeatherData({
    required this.temperature,
    required this.condition,
    required this.weatherCode,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    final temp = (current['temperature_2m'] as num).toDouble();
    final code = current['weather_code'] as int;

    return WeatherData(
      temperature: temp,
      weatherCode: code,
      condition: _mapWeatherCode(code),
    );
  }

  static String _mapWeatherCode(int code) {
    if (code == 0) return 'Clear sky';
    if (code >= 1 && code <= 3) return 'Partly cloudy';
    if (code == 45 || code == 48) return 'Fog';
    if (code >= 51 && code <= 67) return 'Rain';
    if (code >= 71 && code <= 77) return 'Snow';
    if (code >= 80 && code <= 99) return 'Thunderstorm';
    return 'Unknown';
  }

  String get formattedTemperature => '${temperature.round()}°C';
}
