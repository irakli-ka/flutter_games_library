import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../games/models/game_model.dart';
import '../repository/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _profileRepository = ProfileRepository();

  List<Game> _libraryGames = [];
  bool _isLoading = false;

  List<Game> get libraryGames => _libraryGames;

  bool get isLoading => _isLoading;

  ProfileProvider() {
    _initAuthListener();
  }

  void _initAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        fetchLibrary();
      } else {
        _libraryGames = [];
        notifyListeners();
      }
    });
  }

  Future<void> fetchLibrary() async {
    _isLoading = true;
    notifyListeners();

    _libraryGames = await _profileRepository.getLibraryGames();

    _isLoading = false;
    notifyListeners();
  }

  bool isInLibrary(int gameId) {
    return _libraryGames.any((g) => g.id == gameId);
  }

  Future<void> toggleLibrary(Game game) async {
    if (isInLibrary(game.id)) {
      await _profileRepository.removeGameFromLibrary(game.id);
      _libraryGames.removeWhere((g) => g.id == game.id);
    } else {
      await _profileRepository.addGameToLibrary(game);
      _libraryGames.add(game);
    }
    notifyListeners();
  }
}