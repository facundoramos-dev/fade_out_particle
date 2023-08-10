import 'dart:collection';
import 'dart:math' as math;
import 'dart:ui' as ui;

import '/models/particle.dart';
import '../extensions/extensions.dart';
import 'package:flutter/rendering.dart';

class RenderBoxParticle extends RenderProxyBox {
  double _progress;
  LinkedList<Particle>? _particles;
  int _particleMaxRadius;

  RenderBoxParticle(this._progress, this._particles, this._particleMaxRadius);

  @override
  bool get alwaysNeedsCompositing => child != null;

  set progress(double newValue) {
    if (newValue == _progress) return;
    _progress = newValue;
    markNeedsPaint();
  }

  set particles(LinkedList<Particle>? newValue) {
    if (newValue == _particles) return;
    _particles = newValue;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = this.child;
    if (child == null || _progress == 0) {
      super.paint(context, offset);
      return;
    }
    final double width = child.size.width;
    final double height = child.size.height;
    final Canvas canvas = context.canvas;

    final Rect bounds = Rect.fromLTRB(0, 0, width + 1, height + 1);
    final Paint paint = Paint();

    canvas.saveLayer(bounds, paint);

    super.paint(context, offset);

    paint.blendMode = BlendMode.dstOut;
    final double limit =
        width - width * (1 + width.limitedAnimationWidth / width) * _progress;
    final double fadingLimit = math.min(width / 3, 10);
    final Rect clipRect = Rect.fromLTRB(limit, -1.0, width + 1, height + 1);

    paint.shader = ui.Gradient.linear(
        Offset(limit, height / 2),
        Offset(limit + fadingLimit, height / 2),
        [const Color(0), const Color(-1)]);

    canvas.drawRect(clipRect, paint);

    canvas.restore();

    paint.shader = null;
    paint.blendMode = BlendMode.srcOver;

    if (_particles != null) {
      _drawParticles(_particles!, limit, width, paint, canvas);
    }
  }

  void _drawParticles(LinkedList<Particle> particles, double limit,
      double width, Paint paint, Canvas canvas) {
    for (final Particle particle in particles) {
      if (particle.cx < limit - 1) continue;
      final double particleProgress =
          (particle.cx - limit).particleProgress(width);
      if (particleProgress == 1) continue;
      paint.color = particle.rgbaColor.withOpacity(1 - particleProgress);
      if (paint.color.opacity == 0) continue;
      final double cx =
          (1 + _particleMaxRadius - particle.radius) / _particleMaxRadius;
      final int cy = (particle.cx + particle.cy * 3) % 2 - 1;
      final double dx = particle.cx + particleProgress * particle.endX * cx;
      final double dy = particle.cy +
          particleProgress.interpolateYAxis(particle.pathType) *
              -particle.endY *
              cy;
      canvas.drawCircle(Offset(dx, dy), particle.radius, paint);
    }
  }
}
