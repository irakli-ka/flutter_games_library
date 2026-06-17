import 'package:flutter/material.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/games/views/game_details_view.dart';
import '../../features/games/views/home_view.dart';
import '../../features/profile/views/profile_view.dart';
import '../../features/search/views/search_result_view.dart';
import '../../features/search/views/search_view.dart';

class AppRouter {
  static const String home = '/';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String searchResult = '/search-result';
  static const String gameDetails = '/game-details';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeView());
      // case login:
      //   return MaterialPageRoute(builder: (_) => const LoginView());
      // case profile:
      //   return MaterialPageRoute(builder: (_) => const UserProfileView());
      // case search:
      //   return MaterialPageRoute(builder: (_) => const SearchView());
      // case searchResult:
      //   return MaterialPageRoute(builder: (_) => const SearchResultView());
      case gameDetails:
        final gameId = settings.arguments as int;
        return MaterialPageRoute(builder: (_) => GameDetailsView(gameId: gameId));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}