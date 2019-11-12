import 'package:fish_tank/components/objects/enemy_fish.dart';
import 'package:flame/sprite.dart';
import 'package:fish_tank/fish_tank_game.dart';

// Extends EnemyFish while supplying a unique sprite
class BulletFish extends EnemyFish {
  BulletFish(FishTankGame game, double x, double y, double w, double h) : super(game, x, y, w, h) {
    fishSprite = List<Sprite>();
    fishSprite.add(Sprite('sprite-fish-bullet-1.png'));
  }
}