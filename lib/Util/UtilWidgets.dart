import 'package:flutter/material.dart';
import 'package:flutter_project/Util/MyRoutes.dart';
import 'package:flutter_project/Util/UtilPages.dart';

class UtilWidgets{
  static Widget buildBackgroundContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [UtilitiesPages.pageColor, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.4, 0.9],
          tileMode: TileMode.clamp,
        ),
      ),
      child: child,
    );
  }

  static List<Widget> buildHelpWidgetAppBar (BuildContext context){
    return <Widget>[
        IconButton(onPressed: () {navigateTo(context: context, route: MyRoutes.HelpPage);}, icon: Icon(Icons.help_outline_rounded)),
        TextButton(
          onPressed: () {navigateTo(context: context, route: MyRoutes.HelpPage);},
          child: Text('Help  ', style: TextStyle(fontSize: 20)),
        ),
    ];
  }

  static void navigateTo({required BuildContext context,required String route}){
    Navigator.pushNamed(context,route );
  }

  static AppBar buildAppBar({required String title,required IconData icon,required BuildContext context}) {
    return AppBar(
      // leading: IconButton(
      //   onPressed: () {Navigator.of(context).pop();},
      //   icon: Icon(Icons.arrow_back),
      // ),
      title: Text(title),
      backgroundColor: UtilitiesPages.pageColor,
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: Icon(icon),
        ),
      ],
    );
  }
  
  static void showSnackBar({required String msg,required BuildContext context}){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
  

}