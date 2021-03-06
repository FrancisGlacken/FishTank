import 'package:fish_tank/fish_tank_game.dart';
import 'package:fish_tank/fish_tank_ui.dart';
import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'components/objects/models/fish-data.dart';

import 'package:path_provider/path_provider.dart' as path_provider; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open up a gold Box
  final appDocumentsDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentsDirectory.path); 
  Hive.registerAdapter(FishDataAdapter());
  await Hive.openBox<int>("gold_box");
  await Hive.openBox('fishy_box');

  // Create util for fullscreen and set orientation
  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  // Pre load the images right quick
  Flame.images.loadAll(<String>[
    'cheep-red.png',
    'cheep-blue.png',
    'cheep-green.png',
    'cheep-white.png',
    ]);

  // What does this do?
  Flame.audio.disableLog();
  // Pre load audio
  Flame.audio.loadAll(<String>[
  'sfx/bubblebobble11.wav',
  'sfx/bubble-pop-1.wav',
  'sfx/bubble-pop-2.wav'
  ]);

  // Create the game instance and the app
  FishTankUI gameUI = FishTankUI(); 
  FishTankGame game = FishTankGame(gameUI.state);
  gameUI.state.game = game; 
  runApp(game.widget); 

  runApp(
    MaterialApp(
      title: 'Fish Tank',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'HVD',
      ),
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: game.onTapDown,
                child: game.widget,
              ),
            ),
            Positioned.fill(
              child: gameUI,
            ),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );

  // Create gesture reader
  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown;
  flameUtil.addGestureRecognizer(tapper);
}


  