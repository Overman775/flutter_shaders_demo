import 'dart:ui';

import 'package:flutter/material.dart';

import 'ocean_animation.dart';

class OceanScreen extends StatelessWidget {
  const OceanScreen({Key? key}) : super(key: key);

  Future<FragmentProgram> _prepareScreen() =>
      FragmentProgram.fromAsset('shaders/ocean.frag');

  @override
  Widget build(BuildContext context) => FutureBuilder<FragmentProgram>(
      future: _prepareScreen(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return LayoutBuilder(
              builder: (context, constrains) => OceanAnimation(
                    fragment: snapshot.data!,
                    size: Size(constrains.maxWidth, constrains.maxHeight),
                  ));
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
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
