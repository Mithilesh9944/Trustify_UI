import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/Util/UtilPages.dart';

class AppDrawer extends StatelessWidget {
  final String imgPath;
  const AppDrawer({super.key, required this.imgPath});

  @override
  Widget build(BuildContext context) {
    final profileImgPath ="assets/profile.jpg";
    return Drawer(
        child: Container(
            color: UtilitiesPages.pageColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                child: UserAccountsDrawerHeader(
                    margin: EdgeInsets.zero,
                    accountName: Text("Mithilesh Sahu"),
                    accountEmail: Text("mithi@gmail.com"),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage(profileImgPath),
                    ),
                ),

              )
            ],
          ),
        ),
    );
  }
}
