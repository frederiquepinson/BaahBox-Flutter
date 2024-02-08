import 'dart:math';
import 'dart:ui';
import 'package:baahbox/games/trex/game_over.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/games/BBGame.dart';
import 'package:baahbox/games/sheep/components/sheepComponent.dart';
import 'package:baahbox/games/sheep/components/gateComponent.dart';
import 'package:baahbox/games/sheep/components/floorComponent.dart';
import 'package:baahbox/games/sheep/components/bimComponent.dart';
import 'package:baahbox/games/sheep/components/happySheepComponent.dart';
import 'package:baahbox/games/sheep/components/counterManager.dart';
import 'package:baahbox/games/sheep/background/cloud_manager.dart';

class SheepGame extends BBGame with TapCallbacks, HasCollisionDetection {
  final Controller appController = Get.find();

  late final Image spriteImage;
  late final CloudManager cloudManager = CloudManager();
  late final CounterManager counterManager = CounterManager();

  late final SheepComponent sheep;
  late final GateComponent gate;
  late final FloorComponent floor;
  late final BimComponent collision;
  late final HappySheepComponent happySheep;
  late final TextComponent progressionText;

  int gameObjective = 1;
  int successfulJumps = 0;
  int nbDisplayedGates = 0;
  bool hasSheepStartedJumping = false;
  bool sheepDidJumpOverGate = false;
  int strengthValue = 0;
  double gateVelocity = 1.0;

  int panInput = 0;
  int input = 0;
  double floorY = 0;
  var instructionTitle = '';
  var instructionSubtitle = '';
  var endTitle = 's';
  var feedbackTitleWon = 'Bravo! \ntu as sauté toutes les barrières';
  var feedbackTitleLost = "Tu n'as pas sauté toutes les barrières";


  @override
  Color backgroundColor() => BBGameList.sheep.baseColor.color;

  Future<void> loadAssetsInCache() async {
    await Flame.images.loadAll(<String>[
      'Jeux/Sheep/bang.png',
      'Jeux/Sheep/bim.png',
      'Jeux/Sheep/gate.png',
      'Jeux/Sheep/floor.png',
      'Jeux/Sheep/sheep_01.png',
      'Jeux/Sheep/sheep_02.png',
      'Jeux/Sheep/sheep_jumping.png',
      'Jeux/Sheep/sheep_bump.png',
      'Jeux/Sheep/happy_sheep_01.png',
      'Jeux/Sheep/happy_sheep_02.png',
      'trex.png',
    ]);
  }

  Future<void> loadComponents() async {

    await add(gate = GateComponent(speed: this.gateVelocity));
    await add(cloudManager);
    await add(counterManager);

    await add(sheep = SheepComponent(position: Vector2(size.x / 3, floorY)));
    await add(floor = FloorComponent(
        position: Vector2(size.x / 2, floorY),
        size: Vector2(size.x + 10, 5.0)));
    await add(happySheep = HappySheepComponent(
        position: Vector2(0, 0), size: Vector2(size.x / 2, size.y / 2)));
  }

  void loadInfoComponents() {
    addAll([
      progressionText = TextComponent(
        position: Vector2(size.x / 2, floorY + 50),
        anchor: Anchor.topCenter,
        priority: 1,
      ),
    ]);
  }

  @override
  Future<void> onLoad() async {
    print("1 gateVelocity $gateVelocity, gates: $gameObjective");
    var params = appController.sheepParams;
    print(params["gateVelocity"]);
   gameObjective = params["numberOfGates"];
   gateVelocity = params["gateVelocity"].value;
   var gateV = appController.sheepP.gateVelocity;

   print("2 gateVelocity $gateVelocity, gates: $gameObjective gateV $gateV");

    title = 'Essaie de sauter $gameObjective barrière';
    if (gameObjective > 1) {
      title += 's';
    }
    subTitle = instructionSubtitle;
    floorY = (size.y * 0.7);

    await loadAssetsInCache();
    await loadComponents();
    loadInfoComponents();
    progressionText.text = "";
    counterManager.createMarks(gameObjective);
    super.onLoad();
  }
// ===================
  // MARK: - Game loop
  // ===================

