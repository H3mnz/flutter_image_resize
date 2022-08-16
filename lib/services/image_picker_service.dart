import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class ImagePickerService {
  ImagePickerService._();
  //
  static Future<Uint8List?> pick() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        final bytes = await File(result.files.first.path!).readAsBytes();

        return bytes;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
