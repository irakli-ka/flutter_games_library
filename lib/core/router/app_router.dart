import 'package:flutter/material.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/auth/views/signup_view.dart';
import '../../features/games/views/game_details_view.dart';
import '../../features/games/views/home_view.dart';
import '../../features/profile/views/profile_view.dart';
import '../../features/profile/views/searched_profile_view.dart';
import '../../features/search/views/search_result_view.dart';
import '../../features/search/views/search_view.dart';

class AppRouter {
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String searchResult = '/search-result';
  static const String gameDetails = '/game-details';
  static const String searchUser = '/search-user';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupView());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileView());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchView());
      case searchResult:
        return MaterialPageRoute(builder: (_) => const SearchResultView());
      case gameDetails:
        final gameId = settings.arguments as int;
        return PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) =>
              GameDetailsView(gameId: gameId),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutQuart;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
        case searchUser:
          return MaterialPageRoute(builder: (_) => const SearchedProfileView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
