import 'package:flutter/material.dart';

class TitleFadeParticle extends StatelessWidget {
  const TitleFadeParticle({Key? key, this.out = true}) : super(key: key);

  final bool out;

  @override
  Widget build(BuildContext context) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.flutter_dash,
            size: 52, color: Theme.of(context).primaryColorDark),
        const SizedBox(width: 8),
        Text("Fade ${out ? 'out' : 'in'} Particle",
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontWeight: FontWeight.w900))
      ]);
}
