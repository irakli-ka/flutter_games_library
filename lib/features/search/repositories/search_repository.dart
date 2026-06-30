import '../../../core/network/dio_client.dart';
import '../../games/models/game_model.dart';
import '../../games/models/genre_model.dart';
import '../models/store_model.dart';

class SearchRepository {
  final DioClient _dioClient = DioClient();

  Future<List<Genre>> fetchGenres() async {
    try {
      final response = await _dioClient.dio.get('genres');
      final List results = response.data['results'] ?? [];
      return results.map((json) => Genre.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch genres: $e');
    }
  }

  Future<List<Store>> fetchStores() async {
    try {
      final response = await _dioClient.dio.get('stores');
      final List results = response.data['results'] ?? [];
      return results.map((json) => Store.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch stores: $e');
    }
  }

  Future<List<Game>> searchGames({
    String? query,
    String? sortBy,
    List<int>? genreIds,
    List<int>? storeIds,
    bool preciseSearch = false,
    bool exactMatch = false,
    int page = 1,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'page': page,
        'page_size': 20,
      };

      if (query != null && query.isNotEmpty) queryParameters['search'] = query;
      if (preciseSearch) queryParameters['search_precise'] = true;
      if (exactMatch) queryParameters['search_exact'] = true;

      if (sortBy != null) {
        switch (sortBy.toLowerCase()) {
          case 'rating':
            queryParameters['ordering'] = '-rating';
            break;
          case 'release date':
            queryParameters['ordering'] = '-released';
            break;
          case 'name':
            queryParameters['ordering'] = 'name';
            break;
        }
      }

      if (genreIds != null && genreIds.isNotEmpty) {
        queryParameters['genres'] = genreIds.join(',');
      }
      if (storeIds != null && storeIds.isNotEmpty) {
        queryParameters['stores'] = storeIds.join(',');
      }

      final response = await _dioClient.dio.get(
          'games', queryParameters: queryParameters);
      final List results = response.data['results'] ?? [];
      return results.map((json) => Game.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search games: $e');
    }
  }
}