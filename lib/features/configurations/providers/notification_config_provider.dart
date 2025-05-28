import 'package:flutter/material.dart';
import 'package:inright/services/configurations/notification_config.service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationConfigProvider with ChangeNotifier {
  // Singleton pattern para la service
  final _notificationService = NotificationConfigService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _currentUserId;

  bool _alertaInr = true;
  bool _recordatorioMed = true;
  bool _valoresCriticos = true;
  bool _push = true;
  bool _email = false;
  bool _sonido = true;
  bool _vibracion = true;
  String _horaNotificacion = "08:00";
  bool _isLoading = false;

  // Getters
  bool get alertaInr => _alertaInr;
  bool get recordatorioMed => _recordatorioMed;
  bool get valoresCriticos => _valoresCriticos;
  bool get push => _push;
  bool get email => _email;
  bool get sonido => _sonido;
  bool get vibracion => _vibracion;
  String get horaNotificacion => _horaNotificacion;
  bool get isLoading => _isLoading;

  NotificationConfigProvider() {
    // Escuchar cambios en la autenticación
    _auth.authStateChanges().listen((User? user) {
      if (user != null && user.uid != _currentUserId) {
        _currentUserId = user.uid;
        loadNotificationConfig();
      } else if (user == null) {
        _currentUserId = null;
        _resetToDefaults();
      }
    });

    // Cargar la configuración inicial si ya hay usuario autenticado
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _currentUserId = currentUser.uid;
      loadNotificationConfig();
    }
  }

  void _resetToDefaults() {
    _alertaInr = true;
    _recordatorioMed = true;
    _valoresCriticos = true;
    _push = true;
    _email = false;
    _sonido = true;
    _vibracion = true;
    _horaNotificacion = "08:00";
    notifyListeners();
  }

  // Setters with notifications
  void setAlertaInr(bool value) {
    _alertaInr = value;
    notifyListeners();
  }

  void setRecordatorioMed(bool value) {
    _recordatorioMed = value;
    notifyListeners();
  }

  void setValoresCriticos(bool value) {
    _valoresCriticos = value;
    notifyListeners();
  }

  void setPush(bool value) {
    _push = value;
    notifyListeners();
  }

  void setEmail(bool value) {
    _email = value;
    notifyListeners();
  }

  void setSonido(bool value) {
    _sonido = value;
    notifyListeners();
  }

  void setVibracion(bool value) {
    _vibracion = value;
    notifyListeners();
  }

  void setHoraNotificacion(String value) {
    _horaNotificacion = value;
    notifyListeners();
  }

  Map<String, dynamic> getAllNotificationData() {
    return {
      'alertaINR': _alertaInr,
      'recordatorioMed': _recordatorioMed,
      'valoresCriticos': _valoresCriticos,
      'notificacionesPush': _push,
      'correoElectronico': _email,
      'sonido': _sonido,
      'vibracion': _vibracion,
      'horaNotificacion': _horaNotificacion,
    };
  }

  Future<void> saveNotificationConfig() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _notificationService.saveNotificationConfig(
        getAllNotificationData(),
      );
    } catch (e) {
      print("Error guardando configuración de notificaciones: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNotificationConfig() async {
    if (_auth.currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final config = await _notificationService.getNotificationConfig();

      if (config != null) {
        _alertaInr = config['alertaINR'] ?? true;
        _recordatorioMed = config['recordatorioMed'] ?? true;
        _valoresCriticos = config['valoresCriticos'] ?? true;
        _push = config['notificacionesPush'] ?? true;
        _email = config['correoElectronico'] ?? false;
        _sonido = config['sonido'] ?? true;
        _vibracion = config['vibracion'] ?? true;
        _horaNotificacion = config['horaNotificacion'] ?? "08:00";
      }
    } catch (e) {
      print("🔥 Error cargando configuración de notificaciones: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> forceRefresh() async {
    if (_auth.currentUser != null && _currentUserId == _auth.currentUser!.uid) {
      await loadNotificationConfig();
    }
  }
}
