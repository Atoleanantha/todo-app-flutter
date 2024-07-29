// weather_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import '../bloc/weather/weather_bloc.dart';
import '../bloc/weather/weather_event.dart';
import '../bloc/weather/weather_state.dart';
import '../api/weather_repository.dart';

class WeatherCard extends StatelessWidget {
  final WeatherRepository weatherRepository;

  WeatherCard({required this.weatherRepository});

  void _fetchCurrentLocationWeather(BuildContext context) async {
    final location = Location();
    final currentLocation = await location.getLocation();
    BlocProvider.of<WeatherBloc>(context).add(
      FetchWeather(
        latitude: currentLocation.latitude!,
        longitude: currentLocation.longitude!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherInitial) {
          _fetchCurrentLocationWeather(context);
          return Center(child: Text('Fetching weather...'));
        } else if (state is WeatherLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoaded) {
          return WeatherDisplay(weather: state.weather);
        } else if (state is WeatherError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return Container();
      },
    );
  }
}

class WeatherDisplay extends StatelessWidget {
  final Weather weather;

  const WeatherDisplay({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text('Location: ${weather.locationName}'),
          Text('Temperature: ${weather.temperature}°C'),
          Text('Condition: ${weather.condition}'),
        ],
      ),
    );
  }
}
