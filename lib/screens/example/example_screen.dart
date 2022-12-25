import 'package:flutter/material.dart';
import 'package:flutter_shaders_demo/screens/hex_tile/hex_tile_screen.dart';

import '../ocean/ocean_screen.dart';
import '../pixelation/pixelation_screen.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  int screenIndex = 0;
  final List<Widget> screens = [
    const HexTileScreen(),
    const OceanScreen(),
    const PixelationScreen()
  ];

  void _nextScreen() {
    var nextIndex = screenIndex + 1;
    if (nextIndex >= screens.length) {
      nextIndex = 0;
    }

    setState(() {
      screenIndex = nextIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shaders demo'),
      ),
      body: screens[screenIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _nextScreen,
        child: const Icon(Icons.navigate_next),
      ),
    );
  }
}
