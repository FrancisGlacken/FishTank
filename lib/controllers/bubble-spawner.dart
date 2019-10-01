import 'package:fish_tank/fish_tank_game.dart';
import 'package:fish_tank/components/objects/bubble.dart';

// TODOx3: Make bubbles limited spawn, make bubbles pop, add different variants of bubbles
class BubbleSpawner {
  final FishTankGame game;
  final int maxSpawnInterval = 3000;
  final int minSpawnInterval = 250;
  final int intervalChange = 3;
  int maxBubbles = 10; 
  int currentInterval;
  int nextSpawn; 

  BubbleSpawner(this.game) {
    start(); 
    game.summonBubble(); 
  }

  void start() {
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval; 
  }

  void update(double t) {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;
    
    if (nowTimestamp >= nextSpawn) {
      game.summonBubble();
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * .02).toInt();
      }
      nextSpawn = nowTimestamp + currentInterval; 
    }
  }
}