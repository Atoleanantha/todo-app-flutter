// weather_repository.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherRepository {
  final String apiKey = '322937af7c964fa0a16154949241407';

  Future<Weather> fetchWeather(double latitude, double longitude) async {
    final response = await http.post(
      Uri.parse('http://api.weatherapi.com/v1/current.json or /current.xml?q=$latitude,$longitude'),
      headers: {
        'key': apiKey,
      },


    );
    print(response);

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {

      throw Exception('Failed to load weather');
    }
  }
}

class Weather {
  final String locationName;
  final double temperature;
  final String condition;

  Weather({required this.locationName, required this.temperature, required this.condition});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      locationName: json['location']['name'],
      temperature: json['current']['temp_c'],
      condition: json['current']['condition']['text'],
    );
  }
}
