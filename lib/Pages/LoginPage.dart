import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/Services/api_service.dart';
import 'package:flutter_project/Util/UtilPages.dart';
import 'package:flutter_project/Util/UtilWidgets.dart';
import 'package:flutter_project/Security/SecurityDetails.dart';
import 'package:flutter_project/Security/SecurityPasswordField.dart';

import '../Util/MyRoutes.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String buttonTitle = "Log In";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.transparent,
      body: UtilWidgets.buildBackgroundContainer(
        child: Padding(
          padding: UtilitiesPages.buildPadding(context),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildLogo(),
                    const SizedBox(height: 10),
                    _buildFormContainer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // AppBar with title and help actions
  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Trustify'),
      backgroundColor: Color.fromARGB(255, 109, 190, 231),
      actions: UtilWidgets.buildHelpWidgetAppBar(context),
    );
  }

  // Logo image
  Widget _buildLogo() {
    return Image.asset(
      'assets/openPage3.png',
      height: 200,
      width: 200,
    );
  }

  // Container for all form elements
  Widget _buildFormContainer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          _buildMobileNumberField(),
          SizedBox(height: UtilitiesPages.SIZE_BOX_HEIGHT),
          _buildPasswordField(),
          const SizedBox(height: 40),
          //UtilButtons.buildButton(context:context,route:'contactRead',title: 'Log In'),
          _buildLoginButton(),
          const SizedBox(height: 20),
          _buildForgotPasswordButton(),
          const SizedBox(height: 30),
          _buildRegisterButton(),
        ],
      ),
    );
  }

  // Mobile number input field
  Widget _buildMobileNumberField() {
    return TextFormField(
      controller: _mobileNumberController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      validator: (value) {
        if (value!.isEmpty) {
          return "required *";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Mobile Number',
        fillColor: Colors.transparent,
        filled: true,
        hintText: 'Enter your Mobile Number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UtilitiesPages.BOX_BORDER_RADIUS),
        ),
      ),
    );
  }

  // Password input field
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "required *";
        } else if (value.length < 6) {
          return "password contains atleast 6 characters";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        fillColor: Colors.transparent,
        filled: true,
        hintText: 'Enter Your Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UtilitiesPages.BOX_BORDER_RADIUS),
        ),
      ),
    );
  }

  // Login button
  Widget _buildLoginButton() {
    return Container(
      width: MediaQuery.of(context).size.width - (2 * UtilitiesPages.LEFT),
      padding: EdgeInsets.symmetric(horizontal: UtilitiesPages.LEFT),
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 109, 174, 231),
          padding:
              EdgeInsets.symmetric(vertical: UtilitiesPages.BOX_VERTICAL_SIZE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          buttonTitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: UtilitiesPages.OPTION_FONT_SIZE,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // "Forgot Password" button
  Widget _buildForgotPasswordButton() {
    return Container(
      width: MediaQuery.of(context).size.width - (2 * UtilitiesPages.LEFT),
      padding: EdgeInsets.symmetric(horizontal: UtilitiesPages.LEFT),
      child: TextButton(
        onPressed: _forgotPassword,
        child: Text(
          'Forget Password?',
          style: TextStyle(
            color: Colors.blue,
            fontSize: UtilitiesPages.OPTION_FONT_SIZE,
          ),
        ),
      ),
    );
  }

  // "New User? Register" button
  Widget _buildRegisterButton() {
    return RichText(
      text: TextSpan(
        text: 'New User? ',
        style: TextStyle(
          color: Colors.black,
          fontSize: UtilitiesPages.OPTION_FONT_SIZE,
        ),
        children: [
          TextSpan(
            text: 'Register',
            style: TextStyle(
              color: Colors.blue,
              fontSize: UtilitiesPages.OPTION_FONT_SIZE,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => UtilWidgets.navigateTo(
                  route: MyRoutes.RegisterPage, context: context),
          ),
        ],
      ),
    );
  }

  // Methods for button actions
  void _login() async {
    if (_formKey.currentState!.validate()) {
      _setDetails();

      bool isLoginSuccessful = await ApiService.LoginUser(
          {"mobile": Details.mobile, "password": Details.password});
      if (isLoginSuccessful) {
        setState(() {
          buttonTitle = "Logging";
        });
        await Future.delayed(Duration(seconds: 1));
        _navigateTo(routes: MyRoutes.ContactDashboardPage);
        setState(() {
          buttonTitle = "Log In";
        });
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Invalid credentials, please try again.")),
      );
      }
    }
  }

  void _setDetails() {
    String st = "+91";
    Details.mobile = st + _mobileNumberController.text;
    Details.password = _passwordController.text;
  }

  void _navigateTo({required String routes}) {
    Navigator.pushNamed(context, routes);
  }

  void _forgotPassword() {
    // Forgot password logic here
  }
}
