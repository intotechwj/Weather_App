import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/cubit/weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial()); // Başlangıç durumu olarak WeatherInitial'ı ayarla

  final Dio _dio = Dio(); // Dio HTTP istemcisi

  // Hava durumu verisini çeken fonksiyon
  Future<void> fetchWeather(String city) async {
    final apiKey = '36a06512f3094315ad4112041240208'; // weatherapi.com API anahtarınızı buraya koyun
    final url = 'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city';

    try {
      emit(WeatherLoading()); // Veri yüklenmeye başlandığında durumunu güncelle
      final response = await _dio.get(url); // HTTP GET isteği

      if (response.statusCode == 200) {
        final jsonResponse = response.data; // Gelen yanıtın JSON verisi
        final weather = Weather.fromJson(jsonResponse); // JSON'dan Weather nesnesine dönüştürme
        emit(WeatherLoaded(weather)); // Yüklü veri durumunu yay
      } else {
        emit(const WeatherError('Failed to load weather data')); // Hata durumunu yay
      }
    } catch (e) {
      emit(WeatherError(e.toString())); // Hata durumunu yay
    }
  }
}
