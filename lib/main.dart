import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/AllCategoryPage.dart';
import 'package:flutter_project/Pages/CategoryPage.dart';
import 'package:flutter_project/Pages/ChatBox.dart';
import 'package:flutter_project/Pages/ChatListPage.dart';
import 'package:flutter_project/Pages/ContactReadPage.dart';
import 'package:flutter_project/Pages/HelpInstructPage.dart';
import 'package:flutter_project/Pages/HomePage.dart';
import 'package:flutter_project/Pages/ProductDetailPage.dart';
import 'package:flutter_project/Pages/RegisterPage.dart';
import 'package:flutter_project/Pages/TokenManager.dart';
import 'package:flutter_project/Pages/WelcomePage.dart';
import 'Pages/LoginPage.dart';
import 'Pages/Dashboard.dart';

import 'Util/MyRoutes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    String? userToken =  await TokenManager.getToken();
  runApp(MyApp(token: userToken )); //MaterailApp
}
class MyApp extends StatelessWidget{
  final token;
  const MyApp({
    @required this.token,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    // initialRoute: (token!=null&&!JwtDecoder.isExpired(token!)) ? MyRoutes.Dashboard : MyRoutes.HomePage,
    initialRoute:MyRoutes.Dashboard ,
    routes: {
      MyRoutes.HomePage:(context) => MyHome(),
      MyRoutes.RegisterPage: (context) => MyRegister(),
      MyRoutes.LoginPage: (context) => MyLogin(),
      MyRoutes.WelcomePage: (context) => MyWelcome(),
      MyRoutes.ContactDashboardPage:(context)=>MyContactReadPage(),
      MyRoutes.HelpPage:(context) => MyHelpSupportScreen(),
      MyRoutes.ContactDetails:(context)=> MyContactReadPage(),
      MyRoutes.AllCategoryPage:(context)=>MyAllCategoryPage(),
      MyRoutes.CategoryList:(context)=>OfferPage(),
      MyRoutes.ProductDetails:(context)=>ProductDetailsPage(),
      MyRoutes.Dashboard:(context)=>Dashboard(),
      MyRoutes.ChatListPage:(context)=>ChatListPage(),
      MyRoutes.ChatBox:(context)=>ChatBox(user1: 'kushal', user2: 'devendra',),
      //MyRoutes.UploadImage:(context)=>UploadImagePage(),

    },
  );
  }
}
