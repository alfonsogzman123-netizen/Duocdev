import 'package:flutter/material.dart';

void main() {
  runApp(const DuocDevApp());
}

class DuocDevApp extends StatelessWidget {
  const DuocDevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DuocDev',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> niveles = const [
    'Nivel 1 - Lógica de programación',
    'Nivel 2 - Python',
    'Nivel 3 - Git y GitHub',
    'Nivel 4 - Desarrollo Web',
    'Nivel 5 - Java',
    'Nivel 6 - SQL',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('DuocDev'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: niveles.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(niveles[index]),
            ),
          );
        },
      ),
    );
  }
}