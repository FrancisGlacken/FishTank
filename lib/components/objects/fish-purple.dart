import 'package:flame/sprite.dart';
import 'package:fish_tank/components/objects/fish.dart';
import 'package:fish_tank/fish_tank_game.dart';

class PurpleFish extends Fish {
  PurpleFish(FishTankGame game, double x, double y) : super(game, x, y) {
    fishSprite = List<Sprite>();
    fishSprite.add(Sprite('fish-sprite-5-L.png'));
    fishSprite.add(Sprite('fish-sprite-5-R.png')); 
  }
}