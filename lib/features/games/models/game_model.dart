import 'genre_model.dart';
import 'platform_model.dart';

class Game {
  final int id;
  final String title;
  final String genre;
  final double rating;
  final String imageUrl;
  final List<Platform> platforms;

  Game({
    required this.id,
    required this.title,
    required this.genre,
    required this.rating,
    required this.imageUrl,
    required this.platforms,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> ensureMapList(dynamic data) {
      if (data == null) return [];
      if (data is List) {
        return data.where((e) => e != null).map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      if (data is Map) {
        return data.values.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      return [];
    }

    final List<Genre> genres = ensureMapList(json['genres'])
        .map((g) => Genre.fromJson(g))
        .toList();

    final List<Platform> platforms = ensureMapList(json['platforms'])
        .map((p) => Platform.fromJson(p))
        .toList();

    String allGenres = genres.isNotEmpty
        ? genres.map((g) => g.name).join(', ')
        : 'Unknown';

    return Game(
      id: json['id'] ?? 0,
      title: json['name'] ?? 'No Title',
      genre: allGenres,
      rating: (json['rating'] ?? 0.0).toDouble(),
      imageUrl: json['backgroundImage'] ?? json['background_image'] ?? '',
      platforms: platforms,
    );
  }
}