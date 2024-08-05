import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubit/weather_cubit.dart';
import 'package:weather_app/cubit/weather_state.dart';
import 'package:weather_app/cubit/favorite_cubit.dart';
import 'package:weather_app/cubit/favorite_state.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, favoriteState) {
          if (favoriteState is FavoriteInitial) {
            return const Center(child: Text('No favorite cities yet.'));
          } else if (favoriteState is FavoriteLoaded) {
            return BlocBuilder<WeatherCubit, WeatherState>(
              builder: (context, weatherState) {
                if (weatherState is WeatherLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (weatherState is WeathersLoaded) {
                  return ListView.builder(
                    itemCount: weatherState.weathers.length,
                    itemBuilder: (context, index) {
                      final weather = weatherState.weathers[index];
                      return Card(
                        child: ListTile(
                          title: Text(weather.cityName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Temperature: ${weather.temperature}°C'),
                              Text('Description: ${weather.description}'),
                              Image.network(weather.icon),
                              Column(
                                children: weather.dailyWeather.map((daily) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(daily.date),
                                      Text('Max: ${daily.maxTemp}°C'),
                                      Text('Min: ${daily.minTemp}°C'),
                                      Image.network(daily.icon),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              context
                                  .read<FavoriteCubit>()
                                  .removeFavoriteCity(weather.cityName);
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else if (weatherState is WeatherError) {
                  return Center(child: Text('Error: ${weatherState.message}'));
                }
                return const SizedBox.shrink();
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
