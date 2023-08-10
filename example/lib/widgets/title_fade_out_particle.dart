import 'package:flutter/material.dart';

class TitleFadeOutParticle extends StatelessWidget {
  const TitleFadeOutParticle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.flutter_dash,
            size: 52, color: Theme.of(context).primaryColorDark),
        const SizedBox(width: 8),
        Text('Fade out Particle',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontWeight: FontWeight.w900))
      ]);
}
