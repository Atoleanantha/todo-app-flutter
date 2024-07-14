
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:location/location.dart';

import '../api/weather_repository.dart';
import '../bloc/weather/weather_bloc.dart';
import '../bloc/weather/weather_event.dart';
import '../bloc/weather/weather_state.dart';
import '../model/weather_response_model.dart';

class WeatherCard extends StatelessWidget {
  final WeatherRepository weatherRepository;

  const WeatherCard({super.key,required this.weatherRepository});

  @override
  Widget build(BuildContext context) {
    return
      BlocProvider(
        create: (context) => WeatherBloc(weatherRepository),
        child:
      BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherInitial) {
          _fetchCurrentLocationWeather(context);
          return Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoaded) {
          return _buildWeatherCard(state.weatherResponse);
        } else if (state is WeatherError) {
          return Center(child: Text(state.message));
        }
        return Container();
      },
    )
      );
  }
}


void _fetchCurrentLocationWeather(BuildContext context) async {
  final Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  // Check if the location service is enabled
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  // Check if the location permission is granted
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  // Get the current location
  _locationData = await location.getLocation();

  // Fetch weather using the current location
  BlocProvider.of<WeatherBloc>(context).add(FetchWeather(_locationData.latitude!, _locationData.longitude!));
}

Widget _buildWeatherCard(WeatherResponse weatherResponse) {
  return Card(
    margin: EdgeInsets.all(16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            weatherResponse.location.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Temperature: ${weatherResponse.current.tempC}°C'),
          Text('Condition: ${weatherResponse.current.condition.text}'),
          Text('Humidity: ${weatherResponse.current.humidity}%'),
          Text('Wind: ${weatherResponse.current.windKph} kph ${weatherResponse.current.windDir}'),
        ],
      ),
    ),
  );
}
