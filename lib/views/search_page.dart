import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubit/weather_cubit.dart';
import 'package:weather_app/cubit/weather_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController(); // Şehir adı için TextField kontrolcüsü

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<WeatherCubit, WeatherState>(
              builder: (context, state) {
                if (state is WeatherInitial) {
                  return const Text('Please enter a city name'); // Başlangıç durumu
                } else if (state is WeatherLoading) {
                  return const CircularProgressIndicator(); // Yükleme durumu
                } else if (state is WeatherLoaded) {
                  return Column(
                    children: [
                      Image.network(state.weather.icon,  scale : 0.5, ), // Hava durumu ikonu
                      Text('Şehir: ${state.weather.cityName}', style: const TextStyle(fontSize: 20)),
                      Text('Sıcaklık: ${state.weather.temperature}', style: const TextStyle(fontSize: 20)),
                      Text('Durum: ${state.weather.description}', style: const TextStyle(fontSize: 20)),
                    ],
                  ); // Veri yüklendiğinde gösterilecek bileşenler
                } else if (state is WeatherError) {
                  return Text('Error: ${state.message}', style: const TextStyle(fontSize: 20)); // Hata durumu
                }
                return const SizedBox(height: 20,); // Boş bileşen
              },
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Şehir Giriniz',
                  hintText: 'Şehir İsmi'
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final weatherCubit = context.read<WeatherCubit>();
                weatherCubit.fetchWeather(_controller.text); // TextField'den alınan şehir adını kullanarak veri çek
              },
              child: const Text('Göster'), // Buton metni
            ),
          ],
        ),
      ),
    );
  }
}
