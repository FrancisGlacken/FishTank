import 'package:flame/sprite.dart';
import 'package:fish_tank/components/objects/fish.dart';
import 'package:fish_tank/fish_tank_game.dart';

class CheepGreen extends Fish {
  CheepGreen(FishTankGame game, double x, double y) : super(game, x, y) {
    fishSprite = List<Sprite>();
    fishSprite.add(Sprite('cheep-green.png'));
    fishSprite.add(Sprite('cheep-green-right.png'));

  }
}