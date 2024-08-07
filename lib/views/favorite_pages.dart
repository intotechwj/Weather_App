import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/cubit/weather_cubit.dart';
import 'package:weather_app/cubit/weather_state.dart';
import 'package:weather_app/cubit/favorite_cubit.dart';
import 'package:weather_app/cubit/favorite_state.dart';
import 'package:weather_app/languages/text_widgets.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final sharedPreferences = snapshot.data!;
            return favoriteWeatherBlocProvider(sharedPreferences);
          }
        },
      ),
    );
  }

  BlocProvider<FavoriteCubit> favoriteWeatherBlocProvider(
      SharedPreferences sharedPreferences) {
    return BlocProvider(
      create: (context) => FavoriteCubit(
        context.read<WeatherCubit>(),
        sharedPreferences,
      ),
      child: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, favoriteState) {
          if (favoriteState is FavoriteInitial) {
            return const Center(child: Text(ProjectKeywords.addFavoriteCity));
          } else if (favoriteState is FavoriteLoaded) {
            return _favoriteWeatherBlocBuilder();
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  BlocBuilder<WeatherCubit, WeatherState> _favoriteWeatherBlocBuilder() {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, weatherState) {
        if (weatherState is WeatherLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (weatherState is WeathersLoaded) {
          return favoriteListviewBuilder(weatherState);
        } else if (weatherState is WeatherError) {
          return Center(child: Text('${ErrorMessage.error}: ${weatherState.message}'));
        }
        return const SizedBox.shrink();
      },
    );
  }

  ListView favoriteListviewBuilder(WeathersLoaded weatherState) {
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
                Image.network(weather.icon),
                Text(
                    '${ProjectKeywords.temperature}: ${weather.temperature}°C'),
                Text('${ProjectKeywords.description}: ${weather.description}'),
                const Divider(
                  color: Colors.white,
                ),
                Column(
                  children: weather.dailyWeather.map((daily) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '${daily.date}\n${ProjectKeywords.maxTemp}: ${daily.maxTemp}°C\n${ProjectKeywords.minTemp}: ${daily.minTemp}°C'),
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
  }
}
