import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import '../game/arabia_game.dart';

class CustomerComponent extends PositionComponent with TapCallbacks {
  final ArabiaGame game;
  final int variant;
  final int slotIndex;

  Sprite? _sprite;
  double _bob = 0;

  CustomerComponent({
    required this.game,
    required this.variant,
    required this.slotIndex,
    required Vector2 screenSize,
  }) : super(
          size: Vector2(140, 240),
          priority: 50 + slotIndex,
        ) {
    // المواقع: 4 فتحات في النص
    final startX = 280.0;
    final spacing = 130.0;
    position = Vector2(
      startX + (slotIndex * spacing),
      screenSize.y - 520,
    );
  }

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load(
      'assets/images/arabia/customer_$variant.png',
    );
    _sprite = Sprite(image);
  }

  @override
  void update(double dt) {
    _bob += dt * 2.5;
  }

  @override
  void render(Canvas canvas) {
    if (_sprite == null) return;

    // حركة بسيطة (تمايل)
    final offsetY = math.sin(_bob) * 4;

    _sprite!.render(
      canvas,
      position: Vector2(0, offsetY),
      size: size,
    );

    // علامة "!" لو الزبون مستني
    _drawExclamation(canvas, size.x / 2, -10 + offsetY);
  }

  void _drawExclamation(Canvas canvas, double x, double y) {
    final bob = math.sin(_bob * 2) * 3;
    final cy = y + bob;

    canvas.drawCircle(
      Offset(x, cy),
      14,
      Paint()..color = const Color(0xFFFFD54A),
    );
    canvas.drawCircle(
      Offset(x, cy),
      14,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final tp = TextPainter(
      text: const TextSpan(
        text: '!',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x - tp.width / 2, cy - tp.height / 2));
  }

  @override
  void onTapDown(TapDownEvent event) {
    // لما تدوس على الزبون → يخدم
    game.serveCustomer(this);
  }
}