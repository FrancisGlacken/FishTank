import 'package:fish_tank/fish_tank_game.dart';


// TODOx3: Make bubbles limited spawn, make bubbles pop, add different variants of bubbles
class BubbleSpawner {
  final FishTankGame game;
  final int maxSpawnInterval = 5000;
  final int minSpawnInterval = 5000;
  final int intervalChange = 3;
  //int maxBubbles = 10; 
  int currentInterval;
  int nextSpawn; 

  BubbleSpawner(this.game) {
    start(); 
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
        currentInterval -= (currentInterval * .15).toInt();
      }
      nextSpawn = nowTimestamp + currentInterval; 
    }
  }
}