import 'package:flutter/material.dart';
import 'package:flutter_project/Util/UtilWidgets.dart';

class UtilButtons{

  //Button
  static Widget buildButton({required String title,required BuildContext context,required String route}) {

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 109, 174, 231),
        minimumSize: const Size(double.infinity, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed:(){
        Future.delayed(const Duration(milliseconds: 100), () {
          UtilWidgets.navigateTo(context:context,route: route);
        });
      },
      child: Text(
        title,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),

    );
  }
  static Widget buildValidateFormButton({required String title,required BuildContext context,required String route,required GlobalKey<FormState> formKey}) {

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 109, 174, 231),
        minimumSize: const Size(double.infinity, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed:(){
        Future.delayed(const Duration(milliseconds: 100), () {
          if(formKey.currentState!.validate()){
            UtilWidgets.navigateTo(context:context,route: route);
          }else{
            UtilWidgets.showSnackBar(msg: "All Fields Are Required To fill", context: context);
          }
        });
      },
      child: Text(
        title,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),

    );
  }


}
