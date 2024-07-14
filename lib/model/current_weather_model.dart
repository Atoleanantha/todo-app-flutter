
// current_weather_model.dart
class Condition {
  final String text;
  final String icon;
  final int code;

  Condition({required this.text, required this.icon, required this.code});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      text: json['text'],
      icon: json['icon'],
      code: json['code'],
    );
  }
}

class CurrentWeather {
  final double tempC;
  final double tempF;
  final Condition condition;
  final double windKph;
  final String windDir;
  final int humidity;
  final int cloud;
  final double feelslikeC;
  final double feelslikeF;
  final double visKm;
  final int uv;

  CurrentWeather({
    required this.tempC,
    required this.tempF,
    required this.condition,
    required this.windKph,
    required this.windDir,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.visKm,
    required this.uv,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      tempC: json['temp_c'].toDouble(),
      tempF: json['temp_f'].toDouble(),
      condition: Condition.fromJson(json['condition']),
      windKph: json['wind_kph'].toDouble(),
      windDir: json['wind_dir'],
      humidity: json['humidity'],
      cloud: json['cloud'],
      feelslikeC: json['feelslike_c'].toDouble(),
      feelslikeF: json['feelslike_f'].toDouble(),
      visKm: json['vis_km'].toDouble(),
      uv: json['uv'],
    );
  }
}
