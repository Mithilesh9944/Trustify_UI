import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/AllCategoryPage.dart';
import 'package:flutter_project/ProductDetailForm/BikeDetailsPage.dart';
import 'package:flutter_project/ProductDetailForm/CarDetailsPage.dart';
import 'package:flutter_project/ProductDetailForm/CycleDetailsPage.dart';
import 'package:flutter_project/ProductDetailForm/FurnitureDetailsPage.dart';
import 'package:flutter_project/ProductDetailForm/LaptopDetailsPage.dart';
import 'package:flutter_project/ProductDetailForm/MobileDetailsPage.dart';
//import 'package:flutter_project/Util/MyRoutes.dart';

class OfferPage extends StatelessWidget {
  const OfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.directions_car, 'label': 'Cars'},
      {'icon': Icons.pedal_bike, 'label': 'Cycle'},
      {'icon': Icons.laptop, 'label': 'Laptop'},
      {'icon': Icons.ac_unit, 'label': 'AC'},
      {'icon': Icons.air, 'label': 'Cooler'},
      {'icon': Icons.phone_android, 'label': 'Mobiles'},
      {'icon': Icons.chair, 'label': 'Furniture'},
      {'icon': Icons.pedal_bike, 'label': 'Bikes'},
      {'icon': Icons.more_horiz, 'label': 'See all categories'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('What are you offering?'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 109, 190, 231),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return OfferItem(
                  icon: items[index]['icon'] as IconData,
                  label: items[index]['label'] as String,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class OfferItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const OfferItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (label) {
          case 'Cars':
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CarDetailsPage()));
            break;
          case 'Bikes':
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BikeDetailsPage()));
            break;
          case 'Cycle':
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CycleDetailsPage()));
            break;

          case 'Laptop':
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LaptopDetailsPage()));
            break;
          case 'Mobiles':
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MobileDetailsPage()));
            break;
          case 'Furniture':
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FurnitureDetailsPage()));
            break;
          default:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyAllCategoryPage()));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.0, color: Colors.white),
            const SizedBox(height: 8.0),
            Text(
              label,
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
