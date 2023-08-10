import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fade_out_particle/models/particle.dart';
import 'package:fade_out_particle/extensions/extensions.dart';
import 'package:fade_out_particle/utils/render_object.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

const int _particleMaxRadius = 2;
const int _particleMinRadius = 1;

/// Fade in Particle effect with controller
@immutable
class FadeInParticleControlled extends StatefulWidget {
  const FadeInParticleControlled({
    Key? key,
    required this.controller,
    this.curve = Curves.easeInOut,
    required this.child,
    this.beginX = 0,
    this.endX = 10,
    this.beginY = 0,
    this.endY = -6,
    this.spaceBetweenParticles = 2,
    this.random = false,
  }) : super(key: key);

  final AnimationController controller;
  final Curve curve;
  final Widget child;
  final double endX;
  final double beginX;
  final double endY;
  final double beginY;
  final int spaceBetweenParticles;
  final bool random;

  @override
  State<FadeInParticleControlled> createState() =>
      _FadeInParticleControlledState();
}

class _FadeInParticleControlledState extends State<FadeInParticleControlled> {
  final GlobalKey _repaintKey = GlobalKey();

  LinkedList<Particle>? _particles;

  late final Animation<double> _animation = Tween<double>(begin: 1, end: 0)
      .animate(CurvedAnimation(parent: widget.controller, curve: widget.curve));

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    _postBuild();
  }

  void _postBuild() =>
      WidgetsBinding.instance.addPostFrameCallback((_) => _prepareParticles());

  Future<void> _prepareParticles() async {
    final BuildContext? repaintContext = _repaintKey.currentContext;
    if (repaintContext == null) return;
    RenderRepaintBoundary boundary =
        repaintContext.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image;
    try {
      image = await boundary.toImage();
    } catch (e) {
      _postBuild();
      return;
    }

    final ByteData? bytes = await image.toByteData();

    if (bytes != null && image.width >= 2 && image.height >= 2) {
      _generateParticles(bytes, image.width, image.height);
    }

    image.dispose();
  }

  void _generateParticles(ByteData bytes, int width, int height) {
    final int verticalCount =
        math.max(1, height ~/ widget.spaceBetweenParticles);
    final int horizontalCount =
        math.max(1, width ~/ widget.spaceBetweenParticles);

    final LinkedList<Particle> particles = LinkedList<Particle>();
    int horizontalOffset;
    int halfSpace = widget.spaceBetweenParticles ~/ 2;
    int verticalOffset = halfSpace;
    final math.Random random = math.Random();
    for (int i = 0; i < verticalCount; i++) {
      horizontalOffset = halfSpace;
      for (int j = 0; j < horizontalCount; j++) {
        final int rgbaColor = bytes.maybeNonTransparentColor(
            horizontalOffset, verticalOffset, width, halfSpace);
        if (!rgbaColor.isTransparent) {
          particles.add(Particle(
            cx: horizontalOffset,
            cy: verticalOffset,
            rgbaColor: rgbaColor,
            radius: _generateRandomRadius(random),
            pathType: random.nextInt(6),
            endX: widget.random
                ? random.getRangeDouble(widget.beginX, widget.endX)
                : widget.endX,
            endY: widget.random
                ? random.getRangeDouble(widget.beginY, widget.endY)
                : widget.endY,
          ));
        }
        horizontalOffset += widget.spaceBetweenParticles;
      }
      verticalOffset += widget.spaceBetweenParticles;
    }
    setState(() => _particles = particles);
  }

  double _generateRandomRadius(math.Random random) =>
      random.nextDouble() * (_particleMaxRadius - _particleMinRadius) +
      _particleMinRadius;

  @override
  Widget build(BuildContext context) => Opacity(
      opacity: _particles != null ? 1 : 0.1,
      child: RepaintBoundary(
          key: _repaintKey,
          child: AnimatedBuilder(
              animation: _animation,
              builder: (BuildContext _, Widget? child) => RenderObjectParticle(
                  progress: _particles == null ? 0 : _animation.value,
                  particles: _particles,
                  particleMaxRadius: _particleMaxRadius,
                  child: child),
              child: widget.child)));
}
