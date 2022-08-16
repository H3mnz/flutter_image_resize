import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_resize/services/image_picker_service.dart';
import 'package:flutter_image_resize/utils.dart';

import 'services/image_resizer/image_resizer_service.dart';
import 'services/image_resizer/utils.dart';
import 'widgets/cross_fade_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pure Dart Image Resizer',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;

  Uint8List? pickedBytes;
  Uint8List? resizedBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pure Dart Image Resizer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Card(
          elevation: 1,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Colors.indigo,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Original : "),
                              if (pickedBytes != null) Text(formatBytes(pickedBytes!.length)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: pickedBytes != null ? Center(child: Image.memory(pickedBytes!)) : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [const Text("Resized : "), if (resizedBytes != null) Text(formatBytes(resizedBytes!.length))],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Expanded(
                        child: resizedBytes != null ? Center(child: Image.memory(resizedBytes!)) : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: resizeingImage,
        child: CrossFadeWidget(
          firstChild: const Icon(Icons.add),
          secondChild: const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)),
          crossFadeState: loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ),
      ),
    );
  }

  Future<void> resizeingImage() async {
    pickedBytes = null;
    resizedBytes = null;
    loading = true;
    setState(() {});

    final picked = await ImagePickerService.pick();
    if (picked != null) {
      pickedBytes = picked;
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 1000));
      final resizeOptions = ResizeOptions(encodeFormat: EncodeFormat.jpg, size: 150);
      final resized = await ImageResizerService.resize(picked, resizeOptions);
      if (resized != null) {
        resizedBytes = resized;
      }
    }

    loading = false;
    setState(() {});
  }
}
