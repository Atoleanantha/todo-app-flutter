
// weather_response_model.dart
import 'current_weather_model.dart';
import 'location_model.dart';

class WeatherResponse {
  final Location location;
  final CurrentWeather current;

  WeatherResponse({required this.location, required this.current});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      location: Location.fromJson(json['location']),
      current: CurrentWeather.fromJson(json['current']),
    );
  }
}