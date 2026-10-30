import 'package:flutter/material.dart';

// [PERUBAHAN TAHAP 7.5]
import 'pages/splash_screen_page.dart';

void main() {
  runApp(const SmartKasirApp());
}

class SmartKasirApp extends StatelessWidget {
  const SmartKasirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartKasir',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal, // Tema Hijau Teal
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),

      // [PERUBAHAN TAHAP 7.5]
      home: const SplashScreenPage(),
    );
  }
}
