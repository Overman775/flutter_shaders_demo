import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class PixelationData {
  final Uint8List imageBytes;
  final FragmentProgram fragment;
  final Image image;

  const PixelationData({
    required this.imageBytes,
    required this.fragment,
    required this.image,
  });
}
