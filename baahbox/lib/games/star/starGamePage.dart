import 'starGame.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flame/game.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:baahbox/games/overlayBuilder.dart';

class StarGamePage extends StatelessWidget {
  final Controller c = Get.find();
  final game = StarGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          GameWidget(
            game: game,
            overlayBuilderMap: const {
              'PreGame': OverlayBuilder.preGame,
              'PostGame': OverlayBuilder.postGame,
            },
          ),
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () => Get.back(),
            tooltip: 'Go back',
            child: const Icon(Icons.arrow_back)
        )
    );
  }
}