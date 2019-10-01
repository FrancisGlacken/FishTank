import 'package:fish_tank/components/objects/enemy_fish.dart';
import 'package:flame/sprite.dart';
import 'package:fish_tank/components/objects/fish.dart';
import 'package:fish_tank/fish_tank_game.dart';

class MudFish extends EnemyFish {
  MudFish(FishTankGame game, double x, double y) : super(game, x, y) {
    fishSprite = List<Sprite>();
    fishSprite.add(Sprite('fish-sprite-1-L.png'));
    fishSprite.add(Sprite('fish-sprite-1-R.png'));
    fishSprite.add(Sprite('fish-sprite-1-Dead.png'));
  }
}