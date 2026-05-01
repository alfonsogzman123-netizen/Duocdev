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
      const _ExploreScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: pages[page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: page,
        onTap: (value) => setState(() => page = value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'Cursos'),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Explorar'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Perfil'),
        ],
      ),
    );
  }
}

class _ExploreScreen extends StatelessWidget {
  const _ExploreScreen();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(child: Text('Explorar próximamente')),
    );
  }
}
