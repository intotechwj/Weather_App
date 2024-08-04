import 'package:flutter/material.dart';
import 'package:weather_app/views/favorite_pages.dart';
import 'package:weather_app/views/search_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Seçili sayfa indeksi

  // Alt menüdeki öğe seçildiğinde tetiklenen fonksiyon
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // FAB tıklamasında tetiklenen fonksiyon
  void _onFabPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FavoritePages()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'), // Uygulama başlığı
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withOpacity(0.8),
        onPressed: _onFabPressed, // FAB tıklama olayı
        child: const Icon(
          Icons.sunny,
          color: Colors.orange,
          size: 36,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'ara'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'favoriler'),
        ],
        currentIndex: _selectedIndex, // Seçili öğe indeksi
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped, // Öğeye tıklama olayı
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          SearchPage(), // İlk sayfa
          Center(child: Text('Index 1: favori', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
