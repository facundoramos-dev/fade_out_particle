import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:fade_out_particle/models/particle.dart';
import 'package:fade_out_particle/utils/render_object.dart';
import 'package:fade_out_particle/extensions/extensions.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

const _particleMaxRadius = 2;
const _particleMinRadius = 1;
// const _spaceBetweenParticles = 3;

/// Fade out Particle effect
@immutable
class FadeOutParticle extends StatefulWidget {
  /// widget which is going to be disappeared
  final Widget child;

  /// begin positions particles axis X
  final double beginX;

  /// end position particles axis X
  final double endX;

  /// begin position particles axis Y
  final double beginY;

  /// end positions particles axis Y
  final double endY;

  /// space between particles (+space = -particles)
  final int spaceBetweenParticles;

  /// to assign random values ​​to the endpoints of the axes
  final bool random;

  /// duration of animation
  final Duration duration;

  /// whether to start disappearing [child] or not
  final bool disappear;

  /// curve of animation
  final Curve curve;

  /// callback to get notified when animation is ended
  final VoidCallback? onAnimationEnd;

  /// Fade out Particle effect
  const FadeOutParticle({
    required this.disappear,
    required this.child,
    this.beginX = 0,
    this.endX = -10,
    this.beginY = 0,
    this.endY = 6,
    this.spaceBetweenParticles = 2,
    this.random = false,
    this.duration = const Duration(milliseconds: 1500),
    this.curve = Curves.easeOut,
    this.onAnimationEnd,
    super.key,
  }) : assert(spaceBetweenParticles >= 1);

  @override
  State createState() => _FadeOutParticleState();
}

class _FadeOutParticleState extends State<FadeOutParticle>
    with SingleTickerProviderStateMixin {
  final GlobalKey _repaintKey = GlobalKey();
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationEnd?.call();
      }
    });
  late final CurvedAnimation _animation = CurvedAnimation(
    parent: _controller,
    curve: widget.curve,
  );
  LinkedList<Particle>? _particles;

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    if (widget.disappear) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _prepareParticles());
    }
  }

  @override
  void didUpdateWidget(FadeOutParticle oldWidget) {
    if (oldWidget.duration != widget.duration ||
        oldWidget.curve != widget.curve) {
      _controller.duration = widget.duration;
      _animation.curve = widget.curve;
    }
    if (oldWidget.disappear != widget.disappear) {
      if (widget.disappear) {
        _prepareParticles();
      } else {
        _controller.reset();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        key: _repaintKey,
        child: AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext _, Widget? child) => RenderObjectParticle(
                progress: _animation.value,
                particles: _particles,
                particleMaxRadius: _particleMaxRadius,
                child: child),
            child: widget.child));
  }

  Future<void> _prepareParticles() async {
    final repaintContext = _repaintKey.currentContext;
    if (repaintContext == null) return;

    RenderRepaintBoundary boundary =
        repaintContext.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image;
    try {
      image = await boundary.toImage();
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _prepareParticles());

      return;
    }

    final bytes = await image.toByteData();

    if (bytes != null && image.width >= 2 && image.height >= 2) {
      _generateParticles(bytes, image.width, image.height);
    }

    image.dispose();
  }

  void _generateParticles(ByteData bytes, int width, int height) {
    final verticalCount = math.max(1, height ~/ widget.spaceBetweenParticles);
    final horizontalCount = math.max(1, width ~/ widget.spaceBetweenParticles);

    final particles = LinkedList<Particle>();
    int horizontalOffset;
    int halfSpace = widget.spaceBetweenParticles ~/ 2;
    int verticalOffset = halfSpace;
    final random = math.Random();
    for (int i = 0; i < verticalCount; i++) {
      horizontalOffset = halfSpace;
      for (var j = 0; j < horizontalCount; j++) {
        final rgbaColor = bytes.maybeNonTransparentColor(
          horizontalOffset,
          verticalOffset,
          width,
          halfSpace,
        );
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
    if (mounted) {
      setState(() {
        _particles = particles;
        _controller.forward();
      });
    }
  }

  double _generateRandomRadius(math.Random random) =>
      random.nextDouble() * (_particleMaxRadius - _particleMinRadius) +
      _particleMinRadius;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
