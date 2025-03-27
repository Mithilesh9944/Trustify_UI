import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/UploadImagePage.dart';
import 'package:flutter_project/Util/UtilPages.dart';

class CarDetailsPage extends StatefulWidget {
  const CarDetailsPage({super.key});

  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}
class _CarDetailsPageState extends State<CarDetailsPage>  {
   String? selectedBrand;
  String? selectedFuelType;
  String? selectedTransmission;
  String? selectedOwner;

  final TextEditingController yearController = TextEditingController();
  final TextEditingController kmDrivenController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
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
                  value: selectedBrand,
                  items: [
                    'Hundayi',
                    'Suzuki',
                    'Toyota',
                    'Mahindra',
                    'Ford',
                    'Tata',
                    'Other'
                  ]
                      .map((brand) => DropdownMenuItem(
                            value: brand,
                            child: Text(brand),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBrand=value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                const TextFieldLabel(label: 'Year*'),
                TextField(
                  controller: yearController,
                  decoration: _inputDecoration('Year of Purchases'),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                ),
                const SizedBox(height: 16.0),
                const TextFieldLabel(label: 'Fuel*'),
                DropdownButtonFormField(
                  decoration: _inputDecoration('Fule Type'),
                  value: selectedFuelType,
                  items: ['Desel', 'Petrol', 'CNG', 'Electric']
                      .map(
                        (ftype) => DropdownMenuItem(
                          value: ftype,
                          child: Text(ftype),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFuelType=value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                const TextFieldLabel(label: 'Transmission'),
                DropdownButtonFormField(
                  decoration: _inputDecoration('Vechile Type'),
                  value: selectedTransmission,
                  items: ['Automated', 'Mannual']
                      .map(
                        (vtype) => DropdownMenuItem(
                          value: vtype,
                          child: Text(vtype),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTransmission=value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                const TextFieldLabel(label: 'Km Driven'),
                TextField(
                  controller: kmDrivenController,
                  decoration: _inputDecoration('Km Driven '),
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                ),
                const SizedBox(height: 16.0),
                const TextFieldLabel(label: 'Owner'),
                DropdownButtonFormField(
                  decoration: _inputDecoration('No of Owner'),
                  value: selectedOwner,
                  items: ['1st', '2nd', '3rd']
                      .map(
                        (otype) => DropdownMenuItem(
                          value: otype,
                          child: Text(otype),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedOwner=value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                const TextFieldLabel(label: 'Ad title*'),
                TextField(
                  controller: titleController,
                  decoration: _inputDecoration('Key Features of car'),
                  maxLength: 50,
                ),
                const SizedBox(height: 16.0),
                const TextFieldLabel(label: 'Additional information*'),
                TextField(
                  controller: descriptionController,
                  decoration: _inputDecoration(
                          'Include condition, features and reasons for selling')
                      .copyWith(counterText: '0/4096'),
                  maxLength: 4096,
                  maxLines: 5,
                ),
                const SizedBox(height: 24.0),
                // UtilButtons.buildButton(
                //     title: 'Next',
                //     context: context,
                //     route: MyRoutes.UploadImage),
                //  SizedBox(height: UtilitiesPages.SIZE_BOX_HEIGHT),
                Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 109, 190, 231), // White background
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                  onPressed: _submitDetails,
                  child: Text('Next',
                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold ),
                  ),
                ),
              ),
                ),  
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
  void _submitDetails(){
    var carDetails=<String,dynamic>{
      'brand':selectedBrand,
      'year_of_purchase':yearController.text,
      'fule_type':selectedFuelType,
      'transmission':selectedTransmission,
      'km_driven':kmDrivenController.text,
      'owner':selectedOwner,
      'p_title':titleController.text,
      'p_description':descriptionController.text,
      'img_list':[]
    };
    Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadImagePage(p_details: carDetails,)));
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
