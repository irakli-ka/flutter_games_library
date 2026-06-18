import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'features/games/providers/game_provider.dart';
import 'features/search/providers/search_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Games Library',
        theme: AppTheme.darkTheme,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRouter.home,

        builder: (context, child) {
          return SafeArea(child: child!);
        },
      ),
    );
  }
}