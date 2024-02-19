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
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:baahbox/games/toad/toadGame.dart';
import 'package:flame/geometry.dart';

class FlyComponent extends SpriteComponent
    with  HasVisibility, HasGameRef<ToadGame> {
  FlyComponent()
      : super(size: Vector2(50, 50), anchor: Anchor.center);

  final flySprite = Sprite(Flame.images.fromCache('Jeux/Toad/fly@3x.png'));


  @override
  Future<void> onLoad() async {
    super.onLoad();
    initialize();

  }

  void initialize() {
    this.sprite = flySprite;
    var ratio = flySprite.srcSize.x / flySprite.srcSize.y;
    var width = gameRef.size.x/10;
    size = Vector2(width,width/ratio);
    position =  Vector2(gameRef.size.x / 2, gameRef.size.y - size.y -50);
    show();
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





  void hit() {
    //setSpriteTo(3);
    // game.add(BimComponent(
    //    position: Vector2(position.x + size.x/2, position.y - size.y - 20)));
  }
}

