import 'package:flutter/material.dart';
import 'package:flutter_project/Util/MyRoutes.dart';
import 'package:flutter_project/Util/UtilPages.dart';
import 'package:flutter_project/Util/util_notification.dart';
import 'package:google_fonts/google_fonts.dart';

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
          child: Text('Help  ', style: GoogleFonts.poppins(
            //color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),),
        ),
    ];
  }

  static void navigateTo({required BuildContext context,required String route}){
    Navigator.pushReplacementNamed(context,route );
  }

  static AppBar buildAppBar({required String title,required IconData icon,required BuildContext context,required String route}) {
    return AppBar(
      // leading: IconButton(
      //   onPressed: () {Navigator.of(context).pop();},
      //   icon: Icon(Icons.arrow_back),
      // ),
      automaticallyImplyLeading: false,
      title: Text(title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          //fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: UtilitiesPages.APP_BAR_COLOR,
      actions: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, route);
          },
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
      //backgroundColor: UtilitiesPages.pageColor,
      //currentIndex: selectedTabPosition,
      onTap:(index) {
            switch (index) {
              case 0:
                Navigator.push(context,MaterialPageRoute(builder: (context)=>MyNotification()));
                break;
              case 1:
                Navigator.pushNamed(context, MyRoutes.Dashboard);
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
      //selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black87,
      selectedLabelStyle:GoogleFonts.poppins(
        //color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        //color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_sharp ,color: UtilitiesPages.APP_BAR_COLOR,), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.chat,color: UtilitiesPages.APP_BAR_COLOR), label: 'Chats'),
        BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.favorite,color: UtilitiesPages.APP_BAR_COLOR), label: 'My Ads'),
        BottomNavigationBarItem(icon: Icon(Icons.person,color: UtilitiesPages.APP_BAR_COLOR), label: 'Profile'),
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
      child: Icon(
        Icons.add,
        size: 50,
        color:UtilitiesPages.APP_BAR_COLOR,
      ),
    );
  }
  
  static Text buildText({required String text}){
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: Colors.black87,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

}
