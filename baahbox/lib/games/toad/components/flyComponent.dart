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
import 'package:baahbox/games/toad/components/tongueComponent.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:baahbox/games/toad/toadGame.dart';
import 'package:baahbox/services/settings/settingsController.dart';



class FlyComponent extends SpriteComponent
    with  HasVisibility, HasGameRef<ToadGame>, CollisionCallbacks {

  double flightDuration = 5.0;
  final flySprite = Sprite(Flame.images.fromCache('Games/Toad/fly.png'));
  late final _timer = TimerComponent(
    period: flightDuration,
    onTick: disappear,
    autoStart: false,
  );

  FlyComponent(this.flightDuration) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await add(_timer);
    initialize();
  }

  void initialize()  async {
    this.sprite = flySprite;
   // this.flightDuration = flightDuration;
    var ratio = flySprite.srcSize.x / flySprite.srcSize.y;
    var width = 75.00;//gameRef.size.x/10;
    size = Vector2(width,width/ratio);

    anchor = Anchor.center;
    add(CircleHitbox());
    // var  _timer = TimerComponent(
    //   period: flightDuration,
    //   onTick: disappear,
    //   autoStart: false,
    // );
    // await add(_timer);
    gameRef.registerToFlyNet(position);
    show();
    _timer.timer.start();
  }

  void setPositionTo(Vector2 newPosition){
    gameRef.unRegisterFromFlyNet(position);
    position = newPosition;
    gameRef.registerToFlyNet(position);
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
    gameRef.unRegisterFromFlyNet(position);
    hide();
    removeFromParent();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is TongueComponent) {
      other.takeHit();
      disappear();
    }
  }
}

