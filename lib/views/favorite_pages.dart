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
            return Center(
                child: Text('${ErrorMessage.error}: ${snapshot.error}'));
          } else {
            final sharedPreferences = snapshot.data!;
            return favoriteWeatherBlocProvider(context, sharedPreferences);
          }
        },
      ),
    );
  }

  BlocProvider<FavoriteCubit> favoriteWeatherBlocProvider(
      BuildContext context, SharedPreferences sharedPreferences) {
    return BlocProvider(
      create: (context) => FavoriteCubit(
        BlocProvider.of<WeatherCubit>(context),
        sharedPreferences,
      ),
      child: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, favoriteState) {
          if (favoriteState is FavoriteInitial) {
            return const Center(child: Text(ProjectKeywords.addFavoriteCity));
          } else if (favoriteState is FavoriteLoaded) {
            return _favoriteWeatherBlocProvider(context);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  BlocProvider<WeatherCubit> _favoriteWeatherBlocProvider(
      BuildContext context) {
    return BlocProvider(
      create: (context) => BlocProvider.of<WeatherCubit>(context),
      child: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, weatherState) {
          if (weatherState is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (weatherState is WeathersLoaded) {
            return _favoriteListView(context, weatherState);
          } else if (weatherState is WeatherError) {
            return Center(
                child: Text('${ErrorMessage.error}: ${weatherState.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _favoriteListView(BuildContext context, WeathersLoaded weatherState) {
    return RefreshIndicator(
      onRefresh: () async {
        final favoriteCubit = BlocProvider.of<FavoriteCubit>(context);
        if (favoriteCubit.state is FavoriteLoaded) {
          final favoriteCities =
              (favoriteCubit.state as FavoriteLoaded).favorites;
          await BlocProvider.of<WeatherCubit>(context)
              .fetchWeatherForCities(favoriteCities);
        }
      },
      child: ListView.builder(
        itemCount: weatherState.weathers.length,
        itemBuilder: (context, index) {
          final weather = weatherState.weathers[index];
          return Card(
            key: ValueKey(weather.cityName),
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(weather.cityName,
                    style: const TextStyle(fontSize: 36)),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      weather.icon,
                      loadingBuilder: (context, child, progress) {
                        return progress == null
                            ? child
                            : const CircularProgressIndicator();
                      },
                    ),
                    Text(
                        '${ProjectKeywords.temperature}: ${weather.temperature}${MeasureUnit.centigrade}'),
                    Text(
                        '${ProjectKeywords.feelsLike}: ${weather.feelsLike}${MeasureUnit.centigrade}'),
                    Text(
                        '${ProjectKeywords.humidity}: ${weather.humidity}${MeasureUnit.percent}'),
                    Text(
                        '${ProjectKeywords.description}: ${weather.description}'),
                    const Divider(
                      color: Color.fromARGB(255, 126, 87, 194),
                    ),
                    Column(
                      children: weather.dailyWeather.map((daily) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.deepPurple.shade400,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      '\t${daily.date}\n\t${ProjectKeywords.maxTemp}: ${daily.maxTemp}${MeasureUnit.centigrade}\n\t${ProjectKeywords.minTemp}: ${daily.minTemp}${MeasureUnit.centigrade}'),
                                  Image.network(
                                    daily.icon,
                                    loadingBuilder: (context, child, progress) {
                                      return progress == null
                                          ? child
                                          : const CircularProgressIndicator();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
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
      ),
    );
  }
}
