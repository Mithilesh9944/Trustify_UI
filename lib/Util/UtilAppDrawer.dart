import 'package:flutter/material.dart';
import 'package:flutter_project/Util/UtilPages.dart';

class AppDrawer extends StatelessWidget {
  final String imgPath;
  final String email;
  final String mobile_no;
  const AppDrawer({super.key, required this.imgPath,required this.email,required this.mobile_no});
  @override
  Widget build(BuildContext context) {
    final profileImgPath =imgPath!='No img url'?imgPath:"https://cdn1.vectorstock.com/i/1000x1000/93/75/user-blue-icon-isolated-on-white-background-vector-42029375.jpg";
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
                    accountName: Text(email),
                    accountEmail: Text(mobile_no),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(profileImgPath),
                    ),
                ),

              )
            ],
          ),
        ),
    );
  }
}
