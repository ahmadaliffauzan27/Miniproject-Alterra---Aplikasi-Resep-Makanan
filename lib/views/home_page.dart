import 'package:flutter/material.dart';
import 'package:resep_makanan/views/screens/navbar/custom_bottom_navbar.dart';
import 'package:resep_makanan/views/screens/profile/profile_screen.dart';
import 'package:resep_makanan/views/screens/recommendation/recomendation_screen.dart';
import 'package:resep_makanan/views/screens/home/home_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          // Halaman dengan indeks 0
          ResepHome(),
          // Halaman dengan indeks 1
          RekomendasiPage(),
          // Halaman dengan indeks 2
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }
}
