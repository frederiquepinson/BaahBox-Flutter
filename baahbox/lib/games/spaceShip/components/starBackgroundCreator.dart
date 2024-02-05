import 'dart:math';
import 'package:baahbox/games/spaceShip/spaceShipGame.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:baahbox/games/spaceShip/components/starComponent.dart';

class StarBackGroundCreator extends Component with HasGameRef<SpaceShipGame> {
  final gapSize = 12;
  late final SpriteSheet spriteSheet;
  Random random = Random();

  StarBackGroundCreator();

  @override
  Future<void> onLoad() async {
    spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: await game.images.load('Jeux/rogue_shooter/stars.png'),
      rows: 4,
      columns: 4,
    );
    final starGapTime = (game.size.y / gapSize) / StarComponent.speed;
    add(
      TimerComponent(
        period: starGapTime,
        repeat: true,
        onTick: () => _createRowOfStars(0),
      ),
    );

    _createInitialStars();
  }

  void _createStarAt(double x, double y) {
    final animation = spriteSheet.createAnimation(
      row: random.nextInt(3),
      to: 4,
      stepTime: 0.1,
    )..variableStepTimes = [max(20, 100 * random.nextDouble()), 0.1, 0.1, 0.1];

    game.add(StarComponent(animation: animation, position: Vector2(x, y)));
  }

  void _createRowOfStars(double y) {
    const gapSize = 6;
    final starGap = game.size.x / gapSize;
    if (game.appController.isActive) {
      for (var i = 0; i < gapSize; i++) {
        _createStarAt(
          starGap * i + (random.nextDouble() * starGap),
          y + (random.nextDouble() * 20),
        );
      }
    }
  }

  void _createInitialStars() {
    final rows = game.size.y / gapSize;

    for (var i = 0; i < gapSize; i++) {
      _createRowOfStars(i * rows);
    }
  }
}
