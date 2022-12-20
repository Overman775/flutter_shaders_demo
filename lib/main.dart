import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final imageData = await rootBundle.load('assets/dash.jpg');
  final image = await decodeImageFromList(imageData.buffer.asUint8List());
  final program = await ui.FragmentProgram.fromAsset('shaders/pixelation.frag');

  runApp(MaterialApp(
      home: ExamplePage(
    image: image,
    program: program,
    bytes: imageData.buffer.asUint8List(),
  )));
}

class ExamplePage extends StatelessWidget {
  final ui.Image image;
  final ui.FragmentProgram program;
  final Uint8List bytes;

  const ExamplePage({
    Key? key,
    required this.image,
    required this.program,
    required this.bytes,
  }) : super(key: key);

  Shader getShader(Rect bounds) {
    final shader = program.fragmentShader();
    shader.setFloat(0, bounds.height);
    shader.setFloat(1, bounds.width);
    shader.setFloat(2, 100);
    shader.setImageSampler(0, image);
    return shader;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shaders demo'),
      ),
      body: Column(
        children: [
          Image.memory(bytes),
          SizedBox(
            height: 200,
            width: 200,
            child: CustomPaint(
              size: const Size(200, 200),
              painter: PixelationPainter(
                  fragment: program, image: image, pixelSize: 10),
            ),
          ),
          SizedBox(
            height: 200,
            width: 200,
            child: ShaderMask(
              blendMode: BlendMode.src,
              shaderCallback: getShader,
              child: Container(
                color: Colors.transparent,
                height: 200,
                width: 200,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PixelationPainter extends CustomPainter {
  final ui.FragmentProgram fragment;
  final double pixelSize;
  final ui.Image image;

  PixelationPainter({
    required this.fragment,
    required this.pixelSize,
    required this.image,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final shader = fragment.fragmentShader();
    shader.setFloat(0, size.height);
    shader.setFloat(1, size.width);
    shader.setFloat(2, pixelSize);
    shader.setImageSampler(0, image);

    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(PixelationPainter oldDelegate) => true;
}
