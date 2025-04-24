import 'package:flutter/material.dart';
import 'package:flutter_project/Util/UtilPages.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import '../Util/UtilWidgets.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int selectedTabPosition = 0;
  late PageController _pageController;
  int _currentIndex = 0;
  late List<String> productImages;
  late Map<String, dynamic> productDetails;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    productDetails = widget.product['properties'] ?? {};
    productImages =
        (productDetails['p_img'] as List<dynamic>?)?.cast<String>() ?? [];

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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          productDetails['p_title'] ?? "Details",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: UtilitiesPages.pageColor,
        centerTitle: true,
      ),
      body: UtilWidgets.buildBackgroundContainer(
        child: Padding(
          padding: UtilitiesPages.buildPadding(context),
          child: Column(
            children: [
              // Image slider with fixed height
              Container(
                margin: EdgeInsets.all(5),
                height: MediaQuery.of(context).size.width * 0.6, // Fixed height
                child: productImages.isNotEmpty
                    ? PageView.builder(
                  controller: _pageController,
                  itemCount: productImages.length,
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
                          image: NetworkImage(productImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                )
                    : Icon(Icons.image_not_supported, size: 100),
              ),
              // Wrapping the rest of the content in SingleChildScrollView
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: UtilitiesPages.pageColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productDetails['p_title'] ?? "No Title",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        buildExpandableText(
                            productDetails['p_description'] ?? "No Description"),
                        SizedBox(height: 10),
                        Text(
                          "₹ ${productDetails['price']?.toString() ?? 'N/A'}",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Divider(color: Colors.grey[700]),
                        _detailRow("Brand", productDetails['brand']),
                        _detailRow("Fuel Type", productDetails['fuel_type']),
                        _detailRow("Transmission", productDetails['transmission']),
                        _detailRow("Year of Purchase",
                            productDetails['year_of_purchase']?.toString()),
                        SizedBox(height: 20),
                        Center(
                          child: _customButton(
                            "Verify",
                            Icons.verified,
                            Colors.deepPurple,
                                () {
                              // Add your logic
                            },
                            16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: _customButton(
                            "Make Offer",
                            Icons.local_offer,
                            Colors.green,
                                () {
                              // Add your logic
                            },
                            16,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: UtilWidgets.createBottomNavigation(
        selectedTabPosition: selectedTabPosition,
        onTap: (index) {
          setState(() {
            selectedTabPosition = index;
          });
        },
        context: context
      ),
      floatingActionButton: UtilWidgets.createFloatingActionButton(
        context: context,
        onTabChange: () {
          setState(() {
            selectedTabPosition = 2;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _customButton(String text, IconData icon, Color color,
      VoidCallback onPressed, double sizes) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 5,
        shadowColor: Colors.black45,
      ),
      icon: Icon(
        icon,
        color: Colors.white,
        size: sizes,
      ),
      label: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Custom Detail Row Widget
  Widget _detailRow(String label, String? value) {
    return value != null
        ? Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    )
        : SizedBox.shrink();
  }

  Widget buildExpandableText(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.indigo[900],
            ),
          ),
          secondChild: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.indigo[900],
            ),
          ),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 300),
        ),
        InkWell(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? "Read Less" : "Read More",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
