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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            searchCityBlocBuilder(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.streetAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ProjectKeywords.writeCity,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return ErrorMessage.textfieldWarning;
                    }
                    if (value.length <= 2) {
                      return ErrorMessage.textfieldBoundry;
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final weatherCubit = context.read<WeatherCubit>();
                  weatherCubit.fetchWeather(_controller.text);
                }
              },
              child: const Text(ProjectKeywords.fetchWeather),
            ),
          ],
        ),
      ),
    );
  }

  BlocBuilder<WeatherCubit, WeatherState> searchCityBlocBuilder() {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state is WeatherInitial) {
          return const Text(ProjectKeywords.writeCity);
        } else if (state is WeatherLoading) {
          return const CircularProgressIndicator();
        } else if (state is WeatherLoaded) {
          return searchCityWeather(state, context);
        } else if (state is WeatherError) {
          return Text('${ErrorMessage.error}: ${state.message}',
              style: const TextStyle(fontSize: 20));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Column searchCityWeather(WeatherLoaded state, BuildContext context) {
    return Column(
      children: [
        Image.network(state.weather.icon),
        Text('${ProjectKeywords.city}: ${state.weather.cityName}',
            style: const TextStyle(fontSize: 20)),
        Text(
            '${ProjectKeywords.temperature}: ${state.weather.temperature}${MeasureUnit.centigrade}',
            style: const TextStyle(fontSize: 20)),
        Text('${ProjectKeywords.description}: ${state.weather.description}',
            style: const TextStyle(fontSize: 20)),
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
