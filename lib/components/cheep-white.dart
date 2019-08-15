import 'package:flame/sprite.dart';
import 'package:fish_tank/components/fish.dart';
import 'package:fish_tank/fish_tank_game.dart';

class CheepWhite extends Fish {
  CheepWhite(FishTankGame game, double x, double y) : super(game, x, y) {
    fishSprite = List<Sprite>();
    fishSprite.add(Sprite('cheep-white.png'));
  }
}