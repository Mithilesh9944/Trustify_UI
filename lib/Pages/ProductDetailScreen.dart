import 'package:flutter/material.dart';
import 'dart:async';

class CarDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const CarDetailsScreen({super.key, required this.product});

  @override
  _CarDetailsScreenState createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  late List<String> carImages;
  late Map<String, dynamic> productDetails;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Extract properties object
    productDetails = widget.product['properties'] ?? {};

    // Extract image URLs safely
    carImages = (productDetails['p_img'] as List<dynamic>?)?.cast<String>() ?? [];

    // Auto-scroll every 3 seconds
    if (carImages.isNotEmpty) {
      Timer.periodic(Duration(seconds: 3), (Timer timer) {
        if (_currentIndex < carImages.length - 1) {
          _currentIndex++;
        } else {
          _currentIndex = 0;
        }
        if (mounted) {
          _pageController.animateToPage(
            _currentIndex,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productDetails['p_title'] ?? "Details"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Image Slider
          Container(
            margin: EdgeInsets.all(16),
            height: 250,
            child: carImages.isNotEmpty
                ? PageView.builder(
                    controller: _pageController,
                    itemCount: carImages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2,
                              spreadRadius: 2,
                              offset: Offset(2, 4),
                            ),
                          ],
                          image: DecorationImage(
                            image: NetworkImage(carImages[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  )
                : Icon(Icons.image_not_supported, size: 100),
          ),

          // Product Details
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productDetails['p_title'] ?? "No Title",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Text(
                    productDetails['p_description'] ?? "No Description",
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "₹ ${productDetails['price']?.toString() ?? 'N/A'}",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                  ),
                  SizedBox(height: 20),
                  Divider(color: Colors.grey[700]),

                  // Other details
                  _detailRow("Brand", productDetails['brand']),
                  _detailRow("Fuel Type", productDetails['fuel_type']),
                  _detailRow("Transmission", productDetails['transmission']),
                  _detailRow("Year of Purchase", productDetails['year_of_purchase']?.toString()),

                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _customButton("Chat", Icons.chat, Colors.blue, () {}),
                      _customButton("Make Offer", Icons.local_offer, Colors.green, () {}),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  Widget _detailRow(String label, String? value) {
    return value != null
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
                Text(value, style: TextStyle(color: Colors.white70, fontSize: 16)),
              ],
            ),
          )
        : SizedBox.shrink();
  }
}
