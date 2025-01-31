import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/AllCategoryPage.dart';
import 'package:flutter_project/Pages/CategoryPage.dart';
import 'package:flutter_project/Pages/ContactReadPage.dart';
import 'package:flutter_project/Pages/HelpInstructPage.dart';
import 'package:flutter_project/Pages/HomePage.dart';
import 'package:flutter_project/Pages/ProductDetailPage.dart';
import 'package:flutter_project/Pages/RegisterPage.dart';
import 'package:flutter_project/Pages/WelcomePage.dart';
import 'Pages/LoginPage.dart';
import 'Util/MyRoutes.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: MyRoutes.HomePage,
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
      MyRoutes.ProductDetails:(context)=>IncludeDetailsPage(),

    },
  )); //MaterailApp
}
