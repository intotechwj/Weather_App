import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/cubit/weather_cubit.dart';
import 'package:weather_app/cubit/weather_state.dart';

class CurrentLocationPage extends StatelessWidget {
  const CurrentLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current weather for the location
    _fetchCurrentWeather(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Location Weather'),
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WeatherLoaded) {
            final weather = state.weather;
            return Center(
              child: Column(
                children: [
                  Image.network(weather.icon),
                  Text('City: ${weather.cityName}'),
                  Text('Temperature: ${weather.temperature}°C'),
                  Text('Description: ${weather.description}'),
                ],
              ),
            );
          } else if (state is WeatherError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Fetching current location...'));
        },
      ),
    );
  }

  Future<void> _fetchCurrentWeather(BuildContext context) async {
    final position = await _determinePosition();
    if (position != null) {
      final city = '${position.latitude},${position.longitude}';
      context.read<WeatherCubit>().fetchWeather(city);
    }
  }

  Future<Position?> _determinePosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return Future.error('Location permissions are denied');
        }
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }
}
