import 'package:flutter/material.dart';

import '../screens/loading_page.dart';

class HangmanApp extends StatelessWidget {
  const HangmanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Forca',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF146C70)),
        useMaterial3: true,
      ),
      home: const LoadingPage(),
    );
  }
}
