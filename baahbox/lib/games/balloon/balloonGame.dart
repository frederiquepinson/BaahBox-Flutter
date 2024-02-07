import 'dart:ui';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/games/BBGame.dart';
import 'balloonComponent.dart';

class BalloonGame extends BBGame with TapCallbacks {
  final Controller appController = Get.find();
  late BalloonComponent _balloon;

  var panInput = 0;
  var input = 0;
  var instructionTitle = 'Gonfle le ballon';
  var instructionSubtitle = 'en contractant ton muscle';
  var feedback1 = "c'est parti !";
  var feedback2 = 'encore un petit effort!';
  var feedback3 = 'on y est presque !';

  @override
  Color backgroundColor() => BBGameList.balloon.baseColor.color;

  @override
  Future<void> onLoad() async {
    title = instructionTitle;
    subTitle = instructionSubtitle;
    feedback = "";
    super.onLoad();
    await Flame.images.loadAll(<String>[
      'Jeux/Balloon/ballon_00@2x.png',
      'Jeux/Balloon/ballon_01@2x.png',
      'Jeux/Balloon/ballon_02@2x.png',
      'Jeux/Balloon/ballon_03@2x.png',
      'Jeux/Balloon/ballon_04@2x.png',
    ]);
    _balloon = BalloonComponent();
    await add(_balloon);
  }


  @override
  void update(double dt) {
    super.update(dt);
    if (isRunning) {
      refreshInput();
      updateOverlaysAndState();
    }
  }

  void refreshInput() {
    // todo deal with 2 muscles or joystick input
    if (appController.isConnectedToBox) {
      // The strength is in range [0...1024] -> Have it fit into [0...100]
      input = appController.musclesInput.muscle1;
    } else {
      input = panInput;
    }
  }

  void updateOverlaysAndState() {
    int coeff = (input / 100).toInt();
    if (input < 300) {
      // title = instructionTitle;
      // subTitle = instructionSubtitle;
      feedback = feedback1;
      refreshWidget();
    } else if (input < 500) {
      feedback = feedback2;
      // title = feedback;
      // subTitle = '';
      refreshWidget();
    } else if (input < 800) {
      feedback = feedback3;
      refreshWidget();
    } else {
      endGame();
    }
  }

  @override
  void startGame() {
    super.startGame();
    displayFeedBack();
  }

  @override
  void resetGame() {
    super.resetGame();
    _balloon.initialize();
  }

  @override
  void endGame() {
    state = GameState.won;
    super.endGame();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (appController.isConnectedToBox || state != GameState.running) {
      panInput = 0;
    } else {
      var yPos = info.eventPosition.global.y;
      panInput = ((canvasSize.y - yPos) * 1024.0 / canvasSize.y).toInt();
      print(
          "panInput : ${panInput} :::  panY : ${yPos} vs game ${canvasSize.y}");
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    print("state : $state ");
  }
}
