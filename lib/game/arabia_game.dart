import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../components/add_button.dart';
import '../components/cart_component.dart';
import '../components/customer_component.dart';
import '../components/hud.dart';

class ArabiaGame extends FlameGame {
  int customersServed = 0;
  int money = 0;
  final List<CustomerComponent> _activeCustomers = [];

  bool _built = false;

  @override
  Color backgroundColor() => const Color(0xFF2A1F14);

  @override
  Future<void> onLoad() async {
    debugPrint('>>> ARABIA GAME: onLoad called');
    // مفيش حاجة هنا — نبني في onGameResize
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    debugPrint('>>> ARABIA GAME: resize to $newSize');

    if (_built) return;
    if (newSize.x < 10 || newSize.y < 10) return;
    _built = true;

    _buildWorld(newSize);
  }

  Future<void> _buildWorld(Vector2 screenSize) async {
    debugPrint('>>> BUILDING WORLD with size $screenSize');

    try {
      // 1. خلفية الزقاق
      final bgImage = await Flame.images.load(
        'assets/images/arabia/street_bg.png',
      );
      add(
        SpriteComponent(
          sprite: Sprite(bgImage),
          size: screenSize,
          priority: -100,
        ),
      );
      debugPrint('>>> BG loaded');

      // 2. العربية
      add(CartComponent(screenSize: screenSize));
      debugPrint('>>> Cart added');

      // 3. HUD
      add(HudComponent(game: this));
      debugPrint('>>> HUD added');

      // 4. زرار "زبون جديد"
      add(AddCustomerButton(game: this, screenSize: screenSize));
      debugPrint('>>> Button added');

      debugPrint('>>> WORLD BUILD DONE');
    } catch (e, st) {
      debugPrint('>>> ERROR building world: $e');
      debugPrint('>>> STACK: $st');
    }
  }

  void addNewCustomer() {
    if (_activeCustomers.length >= 4) return;

    final variant = (_activeCustomers.length % 4) + 1;

    final c = CustomerComponent(
      game: this,
      variant: variant,
      slotIndex: _activeCustomers.length,
      screenSize: size,
    );

    _activeCustomers.add(c);
    add(c);
  }

  void removeCustomer(CustomerComponent c) {
    _activeCustomers.remove(c);
  }

  void serveCustomer(CustomerComponent c) {
    customersServed++;
    money += c.order.price;
    c.removeFromParent();
    _activeCustomers.remove(c);
  }
}