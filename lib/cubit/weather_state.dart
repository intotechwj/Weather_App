import 'package:weather_app/models/weather_model.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;

  WeatherLoaded(this.weather);
}

class WeathersLoaded extends WeatherState {
  final List<Weather> weathers;

  WeathersLoaded(this.weathers);
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError(this.message);
}
