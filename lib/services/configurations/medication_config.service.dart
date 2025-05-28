import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inright/features/configurations/providers/medication_config_provider.dart';

class MedicationConfigService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Singleton pattern
  static final MedicationConfigService _instance =
      MedicationConfigService._internal();
  factory MedicationConfigService() => _instance;
  MedicationConfigService._internal();

  Future<void> saveMedicationConfig(Map<String, dynamic> data) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return;
      }

      await _firestore
          .collection('personas')
          .doc(user.uid)
          .collection('configs')
          .doc('medication')
          .set({
            'anticoagulante': data['anticoagulante'],
            'dosis': data['dosis'],
            'esquemas': data['esquemas'],
            'inrRange': {
              'start': data['inrRange']['start'],
              'end': data['inrRange']['end'],
            },
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      print("🔥 ERROR al guardar configuración de medicación: $e");
      throw e;
    }
  }

  Future<Map<String, dynamic>?> getMedicationConfig() async {
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
              .doc('medication')
              .get();

      if (!doc.exists) {
        return null;
      }
      return doc.data();
    } catch (e) {
      print("🔥 ERROR al obtener configuración de medicación: $e");
      return null;
    }
  }

  Future<void> loadMedicationConfig(MedicationConfigProvider provider) async {
    try {
      final config = await getMedicationConfig();

      if (config == null) {
        return;
      }

      // Actualizar anticoagulante
      if (config['anticoagulante'] != null) {
        provider.updateAnticoagulante(config['anticoagulante']);
      }

      // Actualizar dosis
      if (config['dosis'] != null) {
        provider.updateDosis(config['dosis']);
      }

      // Actualizar rango INR
      if (config['inrRange'] != null) {
        final start = config['inrRange']['start'] ?? 2.0;
        final end = config['inrRange']['end'] ?? 3.0;
        provider.updateInrRange(RangeValues(start, end));
      }

      // Actualizar esquemas
      if (config['esquemas'] != null &&
          config['esquemas'] is List &&
          (config['esquemas'] as List).isNotEmpty) {
        List<dynamic> esquemasList = config['esquemas'];
        List<MedicationSchema> esquemas = [];

        for (var esquema in esquemasList) {
          try {
            esquemas.add(
              MedicationSchema.fromMap(Map<String, dynamic>.from(esquema)),
            );
          } catch (e) {
            print("Error al procesar esquema: $e");
          }
        }

        if (esquemas.isNotEmpty) {
          provider.updateEsquemas(esquemas);
        }
      }
    } catch (e) {
      print("🔥 ERROR al cargar configuración de medicación: $e");
      // En caso de error, mantenemos los valores predeterminados
    }
  }
}
