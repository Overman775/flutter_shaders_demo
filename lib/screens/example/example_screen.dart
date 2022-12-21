import 'package:flutter/material.dart';

import '../pixelation/pixelation_screen.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final int screenIndex = 0;
  final List<Widget> screens = [const PixelationScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shaders demo'),
      ),
      body: screens[screenIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
