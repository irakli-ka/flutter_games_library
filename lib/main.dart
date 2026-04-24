import 'package:flutter/material.dart';
import 'pages/main_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<List<GameItem>> userGames =
  ValueNotifier<List<GameItem>>([]);

  @override
  void dispose() {
    userGames.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Games Library',
      theme: AppTheme.darkTheme,
      home: MainPage(userGames: userGames),
    );
  }
}