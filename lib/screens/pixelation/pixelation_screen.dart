import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/pixelation_data.dart';
import 'pixelation_painter.dart';

class PixelationScreen extends StatelessWidget {
  const PixelationScreen({Key? key}) : super(key: key);

  Future<PixelationData> _prepareScreen() async {
    final imageData = await rootBundle.load('assets/dash.jpg');
    final fragment =
        await ui.FragmentProgram.fromAsset('shaders/pixelation.frag');
    final image = await decodeImageFromList(imageData.buffer.asUint8List());

    return PixelationData(
      imageBytes: imageData.buffer.asUint8List(),
      fragment: fragment,
      image: image,
    );
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<PixelationData>(
      future: _prepareScreen(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Image.memory(snapshot.data!.imageBytes),
              CustomPaint(
                size: const Size.fromHeight(300),
                painter: PixelationPainter(
                  fragment: snapshot.data!.fragment,
                  image: snapshot.data!.image,
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        } else {
          return const Center(
            child: SizedBox.square(
              dimension: 60,
              child: CircularProgressIndicator(),
            ),
          );
        }
      });
}
