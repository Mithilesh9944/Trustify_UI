import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/AllCategoryPage.dart';
import 'package:flutter_project/Pages/CategoryPage.dart';
import 'package:flutter_project/Pages/ContactReadPage.dart';
import 'package:flutter_project/Pages/HelpInstructPage.dart';
import 'package:flutter_project/Pages/HomePage.dart';
import 'package:flutter_project/Pages/MyUploadedProducts.dart';
import 'package:flutter_project/Pages/ProfilePage.dart';
import 'package:flutter_project/Pages/RegisterPage.dart';
import 'package:flutter_project/Security/TokenManager.dart';
import 'package:flutter_project/Pages/WelcomePage.dart';
import 'package:flutter_project/Pages/notificatin.dart';
import 'Pages/LoginPage.dart';
import 'Pages/Dashboard.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Util/MyRoutes.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
//Global Plugin To Use Anywhere
FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    String? userToken =  await TokenManager.getToken();
    //Android SetUp for initialization
    AndroidInitializationSettings androidSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
    //Initialize Android Settings
    InitializationSettings initializationSettings = InitializationSettings(android: androidSettings);

    bool? initialized = await notificationsPlugin.initialize(initializationSettings);
    //log("Notification : $initialized");
  runApp(MyApp(token: userToken )); //MaterialApp
}

class MyApp extends StatelessWidget{
  final token;
  const MyApp({
    @required this.token,
    super.key,
  });

  @override

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: (token!=null&&!JwtDecoder.isExpired(token!)) ? MyRoutes.Dashboard : MyRoutes.HomePage,
    routes: {
      MyRoutes.HomePage:(context) => MyHome(),
      MyRoutes.RegisterPage: (context) => MyRegister(),
      MyRoutes.LoginPage: (context) => MyLogin(),
      MyRoutes.WelcomePage: (context) => MyWelcome(),
      MyRoutes.ContactReadPage:(context)=>ContactReadPage(),
      MyRoutes.HelpPage:(context) => MyHelpSupportScreen(),
      MyRoutes.ContactDetails:(context)=> ContactReadPage(),
      MyRoutes.AllCategoryPage:(context)=>MyAllCategoryPage(),
      MyRoutes.CategoryPage:(context)=>CategoryPage(),
      MyRoutes.Dashboard:(context)=>Dashboard(),
      MyRoutes.Profile:(context)=>ProfilePage(),
      MyRoutes.NotificationPage: (context) => NotificationPage(),
      MyRoutes.MyProducts:(context)=>MyUploadedProducts(),
      //MyRoutes.ForgotPassword:(context)=>ForgotPasswordPage()



      //MyRoutes.UploadImage:(context)=>UploadImagePage(),
    },
  );
  }
}

