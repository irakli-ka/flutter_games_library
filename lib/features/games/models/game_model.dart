import 'genre_model.dart';
import 'platform_model.dart';

class Game {
  final int id;
  final String title;
  final String genre;
  final double rating;
  final String imageUrl;
  final int metacritic;
  final List<Platform> platforms;

  Game({
    required this.id,
    required this.title,
    required this.genre,
    required this.rating,
    required this.imageUrl,
    required this.metacritic,
    required this.platforms,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    final List<Genre> genres = (json['genres'] as List?)
        ?.map((g) => Genre.fromJson(g))
        .toList() ?? [];

    final List<Platform> platforms = (json['platforms'] as List?)
        ?.map((p) => Platform.fromJson(p))
        .toList() ?? [];

    String allGenres = genres.isNotEmpty
        ? genres.map((g) => g.name).join(', ')
        : 'Unknown';

    return Game(
      id: json['id'] ?? 0,
      title: json['name'] ?? 'No Title',
      genre: allGenres,
      rating: (json['rating'] ?? 0.0).toDouble(),
      imageUrl: json['background_image'] ?? '',
      metacritic: json['metacritic'] ?? 0,
      platforms: platforms,
    );
  }
}