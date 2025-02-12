import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:samnang_ice_cream_roll/storage/domain/storage_repo.dart';

class FirebaseStrorageRepo implements StorageRepo {
  final FirebaseStorage storage = FirebaseStorage.instance;
  @override
  Future<String?> uploadfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "menu_images");
  }

  @override
  Future<String?> uploadfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "menu_images");
  }

  // Helper Methods - to upload files to Storage

  // mobile platform (file)
  Future<String?> _uploadFile(
      String path, String fileName, String folder) async {
    try {
      // get file
      final file = File(path);

      // find place to Store

      final storageRef = storage.ref().child('$folder/$fileName');

      // upload

      final uploadTask = await storageRef.putFile(file);
      //get image download url

      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
  // web platform (bytes)

  Future<String?> _uploadFileBytes(
      Uint8List fileBytes, String fileName, String folder) async {
    try {
      // find place to Store

      final storageRef = storage.ref().child('$folder/$fileName');

      // upload

      final uploadTask = await storageRef.putData(fileBytes);
      //get image download url

      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
  //
}
