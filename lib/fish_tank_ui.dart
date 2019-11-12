import 'dart:ui';
import 'dart:math';
import 'package:fish_tank/components/objects/fish-bullet.dart';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fish_tank/fish_tank_game.dart';
import 'package:fish_tank/components/objects/fish.dart';
import 'package:fish_tank/components/objects/enemy_fish.dart';
import 'package:fish_tank/components/objects/fish-mud.dart';
import 'package:fish_tank/components/views/BattleDialogueView.dart';
import 'package:fish_tank/components/views/EnemyHPView.dart';
import 'package:fish_tank/components/views/EnemyNameView.dart';
import 'package:fish_tank/components/views/ExpView.dart';
import 'package:fish_tank/components/views/GoldView.dart';
import 'package:fish_tank/components/views/HPView.dart';
import 'package:fish_tank/components/views/SelectedFishNameView.dart';

enum UIScreen { home, battle, shop, journey }

class FishTankUI extends StatefulWidget {
  final FishTankUIState state = FishTankUIState();
  State<StatefulWidget> createState() => state;
}

class FishTankUIState extends State<FishTankUI> with WidgetsBindingObserver {

  //CLEAN UP THESE VARIABLES
  FishTankGame game;
  SharedPreferences storage;
  UIScreen currentScreen = UIScreen.home;
  Random rng = new Random();
  int fishyHP, enemyFishHP, fishyExp = 0;
  String battleDialogue = "A wild Mud Fish appeared!!!";
  String fishName = "", enemyFishName = ""; 
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
        if (_fishySelected) Container(child: new SelectedFishNameView(fishName: fishName)),
        if (_fishySelected) Container(child: new ExpView(fishyExp: fishyExp)),
        if (_fishySelected) Container(child: new HPView(fishyHP: fishyHP)),
        Container(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: feedButton(),
          ),
        ),
        Container(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: consumeButton(),
          ),
        ),
        Container(
          child: Align(
            alignment: Alignment.bottomRight,
            child: journeyButton(),
          ),
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
      )
    ]));
  }

  Widget buildScreenShop() {
    return Center(
            child: Container(
      color: Colors.grey[600],
      child: Stack(
        children: <Widget>[
          Table(children: [
            TableRow(children: [new GoldView(game: game), buyButton()]),
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
    return Ink(
        decoration: ShapeDecoration(
          shape: CircleBorder(),
        ),
        child: FlatButton(
            onPressed: () {
              game.fishies[game.selFishId].fishLocation = FishLocation.feed;
              feedFishy();
            },
            padding: EdgeInsets.all(0.0),
            child: Image.asset(
              'assets/images/ui-button-fight.png',
              width: 50,
              height: 50,
            )));
  }

  // button for Consume
  Widget consumeButton() {
    return Ink(
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
            )));
  }

  // button for Journey
  Widget journeyButton() {
    return Ink(
        decoration: ShapeDecoration(
          shape: CircleBorder(),
        ),
        child: FlatButton(
            onPressed: () {
              toShopScreen();
            },
            padding: EdgeInsets.all(0.0),
            child: Image.asset(
              'assets/images/ui-button-fight.png',
              width: 50,
              height: 50,
            )));
  }

  Widget buyButton() {
    return FlatButton(
      onPressed: () {
        //blah
      },
      padding: EdgeInsets.all(0.0),
      child: Image.asset(
        'assets/images/cheep-white-right.png',
        width: game.tileSize * 3,
        height: 70,
      ),
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
        if (game.gold >= 400) {
          FishStyle style = FishStyle.red;
          updateGold(-400);
          game.summonFishy(style);
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
        if (game.gold >= 400) {
          FishStyle style = FishStyle.blue;
          updateGold(-400);
          game.summonFishy(style);
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
        if (game.gold >= 400) {
          FishStyle style = FishStyle.green;
          updateGold(-400);
          game.summonFishy(style);
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
        if (game.gold >= 400) {
          FishStyle style = FishStyle.purple;
          updateGold(-400);
          game.summonFishy(style);
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
            onPressed: () {},
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


  // Widget for displaying battle dialogue

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
  void updateBattleDialogue(String dialogue) {
    setState(() {
      battleDialogue = dialogue;
    });
  }

  // Update the number for gold
  void updateGold(int gil) {
    setState(() {
      game.gold += gil;
    });
  }

  // Update the view with selected fishy name
  void updateSelectedFishyName() {
    setState(() {
      _fishySelected = true; 
      fishyExp = game.fishies[game.selFishId].fishExp; 
      fishyHP = game.fishies[game.selFishId].fishHP; 
      fishName = game.selectedFishName;
      enemyFishName = game.evilFishies[0].fishName;
    });
  }

  // Brings user back to home screen.
  void toHomeScreen() {
    setState(() {
      if (game.selFishId != null) {
        game.fishies[game.selFishId].fishLocation = FishLocation.home;
      }
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
      game.fishies[game.selFishId].fishLocation = FishLocation.battle;
      // Create location variables for and create evilFish
      double x = .8 * (game.screenSize.width - game.tileSize);
      double y = .4 * (game.screenSize.height - game.tileSize);
      Random rng = new Random();
      if (rng.nextDouble() < .5) {
        game.evilFishies.add(MudFish(game, x, y, game.tileSize, game.tileSize));
        enemyFishName = "MudFish";
      } else {
        game.evilFishies.add(BulletFish(game, x, y, game.tileSize * 2, game.tileSize));
        enemyFishName = "Bulletfish";
      }
      fishyHP = game.fishies[game.selFishId].fishHP;
      fishyExp = game.fishies[game.selFishId].fishExp;
      enemyFishHP = game.evilFishies[0].fishHP;
      currentScreen = UIScreen.battle;
      // Battle starts
    });
  }

  void fightCommand() {
    disableButtons();
    // Get attack damage, create dialogue var, send fishy to battle location
    int playerAttack = game.fishies[game.selFishId].fishStr -
        game.fishies[game.selFishId].fishDef +
        rng.nextInt(3);
    String dialogue;
    game.fishies[game.selFishId].fishLocation = FishLocation.attackAnim;

    // Check for critical hit, deal damage to enemy, create dialogue
    if (rng.nextInt(100) <= game.fishies[game.selFishId].fishiness) {
      playerAttack = playerAttack * 3;
      dialogue =
          "Critical hit!!! You dealt " + playerAttack.toString() + " damage!";
      game.evilFishies[0].fishHP = game.evilFishies[0].fishHP - playerAttack;
    } else {
      dialogue = "You dealt " + playerAttack.toString() + " damage!";
      game.evilFishies[0].fishHP = game.evilFishies[0].fishHP - playerAttack;
    }

    // If EnemyFish still has HP
    if (game.evilFishies[0].fishHP <= 0) {
      enemyFishHP = 0;
      updateBattleDialogue(battleDialogue = "Your fishy won!!!");
      enemyFishDead();
      Future.delayed(const Duration(milliseconds: 5000), () {
        setState(() {
          game.evilFishies.clear();
          game.increaseSize();
          fishyExp = game.fishies[game.selFishId].fishExp;
          updateBattleDialogue(
              battleDialogue = "Your fishy gained experience!");
          updateGold(100);
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
      enemyFishHP = game.evilFishies[0].fishHP;
      updateBattleDialogue(dialogue);
    }
  } // End of Fight Commands

  enemyAttack() {
    int enemyAttack =
        game.evilFishies[0].fishStr - game.fishies[game.selFishId].fishDef;
    String dialogue;
    game.fishies[game.selFishId].fishHP =
        game.fishies[game.selFishId].fishHP - enemyAttack;
    fishyHP = game.fishies[game.selFishId].fishHP;
    enemyFishHP = game.evilFishies[0].fishHP;
    dialogue = "The enemy attacks for " + enemyAttack.toString() + " damage!!!";
    updateBattleDialogue(dialogue);
    game.evilFishies[0].fishStatus = EnemyFishStatus.attacking;
  }
}


// Junkyard
