import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/cubit/weather_cubit.dart';
import 'package:weather_app/cubit/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final WeatherCubit weatherCubit;
  final SharedPreferences sharedPreferences;

  FavoriteCubit(this.weatherCubit, this.sharedPreferences)
      : super(FavoriteInitial()) {
    _loadFavorites();
  }

  void _loadFavorites() {
    final favoriteCities =
        sharedPreferences.getStringList('favoriteCities') ?? [];
    if (favoriteCities.isNotEmpty) {
      emit(FavoriteLoaded(favoriteCities));
      weatherCubit.fetchWeatherForCities(favoriteCities);
    }
  }

  void _saveFavorites(List<String> favoriteCities) {
    sharedPreferences.setStringList('favoriteCities', favoriteCities);
  }

  void addFavoriteCity(String cityName) {
    if (state is FavoriteLoaded) {
      final currentState = state as FavoriteLoaded;
      final updatedFavorites = [...currentState.favorites, cityName];
      emit(FavoriteLoaded(updatedFavorites));
      _saveFavorites(updatedFavorites);
      weatherCubit.fetchWeatherForCities(updatedFavorites);
    } else {
      emit(FavoriteLoaded([cityName]));
      _saveFavorites([cityName]);
      weatherCubit.fetchWeatherForCities([cityName]);
    }
  }

  void removeFavoriteCity(String cityName) {
    if (state is FavoriteLoaded) {
      final currentState = state as FavoriteLoaded;
      final updatedFavorites =
          currentState.favorites.where((city) => city != cityName).toList();
      emit(FavoriteLoaded(updatedFavorites));
      _saveFavorites(updatedFavorites);
      weatherCubit.fetchWeatherForCities(updatedFavorites);
    }
  }
}