  @override
  void update(double dt) {
    super.update(dt);
    if (appController.isActive) {
      if (isRunning) {
        refreshInput();
        if (isNewGateOnQueue()) {
          if (!isSheepOnFloor() && !sheepDidJumpOverGate) {
            setGameStateToWon(false);
            feedback = "Il faut atterrir après la barrière!";
            progressionText.text = feedback;
          } else if (successfulJumps == gameObjective) {
            counterManager.looseOneMark();
            setGameStateToWon(true);
          }
          sheepDidJumpOverGate = false;
          progressionText.text = "";
        } else {
          checkSheepAndGatePositions();
        }
      }
    }
  }

  void refreshInput() {
    // todo deal with 2 muscles or joystick input
    if (appController.isConnectedToBox) {
      // The strength is in range [0...1024] -> Have it fit into [0...100]
      input = (appController.musclesInput.muscle1 ~/ 10);
    } else {
      input = panInput;
    }
  }

  void checkSheepAndGatePositions() {
    if (isSheepOnFloor()) {
      if ((isSheepBeyondTheGate()) &&
          hasSheepStartedJumping &&
          !sheepDidJumpOverGate) {
        counterManager.looseOneMark();
        sheepDidJumpOverGate = true;
        successfulJumps += 1;
        configureLabelsForCongrats();
      }
      hasSheepStartedJumping = false;
      // startWalkingSheepAnimation()
      configureLabelsForWalking();
    } else {
      hasSheepStartedJumping = true;
      if (isSheepBeyondTheGate()) {
        sheepDidJumpOverGate = false;
        configureLabelsToGoDown();
      } else {
        configureLabelsForJumpInProgress();
      }
    }
  }

  void configureLabelsForCongrats() {
    progressionText.text = "congrats!";
  }

  void configureLabelsForWalking() {
    progressionText.text = "walking";
  }

  void configureLabelsToGoDown() {
    progressionText.text = "Atterris après la barrière !";
  }

  void configureLabelsForJumpInProgress() {
    progressionText.text = "Hop!";
  }

  bool isNewGateOnQueue() {
    return gate.isNewComer;
  }

  bool isSheepOnFloor() {
    return sheep.isOnFloor(floorY);
  }

  bool isSheepBeyondTheGate() {
    return sheep.isBeyond(gate.position.x);
  }

  @override
  void resetGame() {
    super.resetGame();
    counterManager.createMarks(gameObjective);
    successfulJumps = 0;
    hasSheepStartedJumping = false;
    sheepDidJumpOverGate = false;
    sheep.initialize();
    gate.resetPosition();
    floor.show();
    cloudManager.start();
    progressionText.text = "";
    sheep.tremble();
    if (paused) {
      resumeEngine();
    }
  }

  void setGameStateToWon(bool win) {
    state = win ? GameState.won : GameState.lost;
    feedback = win ? feedbackTitleWon : feedbackTitleLost;
    if (win) {
      sheep.hide();
      floor.hide();
      counterManager.counterText.text = "";
    }
    progressionText.text = ""; //feedback;
    endGame();
  }

  @override
  void endGame() {
    cloudManager.pause();
    super.endGame();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (appController.isConnectedToBox || state != GameState.running) {
      panInput = 0;
    } else {
      var yPos = info.eventPosition.global.y;
      var nextY = min(yPos, floorY);
      sheep.moveTo(nextY);
    }
  }

  @override
  void onDispose() {
    // TODO: implement onDispose
    super.onDispose();
  }
  // ===================
  // MARK: - Parameters
  // ===================

  // @objc func loadParameters() {
  //   threshold = ParameterDataManager.sharedInstance.threshold
  //   gameObjective = ParameterDataManager.sharedInstance.numberOfFences
  //
  //   switch ParameterDataManager.sharedInstance.fenceVelocity {
  //   case .slow:
  //   speedRate = 1
  //   case .average:
  //   speedRate = 2
  //   default:
  //   speedRate = 3
  //   }
  //   // needed ??
  //   if !isGameOnGoing {
  //   configureScoreLabel(with: 0)
  //   }
  //   }
}
