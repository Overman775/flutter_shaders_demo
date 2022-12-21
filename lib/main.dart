import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_shaders_demo/screens/example/example_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final program = await FragmentProgram.fromAsset('shaders/ocean.frag');
  runApp(const MaterialApp(home: ExampleScreen()));
}
