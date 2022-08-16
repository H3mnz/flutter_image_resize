import 'dart:isolate';
import 'dart:typed_data';

enum EncodeFormat { jpg, png }

class ResizeOptions {
  final int size;
  final EncodeFormat encodeFormat;
  ResizeOptions({required this.size, required this.encodeFormat});
}

class IsolateParams {
  final Uint8List bytes;
  final ResizeOptions resizeOptions;
  final SendPort sendPort;
  IsolateParams({required this.bytes, required this.resizeOptions, required this.sendPort});
}
