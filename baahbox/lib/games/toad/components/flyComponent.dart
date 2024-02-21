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

import 'dart:io';
import 'dart:math' as math;
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:baahbox/games/toad/toadGame.dart';

class FlyComponent extends SpriteComponent
    with  HasVisibility, HasGameRef<ToadGame> {
  FlyComponent({required super.size}) : super(anchor: Anchor.center);

  final flySprite = Sprite(Flame.images.fromCache('Games/Toad/fly.png'));

  late final _timer = TimerComponent(
    period: 3,
    onTick: disappear,
    autoStart: false,
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await add(_timer);
    initialize();
  }

  void initialize() {
    this.sprite = flySprite;
    var ratio = flySprite.srcSize.x / flySprite.srcSize.y;
    var width = gameRef.size.x/10;
    size = Vector2(width,width/ratio);

    gameRef.registerToFlyNet(position);
    show();
    _timer.timer.start();

  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void hide() {
    isVisible = false;
  }

  void show() {
    isVisible = true;
  }

  void disappear() {
    this.add(OpacityEffect.fadeOut(EffectController(duration: 0.75)));
    gameRef.unRegisterFromFlyNet(position);
    removeFromParent();
  }

  void takeHit() {
    disappear();
  }
}

