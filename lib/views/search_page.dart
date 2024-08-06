import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubit/weather_cubit.dart';
import 'package:weather_app/cubit/weather_state.dart';
import 'package:weather_app/cubit/favorite_cubit.dart';
import 'package:weather_app/languages/text_widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          searchCityBlocBuilder(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Şehir Giriniz',
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final weatherCubit = context.read<WeatherCubit>();
              weatherCubit.fetchWeather(_controller.text);
            },
            child: const Text(ProjectKeywords.fetchWeather),
          ),
        ],
      ),
    );
  }

  BlocBuilder<WeatherCubit, WeatherState> searchCityBlocBuilder() {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state is WeatherInitial) {
          return const Text('Şehir İsmi Giriniz');
        } else if (state is WeatherLoading) {
          return const CircularProgressIndicator();
        } else if (state is WeatherLoaded) {
          return searchCityWeather(state, context);
        } else if (state is WeatherError) {
          return Text('Error: ${state.message}',
              style: const TextStyle(fontSize: 20));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Column searchCityWeather(WeatherLoaded state, BuildContext context) {
    return Column(
      children: [
        Text('${ProjectKeywords.city}: ${state.weather.cityName}',
            style: const TextStyle(fontSize: 20)),
        Text('${ProjectKeywords.temperature}: ${state.weather.temperature}',
            style: const TextStyle(fontSize: 20)),
        Text('${ProjectKeywords.description}: ${state.weather.description}',
            style: const TextStyle(fontSize: 20)),
        Image.network(state.weather.icon),
        ElevatedButton(
          onPressed: () {
            context
                .read<FavoriteCubit>()
                .addFavoriteCity(state.weather.cityName);
          },
          child: const Text(ProjectKeywords.addFavorite),
        ),
      ],
    );
  }
}
