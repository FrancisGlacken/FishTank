import 'dart:ui';
import 'dart:math';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fish_tank/fish_tank_game.dart';
import 'package:fish_tank/components/objects/fish.dart';
import 'package:fish_tank/components/objects/enemy_fish.dart';
import 'package:fish_tank/components/objects/fish-mud.dart';

enum UIScreen { home, battle, shop, journey }

class FishTankUI extends StatefulWidget {
  final FishTankUIState state = FishTankUIState();
  State<StatefulWidget> createState() => state;
}

class FishTankUIState extends State<FishTankUI> with WidgetsBindingObserver {
  FishTankGame game;
  SharedPreferences storage;
  UIScreen currentScreen = UIScreen.home;
  Random rng = new Random();
  int fishyHP, enemyFishHP, fishyExp;
  String battleDialogue = "A wild Mud Fish appeared!!!";
  String fishName = ""; 
  bool buttonsAbsorbed = false;

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
        Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: selectedFishView(),
          )
        ),
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
      hpView(),
      expView(),
      enemyHPView(),
      battleDialogView(),
      AbsorbPointer(
        absorbing: buttonsAbsorbed,
        child: Container(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Table(
                  children: [
                    TableRow(children: [fightButton(), powerButton()]),
                    TableRow(children: [itemsButton(), fleeButton()]),
                  ],
                ))),
      )
    ]));
  }

  Widget buildScreenShop() {
    return Positioned.fill(
        child: Center(
            child: Container(
      color: Colors.grey[600],
      child: Stack(
        children: <Widget>[
          Table(children: [
            TableRow(children: [shopRedFishButton(), shopBlueFishButton()]),
            TableRow(children: [shopGreenFishButton(), shopPurpleFishButton()]),
            TableRow(children: [signExitButton(), signExitButton()])
          ]),
          
        ],
      ),
    )));
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
              'assets/images/fish-button-circle.png',
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
              'assets/images/fish-button-circle.png',
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
              'assets/images/fish-button-circle.png',
              width: 50,
              height: 50,
            )));
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
        FishStyle style = FishStyle.red; 
        game.summonFishy(style);
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
        FishStyle style = FishStyle.blue; 
        game.summonFishy(style);
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
        FishStyle style = FishStyle.green; 
        game.summonFishy(style);
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
        FishStyle style = FishStyle.purple; 
        game.summonFishy(style);
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
              'assets/images/fish-button-circle.png',
              width: 50,
              height: 50,
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
              'assets/images/fish-button-circle.png',
              width: 50,
              height: 50,
            )));
  }

  // button for items
  Widget itemsButton() {
    return Ink(
        decoration: ShapeDecoration(
          shape: CircleBorder(),
        ),
        child: FlatButton(
            onPressed: () {},
            padding: EdgeInsets.all(0.0),
            child: Image.asset(
              'assets/images/fish-button-circle.png',
              width: 50,
              height: 50,
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
              'assets/images/fish-button-circle.png',
              width: 50,
              height: 50,
            )));
  }

  // Views //
  
  // Displays selected fishName
  Widget selectedFishView() {
    return Text(
        fishName,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 20,
          color: Color(0xffffffff),
        )
    );
  }

  // Widget for displaying battle dialogue
  Widget battleDialogView() {
    return Positioned(
      width: game.screenSize.width,
      bottom: 120,
      child: Text(
        battleDialogue,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 20,
          color: Color(0xffffffff),
        ),
      ),
    );
  }

  // view for Hp
  Widget hpView() {
    return Align(
        alignment: Alignment.topLeft,
        child: Text(
            fishyHP.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              color: Color(0xffffffff),
            )));
  } //game.fishies[0].fishHP.toString()

  // view for HP
  Widget enemyHPView() {
    return Align(
        alignment: Alignment.topRight,
        child: Text(
            enemyFishHP.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              color: Color(0xffffffff),
            )));
  }

  // view for growRate
  Widget expView() {
    return Align(
        alignment: Alignment.topCenter,
        child: Text(
          fishyExp.toString(),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            color: Color(0xffffffff),
          ),
        ));
  }

  // End of Views //
  // Home Stuff

  void feedFishy() {
    setState(() {
      game.summonFood();
    });
  }

  // Battle Stuff
  void disableButtons() {
    setState(() => buttonsAbsorbed = true);
  }

  void enableButtons() {
    setState(() => buttonsAbsorbed = false);
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

  void updateSelectedFishyName() {
    setState(() {
      fishName = game.selectedFishName; 
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
      game.evilFishies.add(MudFish(game, x, y));
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
    int playerAttack = game.fishies[game.selFishId].fishStr - game.fishies[game.selFishId].fishDef + rng.nextInt(3);
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
          updateBattleDialogue(battleDialogue = "Your fishy gained experience!");
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
          buttonsAbsorbed = false;
        });
      });
      enemyFishHP =  game.evilFishies[0].fishHP;
      updateBattleDialogue(dialogue);
    }
  } // End of Fight Commands

  enemyAttack() {
    int enemyAttack = game.evilFishies[0].fishStr - game.fishies[game.selFishId].fishDef;
    String dialogue;
    game.fishies[game.selFishId].fishHP = game.fishies[game.selFishId].fishHP - enemyAttack;
    fishyHP = game.fishies[game.selFishId].fishHP;
    enemyFishHP = game.evilFishies[0].fishHP;
    dialogue = "The enemy attacks for " + enemyAttack.toString() + " damage!!!";
    updateBattleDialogue(dialogue);
    game.evilFishies[0].fishStatus = EnemyFishStatus.attacking;
  }
}


// Junkyard

// Top row
// Widget fishformationBar() {
//   return Padding(
//       padding: EdgeInsets.only(top: 5, left: 5, right: 15),
//       child: Row(children: <Widget>[]));
// }

  // void increaseSize() {
  //   setState(() {
  //     game.fishies.forEach((Fish fishy) {
  //       if (fishy.fishSelected) {
  //         fishy.growRate = fishy.growRate + (fishy.growRate * .1);
  //         fishy.fishSizeMulti = fishy.fishSizeMulti * fishy.growRate;
  //       }
  //     }); 
  //   });
  // }
