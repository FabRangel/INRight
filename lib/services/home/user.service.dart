import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime lastFetched;

  UserData({
    required this.name,
    required this.email,
    this.photoUrl,
    required this.lastFetched,
  });

  bool get isCacheValid {
    // Cache es válido por 30 minutos
    return DateTime.now().difference(lastFetched).inMinutes < 30;
  }
}

class UserService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Caché para información del usuario
  UserData? _cachedUserData;

  Future<List<Map<String, dynamic>>> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final snapshot =
        await _firestore
            .collection('personas')
            .doc(user.uid)
            .collection('inr_records')
            .orderBy('createdAt', descending: true)
            .limit(10)
            .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<Map<String, dynamic>> getUserInfo({bool useCache = true}) async {
    // Primero intentamos obtener desde SharedPreferences para carga instantánea
    if (useCache) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final cachedName = prefs.getString('cached_user_name');
        final cachedEmail = prefs.getString('cached_user_email');

        if (cachedName != null && cachedEmail != null) {
          // Actualizar caché en memoria
          _cachedUserData = UserData(
            name: cachedName,
            email: cachedEmail,
            photoUrl: prefs.getString('cached_user_photo'),
            lastFetched: DateTime.now().subtract(
              const Duration(minutes: 25),
            ), // Para forzar actualización pronto
          );

          // Devolvemos datos de caché para mostrar inmediatamente
          final result = {
            'name': cachedName,
            'email': cachedEmail,
            'photoUrl': prefs.getString('cached_user_photo'),
          };

          // Iniciamos actualización en segundo plano
          _refreshUserDataInBackground();

          return result;
        }
      } catch (e) {
        print("Error accediendo a caché local: $e");
      }
    }

    // Si tenemos caché en memoria, lo usamos
    if (useCache && _cachedUserData != null && _cachedUserData!.isCacheValid) {
      // Iniciamos actualización en segundo plano si el caché tiene más de 5 minutos
      if (DateTime.now().difference(_cachedUserData!.lastFetched).inMinutes >
          5) {
        _refreshUserDataInBackground();
      }

      return {
        'name': _cachedUserData!.name,
        'email': _cachedUserData!.email,
        'photoUrl': _cachedUserData!.photoUrl,
      };
    }

    // Si no hay caché o no es válido, hacemos la petición
    return await _fetchUserData();
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user == null) return {'name': 'Usuario', 'email': 'No autenticado'};

    try {
      final userDoc =
          await _firestore.collection('personas').doc(user.uid).get();
      String name = 'Usuario';
      String email = user.email ?? 'No disponible';
      String? photoUrl;

      if (userDoc.exists) {
        final userData = userDoc.data() ?? {};
        name =
            userData['name'] ??
            user.displayName ??
            user.email?.split('@')[0] ??
            'Usuario';
        photoUrl = userData['photoUrl'] ?? user.photoURL;
      } else {
        name = user.displayName ?? user.email?.split('@')[0] ?? 'Usuario';
        photoUrl = user.photoURL;
      }

      // Guardar en SharedPreferences para acceso rápido
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_user_name', name);
      await prefs.setString('cached_user_email', email);
      if (photoUrl != null) {
        await prefs.setString('cached_user_photo', photoUrl);
      }

      // Actualizar caché
      _cachedUserData = UserData(
        name: name,
        email: email,
        photoUrl: photoUrl,
        lastFetched: DateTime.now(),
      );

      return {'name': name, 'email': email, 'photoUrl': photoUrl};
    } catch (e) {
      return {
        'name': 'Usuario',
        'email': 'Error: ${e.toString().substring(0, 20)}...',
      };
    }
  }

  // Método para actualizar en segundo plano sin bloquear la UI
  Future<void> _refreshUserDataInBackground() async {
    try {
      await _fetchUserData();
    } catch (e) {
      print("Error actualizando datos en segundo plano: $e");
    }
  }

  // Método para invalidar el caché cuando se necesite una actualización forzada
  void invalidateCache() {
    _cachedUserData = null;
  }
}
