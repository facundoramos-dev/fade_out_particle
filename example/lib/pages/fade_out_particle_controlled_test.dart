import 'package:example/widgets/title_fade_out_particle.dart';
import 'package:fade_out_particle/fade_out_particle.dart';
import 'package:flutter/material.dart';

class FadeOutParticleControlledTest extends StatefulWidget {
  const FadeOutParticleControlledTest({Key? key}) : super(key: key);

  @override
  _FadeOutParticleControlledTestState createState() =>
      _FadeOutParticleControlledTestState();
}

class _FadeOutParticleControlledTestState
    extends State<FadeOutParticleControlledTest> with TickerProviderStateMixin {
  late final AnimationController _fadeOutParticleCtrl =
      AnimationController(vsync: this, duration: const Duration(seconds: 3));

  bool _start = false;

  @override
  void initState() {
    super.initState();
    _fadeOutParticleCtrl.animateTo(1).whenComplete(() => _fadeOutParticleCtrl
        .animateBack(0)
        .whenComplete(() => setState(() => _start = true)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
      FadeOutParticleControlled(
          random: true,
          beginX: -50,
          endX: 50,
          beginY: -50,
          endY: 50,
          curve: Curves.linear,
          controller: _fadeOutParticleCtrl,
          child: const TitleFadeOutParticle()),
      const SizedBox(height: 150),
      OutlinedButton(
          onPressed: () async {
            setState(() => _start = false);
            _fadeOutParticleCtrl.stop();
            _fadeOutParticleCtrl.reset();
            _fadeOutParticleCtrl.animateTo(1).whenComplete(() =>
                _fadeOutParticleCtrl
                    .animateBack(0)
                    .whenComplete(() => setState(() => _start = true)));
          },
          // onPressed: () => setState(() => _disappear = !_disappear),
          child: Text(_start ? "Start" : "Reset"))
    ])));
  }

  @override
  void dispose() {
    _fadeOutParticleCtrl.dispose();
    super.dispose();
  }
}
