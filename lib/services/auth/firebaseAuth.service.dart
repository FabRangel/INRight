import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton pattern
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register(
    String name,
    String email,
    String password,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection('personas').doc(credential.user!.uid).set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  // Métodos adicionales para gestionar la autenticación

  // Verificar si hay un usuario autenticado
  bool get isAuthenticated => _auth.currentUser != null;

  // Obtener el usuario actual
  User? get currentUser => _auth.currentUser;

  // Stream para observar cambios en el estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Cerrar sesión mejorado
  Future<void> signOut() async {
    try {
      // Limpiar caché y preferencias locales relacionadas con la sesión
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_token');
      await prefs.remove('user_id');
      await prefs.setBool('is_logged_in', false);

      // Cerrar sesión en Firebase
      await _auth.signOut();
    } catch (e) {
      throw e; // Re-lanzar el error para manejarlo en la UI si es necesario
    }
  }

  // Restablecer contraseña
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Obtener token de autenticación
  Future<String?> getIdToken() async {
    final user = _auth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  // Verificar estado de autenticación y token
  Future<bool> verifyAuthStatus() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Forzar actualización del token para verificar validez
      await currentUser.reload();
      final token = await currentUser.getIdToken(true);

      return token != null && token.isNotEmpty;
    } catch (e) {
      print("Error verificando autenticación: $e");
      return false;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // cancelado

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint('❌ Google Sign-In error: $e');
      rethrow;
    }
  }
}
