import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraRepository {
  const CameraRepository();
  
  Future<bool> isCameraEnabled() async {
    return await Permission.camera.isGranted;
  }

  Future<bool> request() async {
    if (!await isCameraEnabled()) {
      await Permission.camera.request();
    }
    return await isCameraEnabled();
  }

  Future<XFile?> takePhoto() async {
    if (await request()) {
      return await ImagePicker().pickImage(
          source: ImageSource.camera, imageQuality: 65, maxWidth: 1512);
    }

    return null;
  }
}
