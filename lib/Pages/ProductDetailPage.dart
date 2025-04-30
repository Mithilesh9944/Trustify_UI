import 'dart:async';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late PageController _pageController;
  int _currentIndex = 0;
  List<String> productImages = [];
  late Map<String, dynamic> productDetails;
  late String? verifiedBy;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    productDetails = widget.product;
    verifiedBy = productDetails['verifiedBy'];
    productImages =
        (productDetails['images'] as List<dynamic>?)?.cast<String>() ?? [];

    if (productImages.isNotEmpty) {
      Timer.periodic(Duration(seconds: 3), (Timer timer) {
        if (_currentIndex < productImages.length - 1) {
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

  void _verify() {
    // Simulate verification
    setState(() {
      verifiedBy = "Admin";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Product has been verified")),
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = productDetails['title'] ?? "No Title";
    String description = productDetails['description'] ?? "No Description";
    String price = productDetails['price']?.toString() ?? "N/A";
    Map<String, dynamic> details =
        (productDetails['details'] as Map<String, dynamic>?) ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          if (productImages.isNotEmpty)
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                itemCount: productImages.length,
                itemBuilder: (context, index) => Image.network(
                  productImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            )
          else
            Container(
              height: 200,
              color: Colors.grey[300],
              child: Center(child: Icon(Icons.image_not_supported)),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  Text(
                    title,
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "₹ $price",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[700]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16),
                  ),
                  Divider(height: 30),
                  Text("Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ...details.entries.map((entry) => _detailRow(entry.key, entry.value.toString())),
                  
                    SizedBox(height: 10),
                    _detailRow("Seller Name", productDetails['seller'] ?? "Unknown"),
                
                  if (verifiedBy != null) ...[
                    SizedBox(height: 10),
                    _detailRow("Verified By", verifiedBy!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 10,
          top: 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: _customButton("Make Offer", Icons.local_offer, Colors.green, () {}, 10),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _customButton(
                verifiedBy != null ? "Already Verified" : "Verify",
                Icons.verified,
                verifiedBy != null ? Colors.grey : Colors.deepPurple,
                verifiedBy != null ? null : _verify,
                10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("$label:", style: TextStyle(fontWeight: FontWeight.w500)),
            ),
            Expanded(flex: 5, child: Text(value)),
          ],
        ),
      );

  Widget _customButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback? onPressed,
    double horizontalPadding,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: onPressed == null ? 0 : 5,
        shadowColor: onPressed == null ? Colors.transparent : Colors.black45,
        foregroundColor: Colors.white,
      ),
    );
  }
}
