/*
 * Baah Box
 * Copyright (c) 2024. Orange SA
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 */

import 'dart:math' as math;
import 'dart:math';
import 'dart:core';
import 'package:baahbox/games/toad/components/tongueComponent.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:baahbox/games/toad/toadGame.dart';
import 'package:flame/geometry.dart';

class ToadComponent extends SpriteComponent
    with  HasVisibility,
        HasGameRef<ToadGame> {
  ToadComponent()
      : super(size: Vector2(100, 100), anchor: Anchor.bottomCenter);

  final toadSprite = Sprite(Flame.images.fromCache('Games/Toad/toad.png'));
  final toadBlinkSprite = Sprite(Flame.images.fromCache('Games/Toad/toad_blink.png'));


  final blinkingImages = [
    Flame.images.fromCache('Games/Toad/toad.png'),
    Flame.images.fromCache('Games/Toad/toad_blink.png'),
  ];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    initialize();

  }

  void initialize() {
    this.sprite = toadSprite;
    var ratio = toadSprite.srcSize.x / toadSprite.srcSize.y;
    var width = gameRef.size.x * 3/8;
    size = Vector2(width,width/ratio);
    anchor = Anchor.center;
    position =  Vector2(gameRef.size.x / 2, gameRef.size.y - size.y -50);
    angle = nativeAngle;
    show();
  }

  @override
  void update(double dt) {
    super.update(dt);
    checkFlies();
  }

  void hide() {
    isVisible = false;
  }

  void show() {
    isVisible = true;
  }

  void rotateBy(int deltaAngle) {
    {
      var newAngle = angle + (deltaAngle/ 180 * math.pi/2) ;
      if ( newAngle> tau/4 || newAngle < -tau/4) { return ;}
      angle = newAngle;

    }
  }

  void checkFlies() {
    for ( double x in gameRef.flyNet.keys) {
      var target = Vector2(x, gameRef.flyNet[x]!);
      var angleToTarget = angleTo(target);
      if (angleToTarget.abs() <= pi / 360) {
        shoot();
      }
    }
  }
  void setSpriteTo(int spriteNb) {
    switch (spriteNb) {
      case 1:
        sprite = toadBlinkSprite;
      default:
        sprite = toadSprite;
    }
  }

  SpriteAnimation getBlinkAnimation() {
    final sprites = blinkingImages.map((image) => Sprite(image)).toList();
    return SpriteAnimation.spriteList(sprites, stepTime: 1);
  }

  void shoot() {
    gameRef.tongue.priority = -1;
    gameRef.tongue.showAtAngle(angle);
    print("shoooot");
    // animateToadForShooting();
    //setSpriteTo(3);
   // game.add(BimComponent(
    //    position: Vector2(position.x + size.x/2, position.y - size.y - 20)));
  }
}
