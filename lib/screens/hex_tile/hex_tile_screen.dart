import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class HexTileScreen extends StatefulWidget {
  const HexTileScreen({Key? key}) : super(key: key);

  @override
  State<HexTileScreen> createState() => _HexTileScreenState();
}

class _HexTileScreenState extends State<HexTileScreen> {
  double tileValue = 50;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: ShaderBuilder(
              (BuildContext context, ui.FragmentShader shader, Widget? child) {
                return AnimatedSampler(
                  (ui.Image image, Size size, Offset offset, Canvas canvas) {
                    shader
                      ..setFloat(0, size.width)
                      ..setFloat(1, size.height)
                      ..setFloat(2, tileValue)
                      ..setImageSampler(0, image);
                    canvas.drawRect(
                        Rect.fromLTWH(0, 0, size.width, size.height),
                        Paint()..shader = shader);
                  },
                  child: child ?? const SizedBox.shrink(),
                );
              },
              assetKey: 'shaders/hex_tile.frag',
              child: Image.asset(
                'assets/dash.jpg',
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: Slider(
              value: tileValue,
              max: 100,
              label: (tileValue).round().toString(),
              onChanged: (value) => setState(() {
                tileValue = value;
              }),
            ),
          )
        ],
      );
}
