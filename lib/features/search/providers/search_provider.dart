import 'package:flutter/foundation.dart';
import '../../games/models/game_model.dart';
import '../../games/models/genre_model.dart';
import '../models/store_model.dart';
import '../repositories/search_repository.dart';

class SearchProvider extends ChangeNotifier {
  final SearchRepository _searchRepository = SearchRepository();

  List<Game> _searchResults = [];
  List<Genre> _availableGenres = [];
  List<Store> _availableStores = [];

  bool _isLoading = false;
  bool _isLoadingFilters = false;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  String? _error;

  List<Game> get searchResults => _searchResults;

  List<Genre> get availableGenres => _availableGenres;

  List<Store> get availableStores => _availableStores;

  bool get isLoading => _isLoading;

  bool get isLoadingFilters => _isLoadingFilters;

  bool get isFetchingMore => _isFetchingMore;

  String? get error => _error;

  String _query = '';
  String _sortBy = 'rating';
  List<int> _selectedGenreIds = [];
  List<int> _selectedStoreIds = [];
  bool _preciseSearch = false;
  bool _exactMatch = false;

  Future<void> fetchFilters() async {
    if (_isLoadingFilters) return;
    _isLoadingFilters = true;
    _error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _searchRepository.fetchGenres(),
        _searchRepository.fetchStores(),
      ]);
      _availableGenres = results[0] as List<Genre>;
      _availableStores = results[1] as List<Store>;
    } catch (e) {
      _error = 'Failed to load filters: $e';
    } finally {
      _isLoadingFilters = false;
      notifyListeners();
    }
  }

  void updateQuery(String query) {
    _query = query;
    search();
  }

  void updateFilters({
    String? sortBy,
    List<int>? genreIds,
    List<int>? storeIds,
    bool? preciseSearch,
    bool? exactMatch,
  }) {
    if (sortBy != null) _sortBy = sortBy;
    if (genreIds != null) _selectedGenreIds = List.from(genreIds);
    if (storeIds != null) _selectedStoreIds = List.from(storeIds);
    if (preciseSearch != null) _preciseSearch = preciseSearch;
    if (exactMatch != null) _exactMatch = exactMatch;
    notifyListeners();
  }

  Future<void> search() async {
    _isLoading = true;
    _searchResults = [];
    _currentPage = 1;
    _error = null;
    notifyListeners();
    try {
      _searchResults = await _searchRepository.searchGames(
        query: _query,
        sortBy: _sortBy,
        genreIds: _selectedGenreIds,
        storeIds: _selectedStoreIds,
        preciseSearch: _preciseSearch,
        exactMatch: _exactMatch,
        page: _currentPage,
      );
    } catch (e) {
      _error = e.toString();
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoading || _isFetchingMore) return;
    _isFetchingMore = true;
    notifyListeners();
    try {
      final nextPage = _currentPage + 1;
      final newResults = await _searchRepository.searchGames(
        query: _query,
        sortBy: _sortBy,
        genreIds: _selectedGenreIds,
        storeIds: _selectedStoreIds,
        preciseSearch: _preciseSearch,
        exactMatch: _exactMatch,
        page: nextPage,
      );
      if (newResults.isNotEmpty) {
        _searchResults.addAll(newResults);
        _currentPage = nextPage;
      }
    } catch (e) {
      debugPrint('Error loading more: $e');
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }
}