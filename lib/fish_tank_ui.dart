import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fish_tank/fish_tank_game.dart';
import 'package:fish_tank/components/objects/fish.dart';
import 'package:fish_tank/components/objects/enemy_fish.dart';
import 'package:fish_tank/components/views/BattleDialogueView.dart';
import 'package:fish_tank/components/views/EnemyHPView.dart';
import 'package:fish_tank/components/views/EnemyNameView.dart';
import 'package:fish_tank/components/views/ExpView.dart';
import 'package:fish_tank/components/views/GoldView.dart';
import 'package:fish_tank/components/views/HPView.dart';
import 'package:fish_tank/components/views/SelectedFishNameView.dart';
import 'package:fish_tank/components/objects/battle-model.dart';
import 'package:fish_tank/components/views/PlaceHolderFishy.dart';
import 'package:hive/hive.dart';

enum UIScreen { home, battle, shop, journey }

class FishTankUI extends StatefulWidget {
  final FishTankUIState state = FishTankUIState();
  State<StatefulWidget> createState() => state;
}

class FishTankUIState extends State<FishTankUI> with WidgetsBindingObserver {
  // Objects
  FishTankGame game;
  BattleModel battleInfo;
  Random rng = new Random();
  UIScreen currentScreen = UIScreen.home;

  // Values for displaying data and controlling logic
  int fishyHP, enemyFishHP, fishyExp;

  String fishName, enemyFishName;
  String battleDialogue = "A new age hippie is out of sight!!!";
  bool _buttonsAbsorbed = false;
  bool _fishySelected = false;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void update() {
    setState(() {});
  }

