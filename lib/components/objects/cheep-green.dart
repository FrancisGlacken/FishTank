import 'package:flame/sprite.dart';
import 'package:fish_tank/components/objects/fish.dart';
import 'package:fish_tank/fish_tank_game.dart';

class CheepGreen extends Fish {
  CheepGreen(FishTankGame game, double x, double y, double w, double h, String name, int id) : super(game, x, y, w, h, name, id) {
    fishSprite = List<Sprite>();
    fishSprite.add(Sprite('cheep-green.png'));
    fishSprite.add(Sprite('cheep-green-right.png'));

  }
}