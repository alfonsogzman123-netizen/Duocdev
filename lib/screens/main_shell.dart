import 'package:duocdev/screens/home_screen.dart';
import 'package:duocdev/screens/profile_screen.dart';
import 'package:duocdev/screens/route_screen.dart';
import 'package:flutter/material.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onGoToRoute: () => setState(() => page = 1)),
      const RouteScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: pages[page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: page,
        onTap: (value) => setState(() => page = value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Ruta'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
