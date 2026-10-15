import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/arabia_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const NourArabiaApp());
}

class NourArabiaApp extends StatelessWidget {
  const NourArabiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "عربية النور",
      debugShowCheckedModeBanner: false,
      home: const GamePage(),
    );
  }
}

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A1F14),
      body: GameWidget(
        game: ArabiaGame(),
      ),
    );
  }
}