import 'package:duocdev/screens/home_screen.dart';
import 'package:duocdev/screens/profile_screen.dart';
import 'package:duocdev/screens/route_screen.dart';
import 'package:duocdev/screens/smart_practice_screen.dart';
import 'package:duocdev/screens/tutor_screen.dart';
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
      HomeScreen(
        onGoToRoute: () => setState(() => page = 1),
        onGoToPractice: () => setState(() => page = 2),
        onGoToTutor: () => setState(() => page = 3),
      ),
      const RouteScreen(),
      const SmartPracticeScreen(),
      const TutorScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: pages[page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: page,
        onTap: (value) => setState(() => page = value),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF111827),
        selectedItemColor: const Color(0xFF8B5CF6),
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Cursos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology_alt_rounded),
            label: 'Práctica',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Tutor IA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
