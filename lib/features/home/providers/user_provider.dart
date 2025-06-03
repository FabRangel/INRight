import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inright/services/home/user.service.dart';
import 'package:inright/services/auth/firebaseAuth.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();
  final FirebaseAuthService _authService = FirebaseAuthService();
  String? _photoUrl; // ya lo tienes
  String get userProfilePhotoUrl => _photoUrl ?? '';

  String _userName = 'Usuario';
  String _userEmail = 'No autenticado';
  bool _isLoading = true;
  bool _isAuthenticated = false;
  bool _disposed = false;
  bool _isLoadingData = false;

  String get userName => _userName;
  String get userEmail => _userEmail;
  String? get photoUrl => _photoUrl;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  UserProvider() {
    _initUser();
  }

  // Inicialización inmediata mejorada para evitar notificaciones innecesarias
  Future<void> _initUser() async {
    try {
      if (_authService.isAuthenticated) {
        // No notificar al inicio, solo al final
        _isLoading = true;

        final userInfo = await _userService.getUserInfo();
        _userName = userInfo['name'] as String;
        _userEmail = userInfo['email'] as String;
        _photoUrl = userInfo['photoUrl'] as String?;
        _isAuthenticated = true;

        _isLoading = false;

        // Notificar solo una vez con todos los datos cargados
        if (!_disposed) notifyListeners();
      } else {
        _isLoading = false;
        _isAuthenticated = false;
        if (!_disposed) notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> loadUserData({bool forceRefresh = false}) async {
    // Evitar múltiples cargas simultáneas
    if (_isLoadingData) return;
    _isLoadingData = true;

    // Marcar como cargando pero NO notificar durante build
    _isLoading = true;

    // Usamos addPostFrameCallback para asegurar que no notificamos durante build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_disposed) {
        notifyListeners();
      }
    });

    try {
      // Verificar autenticación directamente desde Firebase
      final currentUser = _authService.currentUser;
      _isAuthenticated = currentUser != null;

      if (_isAuthenticated) {
        // Si se solicita actualización forzada, invalidar caché
        if (forceRefresh) {
          _userService.invalidateCache();
        }

        final userInfo = await _userService.getUserInfo();
        _userName = userInfo['name'] as String;
        _userEmail = userInfo['email'] as String;
        _photoUrl = userInfo['photoUrl'] as String?;

        // Guardar en preferencias para acceso rápido
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cached_user_name', _userName);
        await prefs.setString('cached_user_email', _userEmail);
        if (_photoUrl != null) {
          await prefs.setString('cached_user_photo', _photoUrl!);
        }
      } else {
        _userName = 'Usuario';
        _userEmail = 'No autenticado';
      }
    } catch (e) {
      print("Error cargando datos de usuario: $e");

      // Intentar recuperar de caché local en caso de error
      try {
        final prefs = await SharedPreferences.getInstance();
        _userName = prefs.getString('cached_user_name') ?? 'Usuario';
        _userEmail = prefs.getString('cached_user_email') ?? 'Error de carga';
        _photoUrl = prefs.getString('cached_user_photo');
      } catch (_) {
        _userName = 'Usuario';
        _userEmail = 'Error de carga';
      }

      _isAuthenticated = _authService.isAuthenticated;
    } finally {
      _isLoading = false;
      _isLoadingData = false;

      // Usar addPostFrameCallback para notificar de forma segura
      if (!_disposed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_disposed) {
            notifyListeners();
          }
        });
      }
    }
  }

  // Para forzar una actualización después de login o actualización de perfil
  Future<void> refreshUserData() async {
    _userService.invalidateCache();
    await loadUserData(forceRefresh: true);
  }

  // Método mejorado para verificar el estado de autenticación actual
  Future<bool> checkAuthStatus() async {
    try {
      final isAuth = await _authService.verifyAuthStatus();
      _isAuthenticated = isAuth;

      if (_isAuthenticated &&
          (_userName == 'Usuario' || _userEmail == 'No autenticado')) {
        // Si está autenticado pero no tenemos los datos del usuario, los cargamos
        await loadUserData();
      }

      notifyListeners();
      return _isAuthenticated;
    } catch (e) {
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

  // Método seguro para actualización silenciosa sin notificar
  Future<void> silentSignOut() async {
    _userName = 'Usuario';
    _userEmail = 'No autenticado';
    _photoUrl = null;
    _isAuthenticated = false;
    _userService.invalidateCache();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_user_name');
    await prefs.remove('cached_user_email');
    await prefs.remove('cached_user_photo');
    await prefs.setBool('is_logged_in', false);

    // Solo notificar si es seguro
    if (!_disposed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_disposed) notifyListeners();
      });
    }
  }

  // Versión mejorada del método signOut
  Future<void> signOut() async {
    _isLoading = true;

    // Solo notificar si es seguro
    if (!_disposed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_disposed) notifyListeners();
      });
    }

    try {
      // Limpiar datos locales
      _userName = 'Usuario';
      _userEmail = 'No autenticado';
      _photoUrl = null;
      _isAuthenticated = false;

      // Invalidar caché
      _userService.invalidateCache();

      // Cerrar sesión en Firebase
      await _authService.signOut();

      // Limpiar preferencias
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cached_user_name');
      await prefs.remove('cached_user_email');
      await prefs.remove('cached_user_photo');
      await prefs.setBool('is_logged_in', false);
    } catch (e) {
      print("Error en UserProvider.signOut: $e");
    } finally {
      _isLoading = false;

      // Solo notificar si es seguro
      if (!_disposed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_disposed) notifyListeners();
        });
      }
    }
  }

  Future<void> updateProfilePhoto(String imageUrl) async {
    try {
      _photoUrl = imageUrl;

      // Actualiza en Firebase (debes implementarlo en UserService)
      await _userService.updateUserPhoto(imageUrl);

      // Guarda en caché local
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_user_photo', imageUrl);
      final userId = _authService.currentUser?.uid;

      if (userId != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).update(
          {'photoUrl': imageUrl},
        );
      }

      // Guardar en preferencias locales
      await prefs.setString('cached_user_photo', imageUrl);

      notifyListeners();

      if (!_disposed) notifyListeners();
    } catch (e) {
      print("❌ Error al actualizar la foto de perfil: $e");
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
