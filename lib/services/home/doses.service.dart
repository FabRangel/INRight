import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DosisService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> saveDoses({
    required double dosis,
    required String hora,
    required String medicamento,
    required String estado,
    required DateTime fecha,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('personas')
        .doc(user.uid)
        .collection('dosis')
        .add({
          'dosis': dosis,
          'hora': hora,
          'medicamento': medicamento,
          'estado': estado,
          'fecha': '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}',
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  Future<List<Map<String, dynamic>>> getDosesHistory() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final snapshot = await _firestore
        .collection('personas')
        .doc(user.uid)
        .collection('dosis')
        .orderBy('fecha', descending: true)
        .limit(10)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
