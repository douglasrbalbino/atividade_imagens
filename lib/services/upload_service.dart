// lib/services/upload_service.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(XFile image) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileExtension = image.path.split('.').last;

    final fileName = 'imagens_atividade/$timestamp.$fileExtension';

    final storageRef = _storage.ref().child(fileName);

    final uploadTask = storageRef.putFile(File(image.path));

    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
