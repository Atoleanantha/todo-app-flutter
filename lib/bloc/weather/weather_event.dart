// weather_event.dart
abstract class WeatherEvent {}

class FetchWeather extends WeatherEvent {
  final double latitude;
  final double longitude;

  FetchWeather(this.latitude, this.longitude);
}