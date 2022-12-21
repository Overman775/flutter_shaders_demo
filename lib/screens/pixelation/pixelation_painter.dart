import 'dart:ui';

import 'package:flutter/rendering.dart';

class PixelationPainter extends CustomPainter {
  final FragmentProgram fragment;
  final Image image;

  PixelationPainter({
    required this.fragment,
    required this.image,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final shader = fragment.fragmentShader();
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setImageSampler(0, image);

    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(PixelationPainter oldDelegate) => false;
}
