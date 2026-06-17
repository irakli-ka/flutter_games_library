import 'package:flutter/foundation.dart';
import '../models/game_details_model.dart';
import '../models/game_model.dart';
import '../repositories/game_repository.dart';

class GameProvider extends ChangeNotifier {
  final GameRepository _gameRepository = GameRepository();

  List<Game> _games = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  String? _error;
  int _currentPage = 1;
  String? _searchQuery;

  List<Game> get games => _games;

  bool get isLoading => _isLoading;

  bool get isFetchingMore => _isFetchingMore;

  String? get error => _error;

  GameProvider() {
    fetchGames();
  }

  Future<void> fetchGames({String? query}) async {
    _isLoading = true;
    _error = null;
    _currentPage = 1;
    _searchQuery = query;
    notifyListeners();

    try {
      _games = await _gameRepository.fetchGames(
        page: _currentPage,
        search: _searchQuery,
      );
    } catch (e) {
      _error = e.toString();
      _games = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreGames() async {
    if (_isFetchingMore || _isLoading) return;

    _isFetchingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final newGames = await _gameRepository.fetchGames(
        page: nextPage,
        search: _searchQuery,
      );

      if (newGames.isNotEmpty) {
        _games.addAll(newGames);
        _currentPage = nextPage;
      }
    } catch (e) {
      debugPrint('Error loading more games: $e');
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  void searchGames(String query) {
    fetchGames(query: query);
  }

  final List<Game> _userFavorites = [];

  List<Game> get userFavorites => _userFavorites;

  bool isFavorite(Game game) {
    return _userFavorites.any((g) => g.id == game.id);
  }

  void addToFavorites(Game game) {
    if (!isFavorite(game)) {
      _userFavorites.add(game);
      notifyListeners();
    }
  }

  void removeFromFavorites(Game game) {
    _userFavorites.removeWhere((g) => g.id == game.id);
    notifyListeners();
  }

  GameDetails? _selectedGameDetails;
  bool _isDetailsLoading = false;

  GameDetails? get selectedGameDetails => _selectedGameDetails;
  bool get isDetailsLoading => _isDetailsLoading;

  Future<void> fetchGameDetails(int id) async {
    _isDetailsLoading = true;
    _selectedGameDetails = null;
    notifyListeners();

    try {
      _selectedGameDetails = await _gameRepository.fetchGameDetails(id);
    } catch (e) {
      debugPrint('Error fetching details: $e');
    } finally {
      _isDetailsLoading = false;
      notifyListeners();
    }
  }
}