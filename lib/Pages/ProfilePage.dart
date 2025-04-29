import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/TokenManager.dart';
import 'package:flutter_project/Util/MyRoutes.dart';
import 'package:flutter_project/Util/UtilWidgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
   String? _name;
   String? _email;
   String? _profileImg;
   @override
  void initState() {
    super.initState();
    _fetchDetails();
  }
void _fetchDetails() async{
   String? token = await TokenManager.getToken();
    Map<String, dynamic> jwtDecoded = JwtDecoder.decode(token!);
    String? name = jwtDecoded['name'];
    String? email =jwtDecoded['email'];
    String? profileImg =jwtDecoded['profileImg'];
    setState(() {
      _name=name;
      _email=email;
      _profileImg=profileImg;
    });

}
  @override
  @override
  Widget build(BuildContext context) {
    if (_name == null || _email == null || _profileImg == null) {
      return Scaffold(
        appBar: UtilWidgets.buildAppBar(title: 'Trustify', icon: Icons.notifications, context: context,route:MyRoutes.NotificationPage,back: true),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: UtilWidgets.buildAppBar(title: 'Trustify', icon: Icons.notifications, context: context,route:MyRoutes.NotificationPage,back: true),
      body: UtilWidgets.buildBackgroundContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_profileImg!),
                ),
                SizedBox(height: 15),
                Text(
                  _name!,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  _email!,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 109, 190, 231),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    profileTile(Icons.shopping_bag, "My Posts"),
                    Divider(),
                    profileTile(Icons.location_on, "Address"),
                    Divider(),
                    profileTile(Icons.settings, "Settings"),
                    Divider(),
                    profileTile(Icons.help_outline, "Help"),
                    Divider(),
                  ],
                ),
                SizedBox(height: 40),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton(
                      onPressed: _logOut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 109, 190, 231),
                        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }


   Widget profileTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: UtilWidgets.buildText(text: title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        switch (title) {
          case "Help":
            Navigator.pushNamed(context, MyRoutes.HelpPage);
            break;
        }
      },
    );
  }
  void _logOut() async{
    await TokenManager.removeToken();
    Navigator.pushNamedAndRemoveUntil(context, MyRoutes.LoginPage,(route)=>false);

  }
}
