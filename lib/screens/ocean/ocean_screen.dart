import 'dart:ui';

import 'package:flutter/material.dart';

import 'ocean_painter.dart';

class OceanScreen extends StatelessWidget {
  const OceanScreen({Key? key}) : super(key: key);

  Future<FragmentProgram> _prepareScreen() =>
      FragmentProgram.fromAsset('shaders/ocean.frag');

  @override
  Widget build(BuildContext context) => FutureBuilder<FragmentProgram>(
      future: _prepareScreen(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomPaint(
            size: const Size.fromHeight(300),
            painter: OceanPainter(
              fragment: snapshot.data!,
              time: 0,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString() ?? ''),
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
