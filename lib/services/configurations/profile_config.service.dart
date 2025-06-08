import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileConfigService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Singleton pattern
  static final ProfileConfigService _instance =
      ProfileConfigService._internal();
  factory ProfileConfigService() => _instance;
  ProfileConfigService._internal();

  Future<void> saveProfileConfig(Map<String, dynamic> data) async {
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
          .doc('profile')
          .set({
            'peso': data['peso'],
            'altura': data['altura'],
            'grupoSanguineo': data['grupoSanguineo'],
            'condicionesMedicas': data['condicionesMedicas'],
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      print("🔥 ERROR al guardar configuración de perfil: $e");
      throw e;
    }
  }

  Future<Map<String, dynamic>?> getProfileConfig() async {
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
              .doc('profile')
              .get();

      if (!doc.exists) {
        return null;
      }

      return doc.data();
    } catch (e) {
      print("🔥 ERROR al obtener configuración de perfil: $e");
      return null;
    }
  }
}
