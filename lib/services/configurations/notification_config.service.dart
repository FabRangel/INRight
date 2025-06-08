import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class NotificationConfigService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Singleton pattern
  static final NotificationConfigService _instance =
      NotificationConfigService._internal();
  factory NotificationConfigService() => _instance;
  NotificationConfigService._internal();

  // Obtener la configuración de notificaciones actual del usuario
  Future<Map<String, dynamic>?> getNotificationConfig() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return null;

      final docSnapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('settings')
              .doc('notifications')
              .get();

      // Si el documento no existe, retornar un mapa vacío en lugar de null
      if (!docSnapshot.exists) {
        return {};
      }

      return docSnapshot.data();
    } catch (e) {
      debugPrint('Error al obtener configuración de notificaciones: $e');
      return null;
    }
  }

  // Guardar la configuración de notificaciones del usuario
  Future<void> saveNotificationConfig(Map<String, dynamic> config) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('Usuario no autenticado');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('notifications')
          .set(config, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error al guardar configuración de notificaciones: $e');
      throw Exception('No se pudieron guardar las configuraciones: $e');
    }
  }
}
