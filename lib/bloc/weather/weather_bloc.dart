import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/weather_repository.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc(this.weatherRepository) : super(WeatherInitial());

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeather) {
      yield WeatherLoading();
      try {
        final weatherResponse = await weatherRepository.fetchWeather(event.latitude, event.longitude);
        yield WeatherLoaded(weatherResponse);
      } catch (e) {
        yield WeatherError(e.toString());
      }
    }
  }
}