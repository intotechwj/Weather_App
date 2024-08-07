import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/cubit/weather_cubit.dart';
import 'package:weather_app/cubit/weather_state.dart';
import 'package:weather_app/languages/text_widgets.dart';

class CurrentLocationPage extends StatefulWidget {
  const CurrentLocationPage({super.key});

  @override
  State<CurrentLocationPage> createState() => _CurrentLocationPageState();
}

class _CurrentLocationPageState extends State<CurrentLocationPage> {
  @override
  void initState() {
    super.initState();
    _fetchCurrentLocationWeather();
  }

  Future<void> _fetchCurrentLocationWeather() async {
    final position = await _determinePosition();
    if (mounted) {
      final weatherCubit = context.read<WeatherCubit>();
      weatherCubit.fetchWeatherByLocation(
          position.latitude, position.longitude);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(ErrorMessage.serviceDisabled);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(ErrorMessage.locationPermissionDenied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(ErrorMessage.locationPermissionPermaDenied);
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ProjectKeywords.weather),
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WeatherLoaded) {
            return currentLocationWeather(state);
          } else if (state is WeatherError) {
            return Center(
              child: Text(
                '${ErrorMessage.error}: ${state.message}',
                style: const TextStyle(fontSize: 20),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Center currentLocationWeather(WeatherLoaded state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.weather.cityName,
            style: const TextStyle(fontSize: 36),
          ),
          Image.network(state.weather.icon),
          Text(
            '${ProjectKeywords.temperature}: ${state.weather.temperature}${MeasureUnit.centigrade}',
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            '${ProjectKeywords.description}: ${state.weather.description}',
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            '${ProjectKeywords.windSpeed}: ${state.weather.windSpeed} ${MeasureUnit.kilometer}',
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            '${ProjectKeywords.humidity}: ${state.weather.humidity}${MeasureUnit.percent}',
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            '${ProjectKeywords.feelsLike}: ${state.weather.feelsLike}${MeasureUnit.centigrade}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          const Text(
            '${ProjectKeywords.hourlyForecast}:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(
            color: Color.fromARGB(255, 126, 87, 194),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.weather.hourlyWeather.length,
              itemBuilder: (context, index) {
                final hourly = state.weather.hourlyWeather[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(hourly.time),
                        Image.network(hourly.icon),
                        Text('${hourly.temperature}${MeasureUnit.centigrade}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
