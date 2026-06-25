import 'package:flutter/foundation.dart';
import '../../games/models/game_model.dart';
import '../models/user_model.dart';
import '../repository/profile_repository.dart';

class SearchUserProvider extends ChangeNotifier {
  final ProfileRepository _profileRepository = ProfileRepository();

  UserModel? _searchedUser;
  List<Game> _userLibrary = [];
  bool _isLoading = false;
  String? _error;

  UserModel? get searchedUser => _searchedUser;

  List<Game> get userLibrary => _userLibrary;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> searchUser(String username) async {
    _isLoading = true;
    _error = null;
    _searchedUser = null;
    _userLibrary = [];
    notifyListeners();

    try {
      final uid = await _profileRepository.getUidByUsername(username);
      if (uid != null) {
        _searchedUser = await _profileRepository.getUserProfileByUid(uid);
        if (_searchedUser != null) {
          _userLibrary = await _profileRepository.getLibraryByUid(uid);
        } else {
          _error = "User profile not found";
        }
      } else {
        _error = "User not found";
      }
    } catch (e) {
      _error = "An error occurred: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}