import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/WelcomePage.dart';
import 'package:flutter_project/Util/UtilPages.dart';
import 'package:flutter_project/Util/util_notification.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
   @override
  void initState() {
    super.initState();
    // Delay for 1200 miliseconds, then navigate to Welcome page
    notificationPermission();
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyWelcome()), // Push Welcome page
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildImage() {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.1, end: 1.0), // scale from 0.8x to 1.0x
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Image.asset('assets/openPage3.png'),
          );
        },
      );
    }
    // Widget _buildImage() {
    //   return Image.asset('assets/openPage3.png');
    // }
    return Container(
            decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 116, 195, 234), Color.fromARGB(255, 255, 255, 255)],
             begin: Alignment.topLeft,
            end: Alignment.bottomRight,
              stops: [0.4,0.9],
              tileMode: TileMode.clamp,
            )),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: UtilitiesPages.LEFT,
          vertical: UtilitiesPages.TOP,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildImage(),
            SizedBox(height: UtilitiesPages.SIZE_BOX_HEIGHT),
          ],
        ),
      ),
    );
  }
}

