import 'dart:async';

import 'package:scrape_supermarkets_uruguay/src/enums/enums.dart';
import 'package:scrape_supermarkets_uruguay/src/models/models.dart';

abstract class AuthDatasource {
  Future<UserCredential> getCurrentUser();

  Future<UserCredential> signInWithGoogle({
    String? idToken,
    String? accessToken,
  });

  Future<UserCredential> signInWithApple({
    String? idToken,
    String? accessToken,
  });

  Future<UserCredential> signInWithFacebook({
    String? idToken,
    String? accessToken,
    String? rawNonce,
  });

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<void> signOut();

  Future<void> delete();

  Future<List<AuthProvider>> providers();

  Future<void> resetPassword(String password);
}
