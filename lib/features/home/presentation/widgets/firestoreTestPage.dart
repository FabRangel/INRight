import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class FirestoreTestPage extends StatelessWidget {
  const FirestoreTestPage({super.key});

  Future<void> leerProducto() async {
    final docRef = FirebaseFirestore.instance.collection('productos').doc('producto1');

    try {
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        print('Producto leído: ${data?['nombre']} - \$${data?['precio']}');
      } else {
        print('El documento no existe.');
      }
    } catch (e) {
      print('Error al leer el documento: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba Firebase')),
      body: Center(
        child: ElevatedButton(
          onPressed: leerProducto,
          child: const Text('Leer Producto'),
        ),
      ),
    );
  }
}
