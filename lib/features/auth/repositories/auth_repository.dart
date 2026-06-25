import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final snapshot = await _db.ref('username_to_email/$username').get();
      if (snapshot.exists) {
        throw Exception('Username is already taken');
      }

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null) throw Exception('Failed to get user ID');

      final Map<String, dynamic> updates = {
        'users/$uid': {
          'username': username,
          'email': email,
        },
        'username_to_email/$username': email,
      };

      await _db.ref().update(updates);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logInWithUsername(String username, String password) async {
    try {
      final snapshot = await _db.ref('username_to_email/$username').get();

      if (!snapshot.exists) {
        throw Exception('User not found');
      }

      final email = snapshot.value as String;

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() => _auth.signOut();

  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found.');
      case 'wrong-password':
        return Exception('Incorrect password.');
      case 'email-already-in-use':
        return Exception('Email already in use.');
      case 'invalid-email':
        return Exception('Please enter a valid email.');
      default:
        return Exception(e.message ?? 'An unknown error occurred.');
    }
  }
}