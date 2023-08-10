import 'dart:collection';

import 'package:fade_out_particle/utils/render_box.dart';

import '/models/particle.dart';
import 'package:flutter/widgets.dart';

@immutable
class RenderObjectParticle extends SingleChildRenderObjectWidget {
  final double progress;
  final LinkedList<Particle>? particles;
  final int particleMaxRadius;

  const RenderObjectParticle({
    required this.progress,
    required this.particles,
    required this.particleMaxRadius,
    super.child,
  });

  @override
  RenderBoxParticle createRenderObject(BuildContext context) =>
      RenderBoxParticle(progress, particles, particleMaxRadius);

  @override
  void updateRenderObject(BuildContext context, RenderBoxParticle renderBox) {
    renderBox.progress = progress;
    renderBox.particles = particles;
  }
}
