// File: dynamic_form_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/UploadImagePage.dart';
import 'package:flutter_project/Util/UtilWidgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Util/UtilPages.dart';
import '../Util/UtilProductForm.dart';

class DynamicFormWidget extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>>? formCategories;
  final String categoryGroup;
  final String subCategory;

  const DynamicFormWidget({
    super.key,
    required this.formCategories,
    required this.categoryGroup,
    required this.subCategory,
  });

  @override
  State<DynamicFormWidget> createState() => _DynamicFormWidgetState();
}

class _DynamicFormWidgetState extends State<DynamicFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (var category in widget.formCategories!.values) {
      for (var field in category) {
        if (field["type"] == FormFieldType.text || field["type"] == FormFieldType.description) {
          _controllers[field["value"]] = TextEditingController();
        }
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      for (var entry in _controllers.entries) {
        _formData[entry.key] = entry.value.text;
      }
      _formData['label'] = widget.categoryGroup; //lable
      _formData['subCategory'] = widget.subCategory; //subCategory
      Future.delayed(const Duration(milliseconds: 1000), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => UploadImagePage(p_details: _formData)));
      });

      //UtilWidgets.showSnackBar(msg: "Form Submitted Successfully", context: context);
    } else {
      UtilWidgets.showSnackBar(msg: "Error Occurred", context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Include Details',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 109, 190, 231),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: UtilitiesPages.buildPadding(context),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              for (var category in widget.formCategories!.entries) ...[
                UtilWidgets.buildText(text: category.key.toString()),
                const SizedBox(height: 10),
                for (var field in category.value) _buildFormField(field),
                const SizedBox(height: 20),
              ],
              _buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(Map<String, dynamic> field) {
    switch (field["type"]) {
      case FormFieldType.text:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: TextFormField(
            controller: _controllers[field["value"]],
            maxLength: (field["keyboard"] == TextInputType.text) ? 50 : 6,
            decoration: _inputDecoration(field["label"]),
            keyboardType: field["keyboard"] ?? TextInputType.text,
            validator: (value) => value!.isEmpty ? "${field["label"]} is required" : null,
          ),
        );
      case FormFieldType.dropdown:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: DropdownButtonFormField<String>(
            decoration: _inputDecoration(field['label']),
            items: (field["options"] as List<String>).map((option) {
              return DropdownMenuItem(value: option, child: Text(option));
            }).toList(),
            onChanged: (value) => _formData[field["value"]] = value,
            validator: (value) => value == null ? "${field["label"]} is required" : null,
          ),
        );
      case FormFieldType.description:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: TextFormField(
            controller: _controllers[field["value"]],
            decoration: _inputDecoration(field["label"]),
            maxLength: 4096,
            maxLines: 5,
            keyboardType: TextInputType.text,
            validator: (value) => (value!.isEmpty) ? "${field["label"]} is required" : null,
          ),
        );
      default:
        return Container();
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      hintText: label,
      hintStyle: const TextStyle(color: Colors.grey),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.black),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    );
  }

  Widget _buildButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 109, 174, 231),
        minimumSize: const Size(double.infinity, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: _submitForm,
      child: const Text(
        "Submit",
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}