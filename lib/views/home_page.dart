import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/languages/text_widgets.dart';
import 'package:weather_app/views/favorite_pages.dart';
import 'package:weather_app/views/search_page.dart';
import 'package:weather_app/views/current_location.dart';
import 'package:weather_app/cubit/favorite_cubit.dart';
import 'package:weather_app/cubit/weather_cubit.dart';
import 'package:weather_app/cubit/theme_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('${ErrorMessage.error}: ${snapshot.error}'));
        } else {
          final sharedPreferences = snapshot.data!;
          return homeMultiBlocProvider(sharedPreferences, context);
        }
      },
    );
  }

  MultiBlocProvider homeMultiBlocProvider(
      SharedPreferences sharedPreferences, BuildContext context) {
    return MultiBlocProvider(
      providers: [
        homeWeatherBlocCubitProvider(),
        homeFavoriteBlocCubitProvider(sharedPreferences),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(ProjectKeywords.weather),
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6_outlined),
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white.withOpacity(0.8),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CurrentLocationPage(),
              ),
            );
          },
          child: const Icon(
            Icons.sunny,
            color: Colors.orange,
            size: 36,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.star), label: ProjectKeywords.favorites),
            BottomNavigationBarItem(
                icon: Icon(Icons.search), label: ProjectKeywords.search),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            FavoritePage(),
            SearchPage(),
          ],
        ),
      ),
    );
  }

  BlocProvider<FavoriteCubit> homeFavoriteBlocCubitProvider(
      SharedPreferences sharedPreferences) {
    return BlocProvider(
      create: (context) => FavoriteCubit(
        context.read<WeatherCubit>(),
        sharedPreferences,
      ),
    );
  }

  BlocProvider<WeatherCubit> homeWeatherBlocCubitProvider() =>
      BlocProvider(create: (context) => WeatherCubit());
}
