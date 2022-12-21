import 'dart:ui';

import 'package:flutter/rendering.dart';

class OceanPainter extends CustomPainter {
  final FragmentProgram fragment;
  final double time;

  OceanPainter({
    required this.fragment,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final shader = fragment.fragmentShader();
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, time);
    shader.setFloat(3, 0);
    shader.setFloat(4, 0);

    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(OceanPainter oldDelegate) => false;
}
