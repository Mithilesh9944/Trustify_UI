import 'package:flutter/material.dart';


class UtilitiesPages {
  // static Color pageColor =
  static Color pageColor = Colors.white60 ;
  static Color APP_BAR_COLOR = Color.fromARGB(255, 109, 190, 231);
  static double LEFT = 35;
  static double RIGHT = 35;
  static double TOP = 90;
  static double BOTTOM = 0;

  static double OPTION_FONT_SIZE = 15;

  static double BOX_ALIGNMENT = 0.25;

  static double SIZE_BOX_HEIGHT = 25;
  static double BOX_VERTICAL_SIZE = 10;
  static double BOX_HORIZONTAL_SIZE = 30;
  static double BOX_BORDER_RADIUS = 10;
  static double BOX_TEXT_FONT_SIZE = 15;

  static double WELCOM_FONT_SIZE = 33.5;
  static double TEXT_FONT_SIZE = 16;

  static Widget buildUsernameTextField(String fieldName) {
    return TextField(
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              vertical: UtilitiesPages.BOX_VERTICAL_SIZE,
              horizontal: UtilitiesPages.BOX_HORIZONTAL_SIZE),
          fillColor: Colors.grey.shade100,
          // filled: true,
          hintText: fieldName,
          hintStyle: const TextStyle(
            fontSize: 14,
            // fontStyle: FontStyle.italic,
            // fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(BOX_BORDER_RADIUS))),
    );
  }

  static EdgeInsets buildPadding(BuildContext context){
    double screenWidth= MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    EdgeInsets responsivePadding = EdgeInsets.symmetric(
      horizontal: screenWidth*0.05,
      vertical: screenHeight*0.02,
    );
     return responsivePadding;
  }



}
