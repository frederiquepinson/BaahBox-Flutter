import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/appController.dart';
import 'package:baahbox/services/bleConnectionPage.dart';
import 'package:baahbox/welcome.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontSize: 25),
          centerTitle: true,
          title: Text("Settings"),
          leading: IconButton(
              icon: Icon( Icons.arrow_back,color: Colors.lightBlueAccent,),
              onPressed: () => Get.to(() => WelcomePage(),)
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              ElevatedButton(
                  onPressed: () => Get.to(() => BleConnectionPage()),
                  child: Text('Connexion settings'))
            ])));
  }
}
