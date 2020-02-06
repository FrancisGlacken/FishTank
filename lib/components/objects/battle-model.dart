import 'package:fish_tank/components/objects/enemy_fish.dart';
import 'package:fish_tank/components/objects/fish.dart';

class BattleModel {

  // Player fishy variables
  String playerName;
  int playerHP;
  int playerExp;
  int playerAttack;
  int playerDefense;
  int playerFishiness; 
  bool playerAlive; 

  // Enemy fishy variables
  String enemyName; 
  int enemyHP; 
  int enemyExp; 
  int enemyAttack;
  int enemyDefense; 
  bool enemyAlive; 

  // Other variables
  String dialogue; 
  int damage; 


  BattleModel(Fish player, EnemyFish enemy) {
    playerName = player.fishName; 
    playerHP = player.fishHP; 
    playerAttack = player.fishStr; 
    playerDefense = player.fishDef; 
    playerExp = player.fishExp; 
    playerFishiness = player.fishiness;
    playerAlive = true; 

    enemyName = enemy.fishName; 
    enemyHP = enemy.fishHP; 
    enemyAttack = enemy.fishStr; 
    enemyDefense = enemy.fishDef; 
    enemyExp= enemy.fishExp; 
    enemyAlive = true;

    dialogue = "An enemy came crashing down!!!"; 
    damage = 0; 
  }
}