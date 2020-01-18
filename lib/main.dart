import 'dart:math' as math;

import 'package:flame/anchor.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final size = await Flame.util.initialDimensions();

  final game = MyGame(size);
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text("ihaaa"),
      ),
      body: game.widget,
    ),
  ));
}

class Bg extends Component with Resizable {
  @override
  void render(Canvas c) {
    c.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), Paint()..color = Color(0xFFDDC0A3));
  }

  @override
  void update(double t) {}
}

class Bird extends AnimationComponent with Resizable {
  static const SIZE = 52.0;
  static const GRAVITY = 350.0;
  static const BOOST = 175.0;

  double speedY = 0.0;
  bool isFrozen = true;

  Bird() : super.sequenced(SIZE, SIZE, 'bird.png', 4, textureWidth: 16.0, textureHeight: 16.0) {
    this.anchor = Anchor.center;
  }

  Position get velocity => Position(200.0, speedY);

  @override
  void update(double t) {
    super.update(t);
    if (isFrozen) return;

    this.y += speedY * t - GRAVITY * t * t / 2;
    this.speedY += GRAVITY * t;

    this.angle = velocity.angle();

    if (y > size.height) {
      this.reset();
    }
  }

  void reset() {
    this.x = size.width / 2;
    this.y = size.height / 2;
    isFrozen = true;
    speedY = 0.0;
    angle = 0.0;
  }

  @override
  void resize(Size size) {
    super.resize(size);
    reset();
  }

  whenTap() {
    if (isFrozen) {
      isFrozen = false;
    }
    this.speedY = (speedY - BOOST).clamp(-BOOST, speedY);
  }
}

class MyGame extends BaseGame {

  final bird = Bird();

  MyGame(Size size) {
    this.size = size;
    add(Bg());
    add(bird);
  }

  @override
  void onTap() {
    bird.whenTap();
  }
}
