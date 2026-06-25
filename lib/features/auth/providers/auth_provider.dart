import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../profile/models/user_model.dart';
import '../../profile/repository/profile_repository.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  final ProfileRepository _userRepository = ProfileRepository();

  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;

  String? get error => _error;

  UserModel? get userModel => _userModel;

  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _repository.authStateChanges.listen((user) async {
      _user = user;
      if (user != null) {
        _userModel = await _userRepository.getCurrentUserProfile();
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  User? get user => _user;

  Future<void> logout() async {
    await _repository.signOut();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.logInWithUsername(username, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.signUp(
          email: email,
          username: username,
          password: password
      );

      _userModel = await _userRepository.getCurrentUserProfile();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}