import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InrService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Save a single INR value
  Future<void> saveInr(double valor) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    // Get current date and time
    final now = DateTime.now();
    final dateStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    // Save to Firestore
    await FirebaseFirestore.instance
        .collection('personas')
        .doc(user.uid)
        .collection('inr_records')
        .add({
          'value': valor,
          'date': dateStr,
          'time': timeStr,
          'timestamp': FieldValue.serverTimestamp(),
        });

    debugPrint("INR value saved: $valor on $dateStr at $timeStr");
  }

  // Get INR history
  Future<List<Map<String, dynamic>>> getInrHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    // Get data from Firestore ordered by timestamp descending (newest first)
    final snapshot =
        await FirebaseFirestore.instance
            .collection('personas')
            .doc(user.uid)
            .collection('inr_records')
            .orderBy('timestamp', descending: true)
            .get();

    // Convert snapshot to List of Maps
    final result =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'value': data['value'] as double?,
            'date': data['date'] as String?,
            'time': data['time'] as String?,
          };
        }).toList();

    debugPrint("Retrieved ${result.length} INR records");
    return result;
  }

  Future<void> deleteInr(String id) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print("ERROR: Usuario no autenticado");
        return;
      }

      await _firestore
          .collection('personas')
          .doc(user.uid)
          .collection('inr_records')
          .doc(id)
          .delete();

      print("✅ Registro INR eliminado: $id");
    } catch (e) {
      print("🔥 ERROR al eliminar INR: $e");
    }
  }

  Future<void> updateInr(String id, double valor) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final formattedTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    await FirebaseFirestore.instance
        .collection('personas')
        .doc(user.uid)
        .collection('inr_records')
        .doc(id)
        .update({
          'value': valor,
          'date': formattedDate,
          'time': formattedTime,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }
}
