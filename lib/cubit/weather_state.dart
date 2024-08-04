import 'package:equatable/equatable.dart';
import 'package:weather_app/models/weather_model.dart';

// WeatherState soyut sınıfı, tüm durum sınıflarının temeli
abstract class WeatherState extends Equatable {
  const WeatherState(); // Constructor

  @override
  List<Object> get props => []; // Equatable, nesnelerin eşitliğini kolaylaştırır
}

// İlk baştaki durum
class WeatherInitial extends WeatherState {}

// Veri yüklenirkenki durum
class WeatherLoading extends WeatherState {}

// Veri yüklendikten sonraki durum
class WeatherLoaded extends WeatherState {
  final Weather weather; // Yüklü hava durumu verisi

  const WeatherLoaded(this.weather);

  @override
  List<Object> get props => [weather]; // Equatable ile eşitlik kontrolü için gerekli
}

// Hata durumunda gösterilen durum
class WeatherError extends WeatherState {
  final String message; // Hata mesajı

  const WeatherError(this.message);

  @override
  List<Object> get props => [message]; // Equatable ile eşitlik kontrolü için gerekli
}
