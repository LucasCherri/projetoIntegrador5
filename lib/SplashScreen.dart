import 'package:flutter/material.dart';
import 'package:front_projeto_quintoandar/Error/NetErrorPage.dart';
import 'package:front_projeto_quintoandar/FirstPage.dart';
import 'package:front_projeto_quintoandar/Settings/Navbar.dart';
import 'package:front_projeto_quintoandar/chat/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:zego_zimkit/services/services.dart';

import 'Settings/db.dart';

void main() {
  ZIMKit().init(
      appID: Utils.id,
    appSign: Utils.SignIn
  );
  runApp(
    MaterialApp(
      locale: const Locale('pt', 'BR'),
      home: Splash(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class Splash extends StatefulWidget{
  const Splash({Key? key}) : super(key: key);
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin{
  late AnimationController controller;


  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NetErrorPage()),);
    }else{
      if (email != null) {
        var db = await Db.getConnection();
        var col = db.collection('user');
        var doc = await col.findOne(mongo.where.eq('email', email));
        var name = doc!['nome'];
        await ZIMKit().connectUser(id: email, name: name);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => navbar(user: doc)),);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => firstpage()),
        );
      }
    }
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    controller.repeat(reverse: true);

    Future.delayed(Duration(seconds: 5), () {
      if (mounted){
        checkLoginStatus();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color(0xFF003049),
        body: Stack(
          children: [
            Container(
                padding: EdgeInsets.only(top: 150),
                child: Column(
                  children: [
                    SizedBox(
                      width: 250,
                      height: 120,
                      child: OverflowBox(
                        minHeight: 170,
                        maxHeight: 170,
                        child: Lottie.asset('assets/119723-3d-skyline-building.json',
                        width: 250,
                        height: 150,
                        alignment: Alignment.center
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "TRIPLEX",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Form(
                      child: Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.38),
                        child: Column(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Para você alugar",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Para você comprar",
                                        style: TextStyle(
                                          fontSize: 36,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  LinearProgressIndicator(
                                    value: controller.value,
                                    minHeight: 40,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}