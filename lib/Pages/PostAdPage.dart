import 'package:flutter/material.dart';
import 'package:flutter_project/ProductDetailForm/MobileDetailsPage.dart';
import 'package:flutter_project/Services/ListProduct.dart';
import 'package:flutter_project/Util/MyRoutes.dart';
import 'package:flutter_project/Util/UtilPages.dart';

class PostAdPage extends StatefulWidget {
  final Map<String, dynamic> p_details;
  const PostAdPage({required this.p_details, super.key});

  @override
  State<PostAdPage> createState() => _PostAdPageState();
}

class _PostAdPageState extends State<PostAdPage> {
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Include some Car details'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 109, 190, 231),
      ),
      body: Padding(
        padding: UtilitiesPages.buildPadding(context),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const TextFieldLabel(label: 'Price'),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(
              hintText: 'your expected price',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.black),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 109, 190, 231), // White background
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                    onPressed: _postAd,
                    child: Text(
                      'Post',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))),
          ),
        ]),
      ),
    );
  }

  void _postAd() async {
    widget.p_details['price'] = _priceController.text;
    bool flag = await ListProduct.addProduct(widget.p_details);
    if (flag) {
      print(widget.p_details);
      print('added sucessfully');
      Navigator.pushNamed(context, MyRoutes.Dashboard);
    } else {
      print("getting flase from adding product");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Internal sever error please try after some time."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
