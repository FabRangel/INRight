import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inright/services/notifications/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InrService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para guardar un nuevo valor de INR y verificar si está fuera de rango
  Future<void> saveInrValue(BuildContext context, double inrValue) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    // Obtener el correo del usuario
    String userEmail = user.email ?? '';

    // Obtener el rango objetivo de INR desde las preferencias
    final prefs = await SharedPreferences.getInstance();
    double minRange = prefs.getDouble('inrRangeMin') ?? 2.0;
    double maxRange = prefs.getDouble('inrRangeMax') ?? 3.5;

    // Guardar el valor en Firestore
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('inr_records')
          .add({
            'value': inrValue,
            'date': Timestamp.now(),
            'inRangeMin': minRange,
            'inRangeMax': maxRange,
            'isInRange': inrValue >= minRange && inrValue <= maxRange,
          });

      // Verificar si el valor está dentro del rango y enviar notificación si es necesario
      await NotificationService.checkInrValueAndNotify(
        context,
        userEmail,
        inrValue,
        minRange,
        maxRange,
      );
    } catch (e) {
      throw Exception('Error al guardar el valor de INR: $e');
    }
  }

  // Obtener el rango de INR actual desde Firebase o preferencias
  Future<Map<String, double>> getCurrentInrRange() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    try {
      // Primero intentamos obtener de Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists && userDoc.data()!.containsKey('inrRange')) {
        final rangeData = userDoc.data()!['inrRange'] as Map<String, dynamic>;
        return {
          'min': rangeData['min'] as double,
          'max': rangeData['max'] as double,
        };
      } else {
        // Si no está en Firestore, intentamos obtener de SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        return {
          'min': prefs.getDouble('inrRangeMin') ?? 2.0,
          'max': prefs.getDouble('inrRangeMax') ?? 3.5,
        };
      }
    } catch (e) {
      // En caso de error, devolvemos valores predeterminados
      return {'min': 2.0, 'max': 3.5};
    }
  }
}
