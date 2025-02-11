import 'package:flutter/material.dart';
import 'package:flutter_project/Util/UtilWidgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../Util/MyRoutes.dart';

class Dashboard extends StatefulWidget {
  final String token;
  
  const Dashboard({Key? key, required this.token}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String email;
  late String mobileNo;

  @override
  void initState() {
    super.initState();
    try {
      Map<String, dynamic> jwtDecoded = JwtDecoder.decode(widget.token);
      email = jwtDecoded['email'] ?? 'No Email';
      mobileNo = jwtDecoded['mobile_no'] ?? 'No Mobile Number';
    } catch (e) {
      email = 'Invalid Token';
      mobileNo = 'Invalid Token';
    }
  }

  @override
  Widget build(BuildContext context) {
    return UtilWidgets.buildBackgroundContainer(
      child: Scaffold(
        body: Center(
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
                mobileNo,
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
    );
  }
}
