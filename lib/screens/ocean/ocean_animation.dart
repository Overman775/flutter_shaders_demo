import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'ocean_painter.dart';

class OceanAnimation extends StatefulWidget {
  final FragmentProgram fragment;
  final Size size;

  const OceanAnimation({
    Key? key,
    required this.fragment,
    required this.size,
  }) : super(key: key);

  @override
  State<OceanAnimation> createState() => _OceanAnimationState();
}

class _OceanAnimationState extends State<OceanAnimation> {
  late final Timer timer;

  double delta = 0;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        delta += 1 / 60;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: widget.size,
        painter: OceanPainter(
          fragment: widget.fragment,
          time: delta,
        ),
      );
}
