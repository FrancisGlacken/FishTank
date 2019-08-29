import 'dart:ui';
import 'dart:math';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fish_tank/fish_tank_game.dart';
import 'package:fish_tank/components/objects/fish.dart';
import 'package:fish_tank/components/objects/enemy_fish.dart';
import 'package:fish_tank/components/objects/cheep-blue.dart';

class FishTankUI extends StatefulWidget {
  final FishTankUIState state = FishTankUIState();

  //TODO: Create bubbles that fly in background

  State<StatefulWidget> createState() => state;
}

class FishTankUIState extends State<FishTankUI> with WidgetsBindingObserver {
  FishTankGame game;
  SharedPreferences storage;
  UIScreen currentScreen = UIScreen.home;
  Random rng = new Random(); 
  int enemyFishHP; 
  String battleDialogue = "A wild Cheep Cheep appeared!!!"; 

  void decreaseHealth() {
    //setState(() => game.fishies[0].fishHP = game.fishies[0].fishHP - 10);
  }

  void increaseSize() {
    setState(() {
      game.growRate = game.growRate * 1.1;
      game.fishies[0].fishSizeMulti =
          game.fishies[0].fishSizeMulti * game.growRate;
    });
  }

  void updateBattleDialogue(String dialogue, enemyHP) {
    setState(() {
      enemyFishHP = enemyHP; 
      battleDialogue = dialogue; 
    }); 
  }

  void randomBattle() {
    setState(() {
      game.fishies[0].fishLocation = FishLocation.battle;
      // What are these variables doing lol
      // I think we need this to maintain the grid for different phone sizes
      double x = .8 * (game.screenSize.width - game.tileSize);
      double y = .4 * (game.screenSize.height - game.tileSize);
      game.evilFishies.add(CheepBlue(game, x, y));
      enemyFishHP = game.evilFishies[0].fishHP;
      currentScreen = UIScreen.battle;
    });
  }

  void toHomeScreen() {
    setState(() {
      game.fishies[0].fishLocation = FishLocation.home;
      game.evilFishies.clear();
      battleDialogue = "A wild Cheep Cheep appeared!!!"; 
      currentScreen = UIScreen.home;
    });
  }

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
        fishformationBar(),
        expView(),
        Expanded(
          child: IndexedStack(
            sizing: StackFit.expand,
            children: <Widget>[buildScreenHome(), buildScreenBattle()],
            index: currentScreen.index,
          ),
        )
      ],
    );
  }

  // Top row
  Widget fishformationBar() {
    return Padding(
        padding: EdgeInsets.only(top: 5, left: 5, right: 15),
        child: Row(children: <Widget>[
          hpView(),
        ]));
  }

  // Build method for home screen
  Widget buildScreenHome() {
    return Positioned.fill(
        child: Stack(
      children: <Widget>[
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
        enemyHPView(),
        battleDialogView(),
        Container(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Table(
                border: TableBorder.all(),
                children: [
                  TableRow(children: [fightButton(), fleeButton()]),
                  TableRow(children: [fleeButton(), fleeButton()]),
                ],
              )))
    ]));
  }

  // Widget for displaying battle dialogue
  Widget battleDialogView() {
    return Positioned(
      width: game.screenSize.width,
      bottom: 200,
      child: Text(battleDialogue, 
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 20,
        color: Color(0xffffffff),
      ),
        
      ),
    );
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
              increaseSize();
            },
            padding: EdgeInsets.all(0.0),
            child: Image.asset(
              'assets/images/button-feed.png',
              width: 140,
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
              width: 140,
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
              decreaseHealth();
            },
            padding: EdgeInsets.all(0.0),
            child: Image.asset(
              'assets/images/button-journey.png',
              width: 140,
              height: 70,
            )));
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
              'assets/images/button-fight.png',
              width: 140,
              height: 70,
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
              'assets/images/button-fight.png',
              width: 140,
              height: 70,
            )));
  }




  // Views //

  // view for Hp
  Widget hpView() {
    return Align(
        alignment: Alignment.topLeft,
        child: Text(game.fishies[0].fishHP.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              color: Color(0xffffffff),
            )));
  }

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


  // Battle Stuff

  fightCommand() {
    // Get attack damage
    int playerAttack = game.fishies[0].fishStr - game.evilFishies[0].fishDef; 
    String dialogue; 

    game.fishies[0].fishLocation = FishLocation.attackAnim; 
    delayBySeconds(3); 

    if (rng.nextInt(100) <= game.fishies[0].fishiness) {
      playerAttack = playerAttack * 3; 
      dialogue = "Critical hit!!! You dealt " + playerAttack.toString() + " damage!"; 
    } else {
      dialogue = "You dealt " + playerAttack.toString() + " damage!"; 
    }
    
    // if enemyHP is less then 0 then clear him off screen and go to some reward screen
    Future<void> delayThis() {
      return Future.delayed(Duration(seconds: 3), () {
        updateBattleDialogue(dialogue, 
                            game.evilFishies[0].fishHP 
                            = game.evilFishies[0].fishHP - playerAttack);
      });
    }
    Future<void> delayThisToo() {
      return Future.delayed(Duration(seconds: 3), () {
        enemyAttack(); 
      });
    }
  }

  enemyAttack() {
    updateBattleDialogue("lets go champ", 50);
  }

  Future<void> delayBySeconds(int sec) {
    return Future.delayed(Duration(seconds: sec), () => print('Large Latte'));
  }
}

enum UIScreen { home, battle, journey }
