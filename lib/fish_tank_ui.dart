import 'dart:ui';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:fish_tank/fish_tank_game.dart';

class FishTankUI extends StatefulWidget {
  final FishTankUIState state = FishTankUIState(); 

  State<StatefulWidget> createState() => state; 
}

class FishTankUIState extends State<FishTankUI> with WidgetsBindingObserver {
  FishTankGame game;

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
            ],
          ),
        )
      ],
    );
  }

  // Build method for home screen
  Widget buildScreenHome() {
    return Positioned.fill(
      child: Column(
        children: <Widget>[
          feedButton(),
        ],
      )
    );
  }


  Widget feedButton() {
    return Ink(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
        ),
        child: FlatButton(
          onPressed: null,
          padding: EdgeInsets.all(0.0),
          child: Image.asset('assets/images/button-feed.png')
        )
    );
  }
}