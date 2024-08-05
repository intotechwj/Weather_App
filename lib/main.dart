import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/views/home_page.dart';
import 'package:weather_app/cubit/weather_cubit.dart';

void main() {
  runApp(const MyApp()); // Uygulama başlatma
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WeatherCubit(), // WeatherCubit'in oluşturulması ve sağlanması
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Debug etiketi kapalı
        title: 'Weather App', // Uygulama başlığı
        theme: ThemeData.dark().copyWith(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        home: const HomePage(), // Ana sayfa
      ),
    );
  }
}
