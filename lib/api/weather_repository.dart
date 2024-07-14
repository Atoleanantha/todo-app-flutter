// weather_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/weather_response_model.dart';


class WeatherRepository {
  final String apiKey = '322937af7c964fa0a16154949241407';

  Future<WeatherResponse> fetchWeather(double latitude, double longitude) async {
    final response = await http.get(Uri.parse('https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$latitude,$longitude'));
    if (response.statusCode == 200) {
      return WeatherResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
