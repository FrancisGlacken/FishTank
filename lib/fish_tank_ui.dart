import 'dart:ui';
import 'dart:math';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fish_tank/fish_tank_game.dart';
import 'package:fish_tank/components/objects/fish.dart';
import 'package:fish_tank/components/objects/enemy_fish.dart';
import 'package:fish_tank/components/objects/fish-mud.dart';

class FishTankUI extends StatefulWidget {
  final FishTankUIState state = FishTankUIState();
  State<StatefulWidget> createState() => state;
}

class FishTankUIState extends State<FishTankUI> with WidgetsBindingObserver {
  FishTankGame game;
  SharedPreferences storage;
  UIScreen currentScreen = UIScreen.home;
  Random rng = new Random();
  int enemyFishHP;
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
                  border: TableBorder.all(),
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
              game.fishies[0].fishLocation = FishLocation.feed;
              feedFishy();
            },
            padding: EdgeInsets.all(0.0),
            child: Image.asset(
              'assets/images/button-feed.png',
              width: game.tileSize * 3,
              height: 70,
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
              'assets/images/button-consume.png',
              width: game.tileSize * 3,
              height: 70,
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
              'assets/images/button-journey.png',
              width: game.tileSize * 3,
              height: 70,
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
              'assets/images/button-fight-2.png',
              width: game.tileSize * 4.5,
              height: 100,
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
              'assets/images/button-feed.png',
              width: game.tileSize * 4.5,
              height: 100,
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
              'assets/images/button-fight-2.png',
              width: game.tileSize * 4.5,
              height: 100,
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
              'assets/images/button-fight-2.png',
              width: game.tileSize * 4.5,
              height: 100,
            )));
  }

  // Views //

  // Widget for displaying battle dialogue
  Widget battleDialogView() {
    return Positioned(
      width: game.screenSize.width,
      bottom: 200,
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
        child: Text("100",
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
        child: Text(enemyFishHP.toString(),
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
          game.growRate.toString(),
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

  void increaseSize() {
    setState(() {
      game.growRate = game.growRate + (game.growRate * .1);
      game.fishies[0].fishSizeMulti =
          game.fishies[0].fishSizeMulti * game.growRate;
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
  void updateBattleDialogue(String dialogue, enemyHP) {
    setState(() {
      enemyFishHP = enemyHP;
      battleDialogue = dialogue;
    });
  }

  void updateSelectedFishyName() {
    setState(() {
      game.fishies.forEach((Fish fishy) {
        if (fishy.fishSelected) {
          fishName = fishy.fishName; 
        }
      });
      
    }); 
  }

  // Brings user to battle mode
  void randomBattle() {
    setState(() {
      game.fishies[0].fishLocation = FishLocation.battle;
      // What are these variables doing lol
      // I think we need this to maintain the grid for different phone sizes
      double x = .8 * (game.screenSize.width - game.tileSize);
      double y = .4 * (game.screenSize.height - game.tileSize);
      game.evilFishies.add(MudFish(game, x, y));
      enemyFishHP = game.evilFishies[0].fishHP;
      currentScreen = UIScreen.battle;
      // Battle starts
    });
  }

  // Brings user back to home screen.
  void toHomeScreen() {
    setState(() {
      game.fishies[0].fishLocation = FishLocation.home;
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

  fightCommand() {
    disableButtons();
    // Get attack damage
    Fish goodFish = game.fishies[0];
    EnemyFish evilFish = game.evilFishies[0];
    int playerAttack = goodFish.fishStr - evilFish.fishDef + rng.nextInt(3);
    String dialogue;

    game.fishies[0].fishLocation = FishLocation.attackAnim;

    if (rng.nextInt(100) <= game.fishies[0].fishiness) {
      playerAttack = playerAttack * 3;
      dialogue =
          "Critical hit!!! You dealt " + playerAttack.toString() + " damage!";
      evilFish.fishHP = evilFish.fishHP - playerAttack;
    } else {
      dialogue = "You dealt " + playerAttack.toString() + " damage!";
      evilFish.fishHP = evilFish.fishHP - playerAttack;
    }

    // Update out fishies
    goodFish = game.fishies[0];
    evilFish = game.evilFishies[0];
    if (evilFish.fishHP <= 0) {
      updateBattleDialogue(battleDialogue = "Your fishy won!!!", 0);
      enemyFishDead();
      Future.delayed(const Duration(milliseconds: 5000), () {
        setState(() {
          game.evilFishies.clear();
          increaseSize();
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
      updateBattleDialogue(dialogue, game.evilFishies[0].fishHP);
    }
  } // End of Fight Commands

  enemyAttack() {
    int enemyAttack = game.evilFishies[0].fishStr - game.fishies[0].fishDef;
    String dialogue;
    game.fishies[0].fishHP = game.fishies[0].fishHP - enemyAttack;
    dialogue = "The enemy attacks for " + enemyAttack.toString() + " damage!!!";
    updateBattleDialogue(dialogue, game.evilFishies[0].fishHP);
    game.evilFishies[0].fishStatus = EnemyFishStatus.attacking;
  }
}

enum UIScreen { home, battle, shop, journey }

// Junkyard

// Top row
Widget fishformationBar() {
  return Padding(
      padding: EdgeInsets.only(top: 5, left: 5, right: 15),
      child: Row(children: <Widget>[]));
}
