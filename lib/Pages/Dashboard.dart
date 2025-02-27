import 'package:flutter/material.dart';
import 'package:flutter_project/Util/UtilAppDrawer.dart';
import 'package:flutter_project/Util/UtilPages.dart';
import 'package:flutter_project/Util/UtilWidgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../Util/MyRoutes.dart';

class Dashboard extends StatefulWidget {
  final String token;

  const Dashboard({super.key, required this.token});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String email;
  late String mobile_no;
  late String img_url;
  int _selectedTabPosition = 0;

  @override
  void initState() {
    super.initState();
    try {
      Map<String, dynamic> jwtDecoded = JwtDecoder.decode(widget.token);
      email = jwtDecoded['email'] ?? 'No Email';
      mobile_no = jwtDecoded['mobile_no'] ?? 'No Mobile Number';
      img_url = jwtDecoded['img_url'] ?? 'No img url';

    } catch (e) {
      email = 'Invalid Token';
      mobile_no = 'Invalid Token';
      img_url='Invalid url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UtilWidgets.buildAppBar(
          title: 'Home', icon: Icons.chat_outlined, context: context),
      body: UtilWidgets.buildBackgroundContainer(
        child: Padding(
          padding: UtilitiesPages.buildPadding(context),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  mobile_no,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: AppDrawer(imgPath:img_url ,email: email,mobile_no: mobile_no,),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 200, 240, 250),
        currentIndex: _selectedTabPosition,
        onTap: (index) {
          if (index != 2) {
            setState(() {
              _selectedTabPosition = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.black12,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chats',
              backgroundColor: Colors.transparent),
          BottomNavigationBarItem(icon: SizedBox.shrink(), label: 'Sell'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'My Ads'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedLabelStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlueAccent),
        unselectedLabelStyle: TextStyle(
          fontSize: 13,
          color: Colors.black,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedTabPosition = 2;
          });
          Navigator.pushNamed(context, MyRoutes.CategoryList);
        },
        child: const Icon(
          Icons.add,
          size: 50,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
// UtilWidgets.buildBackgroundContainer(
//       child: Scaffold(
//         body: Center(
//           child: Column(
//
//           ),
//         ),
//       ),
//     );