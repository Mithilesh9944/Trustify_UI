import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/UploadImagePage.dart';
import 'package:flutter_project/Util/UtilWidgets.dart';

import '../Util/UtilPages.dart';
import '../Util/UtilProductForm.dart';

class DynamicFormWidget extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>>? formCategories;

  const DynamicFormWidget({super.key, required this.formCategories});

  @override
  _DynamicFormWidgetState createState() => _DynamicFormWidgetState();
}

class _DynamicFormWidgetState extends State<DynamicFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {}; // Store input values
  final Map<String, TextEditingController> _controllers = {}; // Text field controllers

  @override
  void initState() {
    super.initState();
    // Initialize controllers for text fields
    for (var category in widget.formCategories!.values) {
      for (var field in category) {
        if (field["type"] == FormFieldType.text || field["type"]==FormFieldType.description) {
          _controllers[field["label"]] = TextEditingController();
        }
      }
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitForm() {

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Collect values from controllers
      for (var entry in _controllers.entries) {
        _formData[entry.key] = entry.value.text;
      }

     // print("Form Data: $_formData");
      Future.delayed(const Duration(milliseconds: 1000),(){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>UploadImagePage(p_details: _formData)));
      }
      );

      // Process form submission (API call, navigation, etc.)
      UtilWidgets.showSnackBar(msg: "Form Submitted Successfully", context: context);

    }
    else{
      UtilWidgets.showSnackBar(msg: "Error Occurred", context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Include some Bike details'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 109, 190, 231),
      ),
      body: Padding(
        padding: UtilitiesPages.buildPadding(context),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              for (var category in widget.formCategories!.entries) ...[
                Text(
                  category.key.toString(), // Category Title
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                for (var field in category.value) _buildFormField(field),
                const SizedBox(height: 20),
              ],
              // ElevatedButton(
              //   onPressed: _submitForm,
              //   child: const Text("Submit"),
              // )
                _buildButton()
              ,
            ],
          ),
        ),
      ),
    );
  }

  // Function to build dynamic form fields
  Widget _buildFormField(Map<String, dynamic> field) {
    switch (field["type"]) {
      case FormFieldType.text:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: TextFormField(
            controller: _controllers[field["label"]],
            maxLength: (field["keyboard"]==TextInputType.text)?50:6,
            decoration: _inputDecoration(field["label"]),
            keyboardType: field["keyboard"] ?? TextInputType.text,
            validator: (value) => value!.isEmpty ? "${field["label"]} is required" : null,
          ),
        );
      case FormFieldType.dropdown:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: DropdownButtonFormField<String>(
            decoration:_inputDecoration(field['label']),
            items: (field["options"] as List<String>).map((option) {
              return DropdownMenuItem(value: option, child: Text(option));
            }).toList(),
            onChanged: (value) => _formData[field["label"]] = value,
            validator: (value) => value == null ? "${field["label"]} is required" : null,
          ),
        );
      case FormFieldType.description:
          return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                  controller: _controllers[field["label"]],
                  decoration: _inputDecoration('Include condition, features and reasons for selling').copyWith(counterText: '0/4096'),
                  maxLength: 4096,
                  maxLines: 5,
                  keyboardType: TextInputType.text,
                  validator: (value)=>(value!.isEmpty)?"${field["label"]} is required":null,
              ),
          );
      default:
        return Container();
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      labelText: hint,
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.black),
      ),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    );
  }

  Widget _buildButton (){
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
           backgroundColor: Color.fromARGB(255, 109, 174, 231),
            minimumSize: const Size(double.infinity,45),
            shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
        )
        ),
        onPressed: _submitForm,
        child: Text(
          "Submit",
          style: TextStyle(fontSize: 18, color: Colors.white),
        )
    );
  }
}