  // Build method for everything
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: IndexedStack(
            sizing: StackFit.expand,
            children: <Widget>[
              buildScreenHome(),
              buildScreenBattle(),
              buildScreenShop()
            ],
            index: currentScreen.index,
          ),
        )
      ],
    );
  }

  // Build method for home screen
  Widget buildScreenHome() {
    return Positioned.fill(
        child: Stack(
      children: <Widget>[
        if (_fishySelected)
          Container(child: new SelectedFishNameView(fishName: fishName)),
        if (_fishySelected) Container(child: new ExpView(fishyExp: fishyExp)),
        if (_fishySelected) Container(child: new HPView(fishyHP: fishyHP)),
        feedButton(),
        consumeButton(),
        shopButton(),
        Positioned(
          bottom: 5,
          left: 5,
          child: new GoldView()
        ),
      ],
    ));
  }

  // Build method for battle screen
  Widget buildScreenBattle() {
    return Positioned.fill(
        child: Stack(children: <Widget>[
      new SelectedFishNameView(fishName: fishName),
      new ExpView(fishyExp: fishyExp),
      new HPView(fishyHP: fishyHP),
      new EnemyNameView(enemyFishName: enemyFishName),
      new EnemyHPView(enemyFishHP: enemyFishHP),
      new BattleDialogueView(game: game, battleDialogue: battleDialogue),
      AbsorbPointer(
        absorbing: _buttonsAbsorbed,
        child: Container(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Table(children: [
                  TableRow(children: [fightButton(), powerButton()]),
                  TableRow(children: [eatButton(), fleeButton()]),
                ], columnWidths: {
                  0: FlexColumnWidth(50),
                  1: FlexColumnWidth(50),
                  2: FlexColumnWidth(50),
                  3: FlexColumnWidth(50),
                }))),
      ),
      new GoldView()
    ]));
  }

  Widget buildScreenShop() {
    return Center(
        child: Container(
      color: Colors.grey[600],
      child: Stack(
        children: <Widget>[
          Table(children: [
            TableRow(children: [new GoldView(), PlaceHolderFishy(game: game)]),
            TableRow(children: [shopRedFishButton(), shopBlueFishButton()]),
            TableRow(children: [shopGreenFishButton(), shopPurpleFishButton()]),
            TableRow(children: [signExitButton(), signExitButton()])
          ]),
        ],
      ),
    ));
  }

  // Buttons //

  // button for Feed
  Widget feedButton() {
    return Positioned(
      right: 2,
      bottom: 122,
      child: Ink(
          decoration: ShapeDecoration(
            shape: CircleBorder(),
          ),
          child: FlatButton(
              onPressed: () {
                //game.fishies[1].fishLocation = FishLocation.feed;
                //feedFishy();
              },
              padding: EdgeInsets.all(0.0),
              child: Image.asset(
                'assets/images/ui-button-feed.png',
                width: 50,
                height: 50,
              ))),
    );
  }

  // button for Consume
  Widget consumeButton() {
    return Positioned(
      right: 2,
      bottom: 62,
      child: Ink(
          decoration: ShapeDecoration(
            shape: CircleBorder(),
          ),
          child: FlatButton(
              onPressed: () {
                randomBattle();
              },
              padding: EdgeInsets.all(0.0),
              child: Image.asset(
                'assets/images/ui-button-fight.png',
                width: 50,
                height: 50,
              ))),
    );
  }

  // button for Journey
  Widget shopButton() {
    return Positioned(
      right: 2,
      bottom: 2,
      child: Ink(
          decoration: ShapeDecoration(
            shape: CircleBorder(),
          ),
          child: FlatButton(
              onPressed: () {
                toShopScreen();
              },
              padding: EdgeInsets.all(0.0),
              child: Image.asset(
                'assets/images/ui-button-shop.png',
                width: 50,
                height: 50,
              ))),
    );
  }

  Widget signExitButton() {
    return FlatButton(
      onPressed: () {
        toHomeScreen();
      },
      padding: EdgeInsets.all(0.0),
      child: Image.asset(
        'assets/images/shop-exit-sign.png',
        width: game.tileSize * 3,
        height: 70,
      ),
    );
  }

  Widget shopRedFishButton() {
    return FlatButton(
      onPressed: () {
        if (game.goldBox.get('gold') >= 400) {
          FishStyle style = FishStyle.red;
          game.updateGold(-400);
          game.summonFishy(style);
          update();
        }
      },
      padding: EdgeInsets.all(0.0),
      child: Image.asset(
        'assets/images/fish-sprite-2-500.png',
        width: game.tileSize * 3,
        height: 70,
      ),
    );
  }

  Widget shopBlueFishButton() {
    return FlatButton(
      onPressed: () {
        if (game.goldBox.get('gold') >= 400) {
          FishStyle style = FishStyle.blue;
          game.updateGold(-400);
          game.summonFishy(style);
          update();
        }
      },
      padding: EdgeInsets.all(0.0),
      child: Image.asset(
        'assets/images/fish-sprite-3-500.png',
        width: game.tileSize * 3,
        height: 70,
      ),
    );
  }

  Widget shopGreenFishButton() {
    return FlatButton(
      onPressed: () {
        if (game.goldBox.get('gold') >= 400) {
          FishStyle style = FishStyle.green;
          game.updateGold(-400);
          game.summonFishy(style);
          update();
        }
      },
      padding: EdgeInsets.all(0.0),
      child: Image.asset(
        'assets/images/fish-sprite-4-500.png',
        width: game.tileSize * 3,
        height: 70,
      ),
    );
  }

  Widget shopPurpleFishButton() {
    return FlatButton(
      onPressed: () {
        if (game.goldBox.get('gold') >= 400) {
          FishStyle style = FishStyle.purple;
          game.updateGold(-400);
          game.summonFishy(style);
          update();
        }
      },
      padding: EdgeInsets.all(0.0),
      child: Image.asset(
        'assets/images/fish-sprite-5-500.png',
        width: game.tileSize * 3,
        height: 70,
      ),
    );
  }

  // button for Journey
  Widget fightButton() {
    return Ink(
        decoration: ShapeDecoration(
          shape: CircleBorder(),
        ),
        child: FlatButton(
            onPressed: () {
              fightCommand();
            },
            padding: EdgeInsets.all(0.0),
            child: Image.asset(
              'assets/images/ui-button-fight.png',
              width: 50,
              fit: BoxFit.fitHeight,
            )));
  }

  Widget powerButton() {
    return Ink(
        decoration: ShapeDecoration(
          shape: CircleBorder(),
        ),
        child: FlatButton(
            onPressed: () {
              powerCommand();
            },
            padding: EdgeInsets.all(0.0),
            child: Image.asset(
              'assets/images/ui-button-power.png',
              width: 50,
              fit: BoxFit.fitHeight,
            )));
  }

  // button for items
  Widget eatButton() {
    return Ink(
        decoration: ShapeDecoration(
          shape: CircleBorder(),
        ),
        child: FlatButton(
            onPressed: () {},
            padding: EdgeInsets.all(0.0),
            child: Image.asset(
              'assets/images/ui-button-eat.png',
              width: 50,
              fit: BoxFit.fitHeight,
            )));
  }

  // button for Battle - Flee
  Widget fleeButton() {
    return Ink(
        decoration: ShapeDecoration(
          shape: CircleBorder(),
        ),
        child: FlatButton(
            onPressed: () {
              toHomeScreen();
            },
            padding: EdgeInsets.all(0.0),
            child: Image.asset(
              'assets/images/ui-button-flee.png',
              width: 50,
              fit: BoxFit.fitHeight,
            )));
  }

  // Views //

  // Home Stuff

  void feedFishy() {
    setState(() {
      game.summonFood();
    });
  }

  // Battle Stuff
  void disableButtons() {
    setState(() => _buttonsAbsorbed = true);
  }

  void enableButtons() {
    setState(() => _buttonsAbsorbed = false);
  }

  // decreases fishy's health by 10
  void decreaseHealth() {
    setState(() => game.fishies[0].fishHP = game.fishies[0].fishHP - 10);
  }

  void enemyFishDead() {
    setState(() {
      game.evilFishies[0].fishSpriteIndex = 2;
      game.evilFishies[0].fishStatus = EnemyFishStatus.dead;
    });
  }

  // Updates battle dialogue with given string and the enemy's Hp
  void updateBattleDialogue() {
    setState(() {
      battleDialogue = battleInfo.dialogue;
    });
  }

  // Update the view with selected fishy name
  void updateSelectedFishyName() {
    setState(() {
      _fishySelected = true;
      fishyExp = game.fishies[0].fishExp;
      fishyHP = game.fishies[0].fishHP;
      fishName = game.selectedFishName;
      if (game.evilFishies.length > 0) {
        enemyFishName = game.evilFishies[0].fishName;
      }
    });
  }

  // Brings user back to home screen.
  void toHomeScreen() {
    setState(() {
      // if (1 != null) {
      //   game.fishies[1].fishLocation = FishLocation.home;
      // }
      game.evilFishies.clear();
      battleDialogue = "A wild Cheep Cheep appeared!!!";
      enableButtons();
      currentScreen = UIScreen.home;
    });
  }

  // Brings user to shop screen
  void toShopScreen() {
    setState(() {
      currentScreen = UIScreen.shop;
    });
  }

  // Brings user to battle mode
  void randomBattle() {
    setState(() {
      currentScreen = UIScreen.battle;
      // Move fishy to the right location
      game.fishies[1].fishLocation = FishLocation.battle;
      // Create location variables for and create evilFish
      game.summonEnemyFishy();

      // Create battleinfo and update UI display variables
      battleInfo = new BattleModel(game.fishies[1], game.evilFishies[0]);
      fishyHP = battleInfo.playerHP;
      fishyExp = battleInfo.playerExp;
      enemyFishHP = battleInfo.enemyHP;
      enemyFishName = battleInfo.enemyName;
      battleDialogue = battleInfo.dialogue;
      // Battle starts
    });
  }

  void fightCommand() {
    // Initiate attack animation while disabling buttons
    disableButtons();
    game.fishies[1].fishLocation = FishLocation.attackAnim;

    // Get attack damage, create dialogue var, send fishy to battle location
    battleInfo.damage =
        battleInfo.playerAttack - battleInfo.enemyDefense + rng.nextInt(4);

    // Check for critical hit, deal damage to enemy, create dialogue
    if (rng.nextInt(100) <= battleInfo.playerFishiness) {
      battleInfo.damage = battleInfo.damage * 3;
      battleInfo.dialogue = "Critical hit!!! You dealt " +
          battleInfo.damage.toString() +
          " damage!";
      battleInfo.enemyHP = battleInfo.enemyHP - battleInfo.damage;
    } else {
      battleInfo.dialogue = battleInfo.playerName +
          " nibbled for " +
          battleInfo.damage.toString() +
          " damage!";
      battleInfo.enemyHP = battleInfo.enemyHP - battleInfo.damage;
    }
    updateBattleDialogue();

    // If EnemyFish has less then zero hp
    if (battleInfo.enemyHP <= 0) {
      battleInfo.enemyHP = 0;
      battleInfo.dialogue = "Your fishy won!!!";
      updateBattleDialogue();
      enemyFishDead();
      Future.delayed(const Duration(milliseconds: 5000), () {
        setState(() {
          game.evilFishies.clear();
          game.increaseSize();
          // Go right to the updated experience value -- SHOULD I CHANGE THIS?
          fishyExp = battleInfo.playerExp + battleInfo.enemyHP;
          battleInfo.dialogue = "Your fishy gained experience!";
          updateBattleDialogue();
          game.updateGold(100);
          update();
        });
      });
      Future.delayed(const Duration(milliseconds: 8000), () {
        setState(() {
          toHomeScreen();
        });
      });
      // If the enemy has hp then they take their turn
    } else {
      Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          enemyAttack();
          _buttonsAbsorbed = false;
        });
      });
      enemyFishHP = battleInfo.enemyHP;
    }
  } // End of Fight Commands

  void powerCommand() {
    disableButtons();
    // Get attack damage, create dialogue var, send fishy to battle location
    int playerAttack = game.fishies[1].fishStr -
        game.fishies[1].fishDef +
        rng.nextInt(3);
    // String dialogue;
    game.fishies[1].fishLocation = FishLocation.attackAnim;

    // Check for critical hit, deal damage to enemy, create dialogue
    if (rng.nextInt(100) <= game.fishies[1].fishiness) {
      playerAttack = playerAttack * 3;
      // dialogue =
      //     "Critical hit!!! You dealt " + playerAttack.toString() + " damage!";
      game.evilFishies[0].fishHP = game.evilFishies[0].fishHP - playerAttack;
    } else {
      // dialogue = "Your fish focused it's chi to deal " + playerAttack.toString() + " damage!";
      game.evilFishies[0].fishHP = game.evilFishies[0].fishHP - playerAttack;
    }

    // If EnemyFish still has HP
    if (game.evilFishies[0].fishHP <= 0) {
      enemyFishHP = 0;
      battleInfo.dialogue = "Your fishy won!!!";
      updateBattleDialogue();
      enemyFishDead();
      Future.delayed(const Duration(milliseconds: 5000), () {
        setState(() {
          game.evilFishies.clear();
          game.increaseSize();
          fishyExp = game.fishies[1].fishExp;
          battleInfo.dialogue = "Your fishy gained experience!";
          updateBattleDialogue();
          game.updateGold(100);
          update();
        });
      });
      Future.delayed(const Duration(milliseconds: 8000), () {
        setState(() {
          toHomeScreen();
        });
      });
    } else {
      Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          enemyAttack();
          _buttonsAbsorbed = false;
        });
      });
      enemyFishHP = battleInfo.enemyHP;
    }
  }

  enemyAttack() {
    // Update the enemy fishes position to simulate movement
    game.evilFishies[0].fishStatus = EnemyFishStatus.attacking;
    // Calculate damage
    battleInfo.damage = battleInfo.enemyAttack - battleInfo.playerDefense;
    battleInfo.playerHP = battleInfo.playerHP - battleInfo.damage;
    fishyHP = battleInfo.playerHP;
    enemyFishHP = battleInfo.enemyHP;
    battleInfo.dialogue = "The enemy " +
        battleInfo.enemyName +
        " attacks for " +
        battleInfo.damage.toString() +
        " damage!!!";
    updateBattleDialogue();
  } 
}

