import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:baahbox/routes/routes.dart';
import 'package:baahbox/constants/enums.dart';
import 'dart:ui';


class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final  mainColor = BBColor.pinky.color;
    final Controller c = Get.put(Controller());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: mainColor,
              fontWeight: FontWeight.bold,
              fontSize: 25),
          centerTitle: true,
          title: Text("Baah !"),
          actions: [
            Container(
                width: 25,
                child:
               Image.asset('assets/images/Dashboard/demo@2x.png', color: mainColor)
            ),
            SizedBox(width: 15,),

            IconButton(icon: Image.asset('assets/images/Dashboard/settings_icon@2x.png', color: mainColor),
                onPressed: () => Get.toNamed('/settings')
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GameRow(BBGame.star, BBRoute.star.path),
                GameRow(BBGame.balloon, BBRoute.balloon.path),
                GameRow(BBGame.sheep, BBRoute.sheep.path),
                GameRow(BBGame.starship, BBRoute.spaceShip.path),
                GameRow(BBGame.toad, BBRoute.toad.path),
              ]
              //wrap
              ),
        ));
  }
}

class GameRow extends StatelessWidget {

  GameRow(this.game, this.gamePath);
  final String gamePath;
  final BBGame game;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(game.baseColor.color)),
        child: Container(
            alignment: Alignment.centerLeft,
            height: 100,
            width: 400,
            child: Row(//mainAxisAlignment: MainAxisAlignment.start,
                children: [
              Image(
                  alignment: Alignment.centerLeft,
                  image: AssetImage(game.mainAsset)),
              Spacer(),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      game.title,
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.end,
                      textScaleFactor: 2.0,
                    ),
                    SizedBox(height: 10),
                    Image(
                      alignment: Alignment.bottomRight,
                      image: AssetImage('assets/images/Dashboard/capteur.png'),
                      height: 25,
                      width: 25,
                    )
                  ])
            ])),
        onPressed: () => Get.toNamed(gamePath));
  }
}
