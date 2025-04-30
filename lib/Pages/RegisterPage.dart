import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/Security/SecurityDetails.dart';
import 'package:flutter_project/Util/MyRoutes.dart';
import 'package:flutter_project/Util/UtilPages.dart';
import 'package:flutter_project/Security/SecurityPasswordField.dart';
import 'package:flutter_project/Services/api_service.dart';
import 'package:flutter_project/Util/UtilPickImage.dart';
import 'package:flutter_project/Util/UtilWidgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
 Uint8List? _img;
  void selectImage() async {
    XFile? file = await pickImage(ImageSource.gallery);
    if (file != null) {
    Uint8List img = await file.readAsBytes();
    setState(() {
      _img = img;
    });
  }
  }
  @override
  Widget build(BuildContext context) {
    return
       Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 109, 190, 231),
          title: Text(
            'Trustify',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: UtilWidgets.buildHelpWidgetAppBar(context),
        ),

        backgroundColor: UtilitiesPages.APP_BAR_COLOR,
        body:UtilWidgets.buildBackgroundContainer(child:  Padding(
          padding:UtilitiesPages.buildPadding(context),
          child: Column(
            children: [
              SingleChildScrollView(
                child: Stack(
                  children: [
                    _buildUserIcon(),
                    _buildFormContainer(),
                  ],
                ),
              ),
            ],
          ),
        )),
      );
  }

  // User icon positioned at the top
  Widget _buildUserIcon() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.01,//.15
      left: MediaQuery.of(context).size.width * 0.30,

      child:Stack(
      alignment: Alignment.center,
      children: [
        _img != null
            ?  CircleAvatar(
                radius: 40,
                backgroundImage: MemoryImage(_img!),
              )
            : const CircleAvatar(
                radius: 45,
                backgroundImage: NetworkImage("https://cdn1.vectorstock.com/i/1000x1000/93/75/user-blue-icon-isolated-on-white-background-vector-42029375.jpg"),
              ),
        
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, 
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            child: IconButton(
              onPressed: selectImage,
              icon: const Icon(Icons.add_a_photo, color: Colors.black),
              iconSize: 15,
            ),
          ),
        ),
      ],
    ),
    );
  }

  // Main form container
  Widget _buildFormContainer() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.15,
        // left: UtilitiesPages.LEFT,
        // right: UtilitiesPages.RIGHT,
      ),
      child: Column(
        children: [
          _buildTextField(_userNameController, 'Enter your Name'),
          SizedBox(height: UtilitiesPages.SIZE_BOX_HEIGHT),
          _buildMobileNumberField(),
          SizedBox(height: UtilitiesPages.SIZE_BOX_HEIGHT),
          const PassphrasePasswordField(),
          SizedBox(height: UtilitiesPages.SIZE_BOX_HEIGHT),
          _buildTextField(_confirmPasswordController, 'Confirm Password'),
          SizedBox(height: UtilitiesPages.SIZE_BOX_HEIGHT),
          _buildTextField(_emailController, 'Enter Your Email'),
          SizedBox(height: UtilitiesPages.SIZE_BOX_HEIGHT),
          _buildRegisterButton(),
          SizedBox(height: UtilitiesPages.SIZE_BOX_HEIGHT),
        ],
      ),
    );
  }

  // Mobile number field with specific input formatting
  Widget _buildMobileNumberField() {
    return _buildTextField(
      _mobileNumberController,
      'Enter your Mobile Number',
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }

  // Generic text field builder
  Widget _buildTextField(
      TextEditingController controller,
      String hintText, {
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,
      }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:  GoogleFonts.poppins(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        fillColor: Colors.transparent,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UtilitiesPages.BOX_BORDER_RADIUS),
        ),
      ),
    );
  }

  // Register button with styling
  Widget _buildRegisterButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - (2 * UtilitiesPages.LEFT),
      child: ElevatedButton(
        onPressed: _submitRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 109, 174, 231),
          padding: EdgeInsets.symmetric(vertical: UtilitiesPages.BOX_VERTICAL_SIZE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UtilitiesPages.BOX_BORDER_RADIUS),
          ),
        ),
        child: Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
            fontSize: UtilitiesPages.OPTION_FONT_SIZE,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Handle registration submission with validation
  void _submitRegister() {
    _setDetails();

    if (_validateInputs()) {
      _registerUser();
      _logUserDetails();
    }
  }

  // Set user details from text controllers
  void _setDetails() {
    String st ="+91";
    Details.userName = _userNameController.text;
    Details.mobile = st+_mobileNumberController.text;
    Details.password = PassphrasePasswordField.passwordController.text;
    Details.confirmPassword = _confirmPasswordController.text;
    Details.email = _emailController.text;
  }

  // Input validation logic
  bool _validateInputs() {
    if (_isAnyFieldEmpty()) {
      UtilWidgets.showSnackBar(msg: 'All fields are required.', context: context);
      return false;
    } else if (Details.mobile?.length != 13) {
      UtilWidgets.showSnackBar(msg: 'Please enter a valid 10-digit mobile number', context: context);
      return false;
    } else if (!_isValidEmail(Details.email)) {
      UtilWidgets.showSnackBar(msg: 'Please enter a valid Gmail or NIT KKR email', context: context);
      return false;
    } else if (Details.password != Details.confirmPassword) {
      UtilWidgets.showSnackBar(msg: 'Passwords do not match.', context: context);
      return false;
    }
    return true;
  }

  // Check if any field is empty
  bool _isAnyFieldEmpty() {
    return [
      Details.userName,
      Details.mobile,
      Details.email,
      Details.password,
      Details.confirmPassword
    ].any((field) => field == null || field.isEmpty);
  }

  // Validate email domain
  bool _isValidEmail(String? email) {
    return email != null && (email.endsWith("@gmail.com") || email.endsWith("@nitkkr.ac.in"));
  }

  // Show error message in snackbar
  // void UtilWidgetsshowSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  // }

  // Register user by calling the API
  void _registerUser() async{
    var userdata ={
      "name": Details.userName,
      "mobileNo": Details.mobile,
      "password": Details.password,
      "email": Details.email,
    };
    var response = await ApiService.RegisterUser(userdata,_img);
    if(response !=null &&response['success']==true){
      _showAlertDialog("Registration Successfull", "click on ok to login");
    }
    else{
         UtilWidgets.showSnackBar(msg: response['error'], context: context);

    }
  }

  // Log user details for debugging
  void _logUserDetails() {
    print('Username: ${Details.userName}');
    print('Mobile: ${Details.mobile}');
    print('Email: ${Details.email}');
    print('Password: ${Details.password}');
  }

  void _navigateToNextPage(){
    Navigator.pushNamedAndRemoveUntil(context, MyRoutes.LoginPage, (route)=>false);
   
  }
  void _showAlertDialog(String title,String msg){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: _navigateToNextPage, 
              child: Text("Ok")
              )
          ],
        );
      }
    );

  }
}