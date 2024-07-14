import '../../model/weather_response_model.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherResponse weatherResponse;

  WeatherLoaded(this.weatherResponse);
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError(this.message);
}
