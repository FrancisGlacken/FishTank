import 'package:flame/sprite.dart';
import 'package:fish_tank/components/objects/bubble.dart';
import 'package:fish_tank/fish_tank_game.dart';

class BubbleBlue extends Bubble {
  BubbleBlue(FishTankGame game, double x, double y) : super(game, x, y) {
    bubbleSprite = List<Sprite>();
    bubbleSprite.add(Sprite('bubble.png'));
  }
}