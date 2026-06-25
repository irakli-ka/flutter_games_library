import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import '../../games/models/game_model.dart';
import '../models/user_model.dart';

class ProfileRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  Future<UserModel?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final snapshot = await _db.ref('users/${user.uid}').get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return UserModel(
        username: data['username'] ?? '',
        email: data['email'] ?? '',
      );
    }
    return null;
  }

  Future<void> addGameToLibrary(Game game) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final gameData = {
      'id': game.id,
      'name': game.title,
      'backgroundImage': game.imageUrl,
      'rating': game.rating,
      'genres': game.genre.split(', ').map((g) => {'name': g}).toList(),
      'platforms': game.platforms.map((p) => {
        'platform': {
          'id': p.id,
          'name': p.name,
          'slug': p.slug,
        }
      }).toList(),
    };
    try {
      await _db.ref('user_library/${user.uid}/${game.id}').set(gameData);
    } catch (e) {
      debugPrint('Failed to save game to library: $e');
      throw Exception('Could not save game. Please check your connection.');
    }
  }

  Future<void> removeGameFromLibrary(int gameId) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db.ref('user_library/${user.uid}/$gameId').remove();
  }

  Future<List<Game>> getLibraryGames() async {
    final user = _auth.currentUser;
    if (user == null) return [];
    try {
      final snapshot = await _db.ref('user_library/${user.uid}').get();
      if (snapshot.exists) {
        final dynamic value = snapshot.value;
        List<dynamic> items = [];

        if (value is Map) {
          items = value.values.toList();
        } else if (value is List) {
          items = value.where((e) => e != null).toList();
        }

        return items.map((json) {
          return Game.fromJson(Map<String, dynamic>.from(json as Map));
        }).toList();
      }
    } catch (e) {
      debugPrint('Error fetching library: $e');
    }
    return [];
  }

  Future<String?> getUidByUsername(String username) async {
    try {
      final snapshot = await _db.ref('users')
          .orderByChild('username')
          .equalTo(username)
          .get();
      if (snapshot.exists) {
        final Map<dynamic, dynamic> data = snapshot.value as Map;
        return data.keys.first.toString();
      }
    } catch (e) {
      debugPrint('Error getting UID by username: $e');
    }
    return null;
  }

  Future<List<Game>> getLibraryByUid(String uid) async {
    try {
      final snapshot = await _db.ref('user_library/$uid').get();
      if (snapshot.exists) {
        final Map<dynamic, dynamic> data = snapshot.value as Map;
        return data.values.map((json) => Game.fromJson(Map<String, dynamic>.from(json))).toList();
      }
    } catch (e) {
      debugPrint('Error fetching library by UID: $e');
    }
    return [];
  }

  Future<UserModel?> getUserProfileByUid(String uid) async {
    final snapshot = await _db.ref('users/$uid').get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return UserModel(
        username: data['username'] ?? '',
        email: data['email'] ?? '',
      );
    }
    return null;
  }

}