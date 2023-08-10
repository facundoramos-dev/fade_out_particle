import 'package:example/pages/fade_in_particle_controlled_test.dart';
import 'package:example/pages/fade_out_particle_controlled_test.dart';
import 'package:example/pages/fade_out_particle_test.dart';
import 'package:example/utils/pages_transitions.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FadeOutParticle Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeOutCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));
  late final Animation<double> _fadeOutAnimation =
      Tween<double>(begin: 1, end: 0).animate(_fadeOutCtrl);

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: const Color(0xFF131A29),
      body: SafeArea(
          child: FadeTransition(
              opacity: _fadeOutAnimation,
              child: SingleChildScrollView(
                  child: Column(children: [
                ..._createRoute(
                    "FadeInParticleControlled", FadeInParticleControlledTest()),
                ..._createRoute("FadeOutParticleControlled",
                    FadeOutParticleControlledTest()),
                ..._createRoute("FadeOutParticle", FadeOutParticleTest()),
              ])))));

  List<Widget> _createRoute(String title, Widget page) => [
        ListTile(
            title: Text(title,
                style: TextStyle(fontSize: 20, color: Colors.white)),
            leading:
                const Icon(Icons.book_outlined, size: 30, color: Colors.white),
            trailing: const Icon(Icons.keyboard_arrow_right,
                size: 30, color: Colors.white),
            onTap: () async {
              await _fadeOutCtrl.animateTo(1);
              await Navigator.push(context, FadeRoute(page));
              _fadeOutCtrl.animateBack(0);
            }),
        const Divider()
      ];

  @override
  void dispose() {
    _fadeOutCtrl.dispose();
    super.dispose();
  }
}
