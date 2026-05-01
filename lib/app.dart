import 'package:duocdev/screens/main_shell.dart';
import 'package:flutter/material.dart';

class DuocDevApp extends StatelessWidget {
  const DuocDevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DuocDev',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1120),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF22D3EE),
          secondary: Color(0xFFA855F7),
        ),
      ),
      home: const MainShell(),
    );
  }
}
