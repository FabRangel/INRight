import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationConfigService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Singleton pattern
  static final NotificationConfigService _instance =
      NotificationConfigService._internal();
  factory NotificationConfigService() => _instance;
  NotificationConfigService._internal();

  Future<void> saveNotificationConfig(Map<String, dynamic> data) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print("ERROR: Usuario no autenticado");
        return;
      }

      await _firestore
          .collection('personas')
          .doc(user.uid)
          .collection('configs')
          .doc('notifications')
          .set({
            'alertaINR': data['alertaINR'],
            'recordatorioMed': data['recordatorioMed'],
            'valoresCriticos': data['valoresCriticos'],
            'notificacionesPush': data['notificacionesPush'],
            'correoElectronico': data['correoElectronico'],
            'sonido': data['sonido'],
            'vibracion': data['vibracion'],
            'horaNotificacion': data['horaNotificacion'],
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      print("🔥 ERROR al guardar configuración de notificaciones: $e");
      throw e;
    }
  }

  Future<Map<String, dynamic>?> getNotificationConfig() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print("ERROR: Usuario no autenticado");
        return null;
      }

      final doc =
          await _firestore
              .collection('personas')
              .doc(user.uid)
              .collection('configs')
              .doc('notifications')
              .get();

      if (!doc.exists) {
        return null;
      }

      return doc.data();
    } catch (e) {
      print("🔥 ERROR al obtener configuración de notificaciones: $e");
      return null;
    }
  }
}
