import 'package:bloc/bloc.dart';
import 'package:weather_app/cubit/weather_cubit.dart';
import 'package:weather_app/cubit/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final WeatherCubit weatherCubit;

  FavoriteCubit(this.weatherCubit) : super(FavoriteInitial());

  void addFavoriteCity(String cityName) {
    if (state is FavoriteLoaded) {
      final currentState = state as FavoriteLoaded;
      emit(FavoriteLoaded([...currentState.favorites, cityName]));
      weatherCubit.fetchWeatherForCities([...currentState.favorites, cityName]);
    } else {
      emit(FavoriteLoaded([cityName]));
      weatherCubit.fetchWeatherForCities([cityName]);
    }
  }

  void removeFavoriteCity(String cityName) {
    if (state is FavoriteLoaded) {
      final currentState = state as FavoriteLoaded;
      final updatedFavorites =
          currentState.favorites.where((city) => city != cityName).toList();
      emit(FavoriteLoaded(updatedFavorites));
      weatherCubit.fetchWeatherForCities(updatedFavorites);
    }
  }
}
