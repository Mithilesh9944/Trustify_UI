import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/TokenManager.dart';
import 'package:flutter_project/Services/ListProduct.dart';
import 'package:flutter_project/Util/MyRoutes.dart';
import 'package:flutter_project/Util/UtilPages.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class PostAdPage extends StatefulWidget {
  final Map<String, dynamic> pDetails;
  const PostAdPage({required this.pDetails, super.key});

  @override
  State<PostAdPage> createState() => _PostAdPageState();
}

class _PostAdPageState extends State<PostAdPage> {
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trustify',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        //centerTitle: true,
        backgroundColor: UtilitiesPages.APP_BAR_COLOR,
      ),
      body: Padding(
        padding: UtilitiesPages.buildPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            TextField(
              controller: _priceController,
              decoration: _inputDecoration("Price","your expected price"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 109, 190, 231),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: _postAd,
                  child: const Text(
                    'Post',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  InputDecoration _inputDecoration(String label,String hint) {
    return InputDecoration(
      labelText: label, // Label for input box
      hintText: hint, // Placeholder text
      hintStyle: const TextStyle(color: Colors.grey),
      floatingLabelBehavior: FloatingLabelBehavior.always, // Keeps label always visible
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.black),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    );
  }

  void _postAd() async {
    String? token = await TokenManager.getToken();
    Map<String, dynamic> jwtDecoded = JwtDecoder.decode(token!);
    String? mobileNO = jwtDecoded['mobileNo'];
    widget.pDetails['price'] = _priceController.text;
    widget.pDetails['mobileNo'] = mobileNO;

    bool flag = await ListProduct.addProduct(widget.pDetails);
    if (flag) {
      print(widget.pDetails);
      print('added successfully');
      Navigator.pushReplacementNamed(context, MyRoutes.Dashboard);
    } else {
      print("getting false from adding product");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Internal server error, please try after some time."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
