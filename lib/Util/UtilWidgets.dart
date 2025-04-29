import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/ChatListPage.dart';
import 'package:flutter_project/Util/MyRoutes.dart';
import 'package:flutter_project/Util/UtilPages.dart';
import 'package:flutter_project/Util/util_notification.dart';

class UtilWidgets {
  static Widget buildBackgroundContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [UtilitiesPages.pageColor,
            UtilitiesPages.pageColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.4,0.9],
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

  static Widget createBottomNavigation({
    required int selectedTabPosition,
    required void Function(int index) onTap,
    required BuildContext context,
  }) {
    return BottomNavigationBar(
      backgroundColor: UtilitiesPages.pageColor,
      currentIndex: selectedTabPosition,
      onTap:(index) {
            switch (index) {
              case 0:
                Navigator.push(context,MaterialPageRoute(builder: (context)=>MyNotification()));
                break;
              case 1:
                Navigator.push(context,MaterialPageRoute(builder: (context) => ChatListPage()),);
                break;
              case 2:
                Navigator.pushNamed(context, MyRoutes.CategoryPage);
                break;
              case 3:
                Navigator.pushNamed(context, MyRoutes.Dashboard);
                break;
              case 4:
                Navigator.pushNamed(context, MyRoutes.Profile);
                break;
            }
          },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.white,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_sharp ,), label: 'Home' ),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
        BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'My Ads'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  static Widget createFloatingActionButton({
    required BuildContext context,
    required VoidCallback onTabChange,
  }){
    return FloatingActionButton(
      onPressed: () {
        onTabChange();
        Navigator.pushNamed(context, MyRoutes.CategoryPage);
      },
      child: const Icon(
        Icons.add,
        size: 50,
      ),
    );
  }

}
