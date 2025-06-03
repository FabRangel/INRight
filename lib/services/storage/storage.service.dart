import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  /// Devuelve la URL si va bien, o ⁠ null ⁠ si hay error.
  static Future<String?> uploadProfileImage(File file) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('⚠️ uploadProfileImage: No hay usuario logueado.');
      return null;
    }

    final uid = user.uid;
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child(uid); // sin .jpg

    // 👉 Asegúrate de imprimir FULLPATH
    print('🔍 [StorageService] UID actual: $uid');
    print('🔍 [StorageService] Ruta completa (ref.fullPath): ${ref.fullPath}');
    // Por ejemplo deberías ver: profile_images/FPHkzhiiYgeo1KA9FVnpIyNvik1.jpg

    try {
      await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
      final url = await ref.getDownloadURL();
      print('✔ [StorageService] Subida terminada. URL: $url');
      print('📛 Comparando UID "${user.uid}" con ref.name: "${ref.name}"');
      return url;
    } on FirebaseException catch (e) {
      print('❌ [StorageService] Error (${e.code}): ${e.message}');
      return null;
    }
  }
}
