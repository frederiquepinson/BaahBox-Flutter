import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/games/BBGame.dart';

class PlayButtonComponent extends TextComponent
    with TapCallbacks, HasGameRef<BBGame> {
  PlayButtonComponent(String text, TextPaint renderer)
      : super(text: text, textRenderer: renderer);
  @override
  void onTapDown(TapDownEvent event) {
    removeFromParent();
    switch (gameRef.state) {
      case GameState.initializing:
        break;
      case GameState.ready:
        gameRef.state = GameState.running;
      case GameState.running ||
            GameState.paused: // shoud not happen in this game
        break;
      case GameState.lost  || GameState.won:
        gameRef.state = GameState.initializing; // .notStarted
    }
    print("playButton ${text} tapped: new state is : ${gameRef.state}");
  }
}

//exemples  de Textpaint pour des Textcomponents:
final _regularTextStyle =
    TextStyle(fontSize: 18, color: BasicPalette.white.color);
final _regular = TextPaint(style: _regularTextStyle);
final _tiny = TextPaint(style: _regularTextStyle.copyWith(fontSize: 14.0));
final _box = _regular.copyWith(
  (style) => style.copyWith(
    color: Colors.lightGreenAccent,
    fontFamily: 'monospace',
    letterSpacing: 2.0,
  ),
);
final _shaded = TextPaint(
  style: TextStyle(
    color: BasicPalette.white.color,
    fontSize: 40.0,
    shadows: const [
      Shadow(color: Colors.red, offset: Offset(2, 2), blurRadius: 2),
      Shadow(color: Colors.yellow, offset: Offset(4, 4), blurRadius: 4),
    ],
  ),
);
