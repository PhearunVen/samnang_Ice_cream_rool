import 'dart:typed_data';

abstract class StorageRepo {
  // upload profile Image on mobile platform
  Future<String?> uploadfileImageMobile(String part, String fileName);
  // upload profile image on web platforms
  Future<String?> uploadfileImageWeb(Uint8List fileBytes, String fileName);
}
