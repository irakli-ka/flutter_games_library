import '../../../core/network/dio_client.dart';
import '../models/game_details_model.dart';
import '../models/game_model.dart';

class GameRepository {
  final DioClient _dioClient = DioClient();

  Future<List<Game>> fetchGames({int page = 1, String? search}) async {
    try {
      final response = await _dioClient.dio.get(
        'games',
        queryParameters: {
          'page': page,
          'page_size': 20,
        },
      );

      final List results = response.data['results'];
      return results.map((json) => Game.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load games: $e');
    }
  }

  Future<GameDetails> fetchGameDetails(int id) async {
    try {
      final response = await _dioClient.dio.get('games/$id');

      final screenshotsResponse = await _dioClient.dio.get('games/$id/screenshots');
      final List screenshotsResults = screenshotsResponse.data['results'] ?? [];
      final List<String> screenshots = screenshotsResults
          .map((s) => s['image'] as String)
          .toList();

      return GameDetails.fromJson(response.data, screenshots: screenshots);
    } catch (e) {
      throw Exception('Failed to load game details: $e');
    }
  }
}