import 'package:flutter/material.dart';
import 'dart:async';

import '../DatabaseHandler/api_db_provider.dart';
import 'LoginForm.dart';
import 'TaskForm.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = Duration(seconds: 5);
    return new Timer(duration, route);
  }

  route() async {
    MyStorageFunctions storageFunctions = MyStorageFunctions();

    Map<String, String> storageInfo = await storageFunctions.readStorageInfo();
    print(storageInfo);
    String? sessionToken = storageInfo['session_token'];

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                sessionToken != '' ? const TaskForm() : LoginForm()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(243, 243, 243, 1),
                gradient: LinearGradient(colors: [
                  (Color.fromRGBO(243, 243, 243, 1)),
                  Color.fromRGBO(243, 243, 243, 1)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(
                    "assets/images/sandra_loader.gif",
                    width: 150,
                    height: 150,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Container(
                //     child: Text(
                //   "EDILAC LIVRAISON",
                //   style: TextStyle(
                //       color: Colors.black,
                //       fontSize: 40,
                //       fontWeight: FontWeight.bold),
                // )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
