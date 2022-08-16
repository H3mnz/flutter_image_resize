import 'dart:developer';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter_image_resize/services/image_resizer/utils.dart';
import 'package:image/image.dart';

void _resizingIsolate(IsolateParams isolateParams) async {
  final src = decodeImage(isolateParams.bytes);

  if (src != null) {
    final image = copyResize(src, width: isolateParams.resizeOptions.size);
    late Uint8List bytes;
    if (isolateParams.resizeOptions.encodeFormat == EncodeFormat.jpg) {
      bytes = Uint8List.fromList(encodeJpg(image));
    } else {
      bytes = Uint8List.fromList(encodePng(image));
    }

    isolateParams.sendPort.send(bytes);
  }
}

class ImageResizerService {
  ImageResizerService._();

  static Future<Uint8List?> resize(Uint8List bytes, ResizeOptions resizeOptions) async {
    try {
      ReceivePort receivePort = ReceivePort();
      IsolateParams isolateParams = IsolateParams(
        bytes: bytes,
        resizeOptions: resizeOptions,
        sendPort: receivePort.sendPort,
      );

      final isolate = await Isolate.spawn(_resizingIsolate, isolateParams);
      final resizedBytes = (await receivePort.first) as Uint8List;
      isolate.kill();
      return resizedBytes;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
