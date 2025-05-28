import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InrService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> saveInr(double value) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print("ERROR: Usuario no autenticado");
        return;
      }

      final now = DateTime.now();

      await _firestore
          .collection('personas')
          .doc(user.uid)
          .collection('inr_records')
          .add({
            'value': value,
            'date':
                '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
            'time':
                '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print("🔥 ERROR al guardar INR: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getInrHistory() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final snapshot =
        await _firestore
            .collection('personas')
            .doc(user.uid)
            .collection('inr_records')
            .orderBy('createdAt', descending: true)
            .limit(10)
            .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
