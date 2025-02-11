import 'package:example/widgets/title_fade_particle.dart';
import 'package:fade_out_particle/fade_out_particle.dart';
import 'package:flutter/material.dart';

class FadeOutParticleTest extends StatefulWidget {
  const FadeOutParticleTest({Key? key}) : super(key: key);

  @override
  _FadeOutParticleTestState createState() => _FadeOutParticleTestState();
}

class _FadeOutParticleTestState extends State<FadeOutParticleTest> {
  bool _disappear = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeOutParticle(
              spaceBetweenParticles: 3,
                disappear: _disappear,
                duration: const Duration(milliseconds: 3000),
                child: const TitleFadeParticle(),
                onAnimationEnd: () => print('animation ended')),
            const SizedBox(height: 150),
            OutlinedButton(
              onPressed: () => setState(() => _disappear = !_disappear),
              child: Text(_disappear ? 'Reset' : 'Start'),
            ),
          ],
        ),
      ),
    );
  }
}
