import 'dart:ui';

import 'package:flutter/material.dart';

class ShaderWidget extends StatelessWidget {
  const ShaderWidget({
    super.key,
    this.blendMode = BlendMode.src,
    required this.program,
    this.child,
  });

  /// The blend mode to use when applying the shader mask.
  final BlendMode blendMode;

  /// The optional child widget to apply the shader mask to.
  final Widget? child;

  final Future<FragmentProgram> program;

  /// A builder that specifies the widget to display to the user while a
  /// shader is still compiling.
  // final ShaderCompilingBuilder? compilingBuilder;

  Shader getShader(Rect bounds, FragmentProgram program) {
    final shader = program.fragmentShader();
    return shader;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FragmentProgram>(
      future: program,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // if (compilingBuilder != null) {
          //   return compilingBuilder!(context, child);
          // }
          return child ?? const SizedBox();
        }
        final program = snapshot.data!;

        return LayoutBuilder(
          builder: (context, constraints) {
            return ShaderMask(
              blendMode: blendMode,
              // shaderCallback: (bounds) {
              //   return program.shader(
              //     floatUniforms: Float32List.fromList(
              //       getFloatUniforms()
              //         ..addAll([bounds.size.width, bounds.size.height]),
              //     ),
              //     samplerUniforms: getSamplerUniforms(),
              //   );
              // },
              shaderCallback: (bounds) => getShader(bounds, program),
              child: Container(
                color: Colors.transparent,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}
