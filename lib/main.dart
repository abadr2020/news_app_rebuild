import 'package:flutter/material.dart';
import 'package:news_app/screens/splash_screen.dart';
import 'package:news_app/theme.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Newsly',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const SplashScreen(),
    );
  }
}

/// To-DO:
/// Add dio service for API calls
/// Add Service for fetching news articles
/// Add models for news articles
