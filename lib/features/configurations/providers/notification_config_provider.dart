import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inright/services/configurations/notification_config.service.dart';
import 'package:inright/services/notifications/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationConfigProvider with ChangeNotifier {
  final NotificationConfigService _notificationConfigService =
      NotificationConfigService();

  bool _alertaInr = true;
  bool _recordatorioMed = true;
  bool _valoresCriticos = true;
  bool _push = true;
  bool _email = false;
  String _horaNotificacion = "08:00";
  bool _sonido = true;
  bool _vibracion = true;
  bool _isLoading = false;
  String _userEmail = '';

  bool get alertaInr => _alertaInr;
  bool get recordatorioMed => _recordatorioMed;
  bool get valoresCriticos => _valoresCriticos;
  bool get push => _push;
  bool get email => _email;
  String get horaNotificacion => _horaNotificacion;
  bool get sonido => _sonido;
  bool get vibracion => _vibracion;
  bool get isLoading => _isLoading;
  String get userEmail => _userEmail;

  NotificationConfigProvider() {
    loadNotificationConfig();
  }

  // Método para forzar una recarga de las configuraciones
  void forceRefresh() {
    loadNotificationConfig();
  }

  Future<void> loadNotificationConfig() async {
    _isLoading = true;
    notifyListeners();

    try {
      final config = await _notificationConfigService.getNotificationConfig();
      // Corregir acceso a un mapa potencialmente nulo usando el operador ?.
      _alertaInr = config?['alertaInr'] ?? true;
      _recordatorioMed = config?['recordatorioMed'] ?? true;
      _valoresCriticos = config?['valoresCriticos'] ?? true;
      _push = config?['push'] ?? true;
      _email = config?['email'] ?? false;
      _horaNotificacion = config?['horaNotificacion'] ?? "08:00";
      _sonido = config?['sonido'] ?? true;
      _vibracion = config?['vibracion'] ?? true;
      _userEmail = config?['userEmail'] ?? '';

      // Guardar la configuración en SharedPreferences para que la use el NotificationService
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('alertaInr', _alertaInr);
      await prefs.setBool('recordatorioMed', _recordatorioMed);
      await prefs.setBool('valoresCriticos', _valoresCriticos);
      await prefs.setBool('push', _push);
      await prefs.setBool('email', _email);
      await prefs.setBool('sonido', _sonido);
      await prefs.setBool('vibracion', _vibracion);
    } catch (e) {
      debugPrint('Error al cargar configuración de notificaciones: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveNotificationConfig() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _notificationConfigService.saveNotificationConfig({
        'alertaInr': _alertaInr,
        'recordatorioMed': _recordatorioMed,
        'valoresCriticos': _valoresCriticos,
        'push': _push,
        'email': _email,
        'horaNotificacion': _horaNotificacion,
        'sonido': _sonido,
        'vibracion': _vibracion,
        'userEmail': _userEmail,
      });

      // Actualizar SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('alertaInr', _alertaInr);
      await prefs.setBool('recordatorioMed', _recordatorioMed);
      await prefs.setBool('valoresCriticos', _valoresCriticos);
      await prefs.setBool('push', _push);
      await prefs.setBool('email', _email);
      await prefs.setBool('sonido', _sonido);
      await prefs.setBool('vibracion', _vibracion);
      await prefs.setString('horaNotificacion', _horaNotificacion);
      await prefs.setString('userEmail', _userEmail);

      // Update medication reminder schedule based on new settings
      await NotificationService.updateMedicationReminderSettings();
    } catch (e) {
      debugPrint('Error al guardar configuración de notificaciones: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setAlertaInr(bool value) {
    _alertaInr = value;
    notifyListeners();
  }

  void setRecordatorioMed(bool value) {
    _recordatorioMed = value;
    notifyListeners();
    // Update medication reminder schedule when this setting changes
    NotificationService.updateMedicationReminderSettings();
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

  void setHoraNotificacion(String value) {
    _horaNotificacion = value;
    notifyListeners();
    // Update medication reminder schedule when notification time changes
    NotificationService.updateMedicationReminderSettings();
  }

  void setSonido(bool value) {
    _sonido = value;
    notifyListeners();
  }

  void setVibracion(bool value) {
    _vibracion = value;
    notifyListeners();
  }

  void setUserEmail(String email) {
    _userEmail = email;
    notifyListeners();
  }

  // Método para probar notificaciones según tipo
  Future<void> testNotification(
    BuildContext context,
    NotificationType type,
  ) async {
    await NotificationService.testNotification(context, _userEmail, type);
  }

  void clearNotificationConfig() {
    _alertaInr = true;
    _recordatorioMed = true;
    _valoresCriticos = true;
    _push = true;
    _email = false;
    _horaNotificacion = "08:00";
    _sonido = true;
    _vibracion = true;
    _userEmail = '';
    _isLoading = false;
    notifyListeners();
  }
}
