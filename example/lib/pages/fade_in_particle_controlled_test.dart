import 'package:example/widgets/title_fade_particle.dart';
import 'package:fade_out_particle/fade_out_particle.dart';
import 'package:flutter/material.dart';

class FadeInParticleControlledTest extends StatefulWidget {
  const FadeInParticleControlledTest({Key? key}) : super(key: key);

  @override
  _FadeInParticleControlledTestState createState() =>
      _FadeInParticleControlledTestState();
}

class _FadeInParticleControlledTestState
    extends State<FadeInParticleControlledTest> with TickerProviderStateMixin {
  late final AnimationController _fadeInParticleCtrl =
      AnimationController(vsync: this, duration: const Duration(seconds: 3));

  bool _start = false;

  @override
  void initState() {
    super.initState();
    _onTapButton();
  }

  void _onTapButton() {
    setState(() => _start = false);
    _fadeInParticleCtrl.stop();
    _fadeInParticleCtrl.reset();
    _fadeInParticleCtrl.animateTo(1).whenComplete(() => _fadeInParticleCtrl
        .animateBack(0)
        .whenComplete(() => setState(() => _start = true)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
      FadeInParticleControlled(
          random: true,
          beginX: -50,
          endX: 50,
          beginY: -50,
          endY: 50,
          curve: Curves.linear,
          controller: _fadeInParticleCtrl,
          child: const TitleFadeParticle(out:false)),
      const SizedBox(height: 150),
      OutlinedButton(
          onPressed: _onTapButton,
          // onPressed: () => setState(() => _disappear = !_disappear),
          child: Text(_start ? "Start" : "Reset"))
    ])));
  }

  @override
  void dispose() {
    _fadeInParticleCtrl.dispose();
    super.dispose();
  }
}
