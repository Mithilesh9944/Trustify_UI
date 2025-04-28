// File: MyAllCategoryPage.dart
import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/DynamicFormPage.dart';
import 'package:flutter_project/Util/UtilPages.dart';
import 'package:flutter_project/Util/UtilProductForm.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAllCategoryPage extends StatefulWidget {
  const MyAllCategoryPage({super.key});

  @override
  State<MyAllCategoryPage> createState() => _MyAllCategoryPageState();
}

class _MyAllCategoryPageState extends State<MyAllCategoryPage> {
  final Map<String, Map<String, IconData>> categories = {
    'Vehicle': {
      'Car': Icons.directions_car,
      'Bike': Icons.motorcycle,
      'Cycle': Icons.pedal_bike,
    },
    'Electronics': {
      'Laptop': Icons.laptop,
      'Mobile': Icons.phone_android,
    },
    'Furniture': {
      'Furniture': Icons.chair,
    },
    'Books': {
      'Book': Icons.book,
    },
    'HomeAppliance': {
      'Refrigerator': Icons.kitchen,
      'WashingMachine': Icons.local_laundry_service,
      'AirConditioner': Icons.ac_unit,
    },
  };

  final Map<String, IconData> categoryIcons = {
    'Vehicle': Icons.directions_car,
    'Electronics': Icons.devices_other,
    'Furniture': Icons.weekend,
    'Books': Icons.book,
    'HomeAppliance': Icons.home_filled,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('What are you offering?',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: UtilitiesPages.APP_BAR_COLOR,
      ),
      body: ListView(
        children: categories.entries.map((categoryEntry) {
          String categoryName = categoryEntry.key;
          IconData categoryIcon = categoryIcons[categoryName] ?? Icons.category;
          Map<String, IconData> subCats = categoryEntry.value;

          return ExpansionTile(
            leading: Icon(categoryIcon, color: Colors.blue),
            title: Text(categoryName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            children: subCats.entries.map((subCatEntry) {
              String subCatName = subCatEntry.key;
              IconData subCatIcon = subCatEntry.value;

              return ListTile(
                leading: Icon(subCatIcon, color: Colors.teal),
                title: Text(subCatName),
                onTap: () {
                  try {
                    final categoryEnum = CategoryGroup.values.firstWhere(
                        (e) => e.name.toLowerCase() == categoryName.toLowerCase());

                    final subCatEnum = SubCategory.values.firstWhere(
                        (e) => e.name.toLowerCase() == subCatName.toLowerCase());

                    final form = UtilProductForm.formCategories[categoryEnum]?[subCatEnum];

                    if (form != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DynamicFormWidget(
                            formCategories: form,
                            categoryGroup: categoryName,
                            subCategory: subCatName,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Form not available for this category")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Invalid category mapping: $e")),
                    );
                  }
                },
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}