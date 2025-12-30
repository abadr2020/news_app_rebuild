import 'package:flutter/material.dart';
import 'package:news_app/presentations/screens/splash_screen.dart';
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
/// Add cubit plugins
/// Add cubit for managing news state
/// update cubit with logic to fetch news using DioService
/// Add models for news articles
/// Use model to parse and display news articles in the UI
