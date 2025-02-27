import 'package:flutter/material.dart';
import 'package:flutter_project/Util/UtilPages.dart';
import 'package:flutter_project/Util/MyRoutes.dart';
import 'package:flutter_project/Util/UtilButtons.dart';

class CarDetailsPage extends StatelessWidget {
  const CarDetailsPage({super.key});

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
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextFieldLabel(label: 'Brand*'),
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Brand'),
                  items: [
                    'Hundayi',
                    'Suzuki',
                    'Toyota',
                    'Mahindra',
                    'Ford',
                    'Tata'
                  ]
                      .map((brand) => DropdownMenuItem(
                            value: brand,
                            child: Text(brand),
                          ))
                      .toList(),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16.0),
                const TextFieldLabel(label: 'Year*'),
                TextField(
                  decoration: _inputDecoration('Year of Purchases'),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                ),
                const SizedBox(height: 16.0),
                const TextFieldLabel(label: 'Fuel*'),
                DropdownButtonFormField(
                  decoration: _inputDecoration('Fule Type'),
                  items: ['Desel', 'Petrol', 'CNG', 'Electric']
                      .map(
                        (ftype) => DropdownMenuItem(
                          value: ftype,
                          child: Text(ftype),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16.0),
                const TextFieldLabel(label: 'Transmission'),
                DropdownButtonFormField(
                  decoration: _inputDecoration('Vechile Type'),
                  items: ['Automated', 'Mannual']
                      .map(
                        (vtype) => DropdownMenuItem(
                          value: vtype,
                          child: Text(vtype),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16.0),
                const TextFieldLabel(label: 'Km Driven'),
                TextField(
                  decoration: _inputDecoration('Km Driven '),
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                ),
                const SizedBox(height: 16.0),
                const TextFieldLabel(label: 'Owner'),
                DropdownButtonFormField(
                  decoration: _inputDecoration('No of Owner'),
                  items: ['1st', '2nd', '3rd']
                      .map(
                        (otype) => DropdownMenuItem(
                          value: otype,
                          child: Text(otype),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16.0),
                const TextFieldLabel(label: 'Ad title*'),
                TextField(
                  decoration: _inputDecoration('Key Features of car'),
                  maxLength: 50,
                ),
                const SizedBox(height: 16.0),
                const TextFieldLabel(label: 'Additional information*'),
                TextField(
                  decoration: _inputDecoration(
                          'Include condition, features and reasons for selling')
                      .copyWith(counterText: '0/4096'),
                  maxLength: 4096,
                  maxLines: 5,
                ),
                const SizedBox(height: 24.0),
                UtilButtons.buildButton(
                    title: 'Next',
                    context: context,
                    route: MyRoutes.ContactDashboardPage)
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
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
}

class TextFieldLabel extends StatelessWidget {
  final String label;

  const TextFieldLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
