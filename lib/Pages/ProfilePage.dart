import 'package:flutter/material.dart';
import 'package:flutter_project/Security/TokenManager.dart';
import 'package:flutter_project/Util/MyRoutes.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 109, 190, 231),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centering all items
          children: [
            SizedBox(height: 30),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
              _profileImg!// Replace with user profile image
              ),
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
            Center( // Wrap the button in the Center widget for alignment
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
            // List of profile items
            ListView(
              shrinkWrap: true, // Prevent it from taking up all available space
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
            // Wrap the Log Out button in Center widget
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: _logOut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 109, 190, 231), // Blue background
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
    );
  }

  Widget profileTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Add navigation or actions here
      },
    );
  }
  void _logOut() async{
    await TokenManager.removeToken();
    Navigator.pushNamed(context, MyRoutes.LoginPage);

  }
}
