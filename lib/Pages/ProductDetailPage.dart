import 'package:flutter/material.dart';
import 'package:flutter_project/Security/TokenManager.dart';
import 'package:flutter_project/Services/ListProduct.dart';
import 'package:flutter_project/Util/UtilPages.dart';
import 'package:flutter_project/Util/util_chat.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../Util/MyRoutes.dart';
import '../Util/UtilWidgets.dart';


class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int selectedTabPosition = 0;
  late PageController _pageController;
  int _currentIndex = 0;
  List<String> productImages = [];
  Map<String, dynamic>? productDetails;
  String? verifiedBy;
  String? sellerName;
  bool isSelf = false;
  String? verifierId;
  bool isExpanded = false;
  String? userId;
  bool isLoading = true;
  String? sellerId;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _fetchProduct();
  }

  void _navigateLogin() {
    Navigator.pushNamed(context, MyRoutes.LoginPage);
  }

  Future<void> _fetchProduct() async {
    String? token = await TokenManager.getToken();
    if (token == null) {
      _navigateLogin();
      return;
    }

    Map<String, dynamic> jwtDecoded = JwtDecoder.decode(token);
    userId = jwtDecoded['id'];
    var response = await ListProduct.getProductById(userId!, widget.productId);

    if (response != null) {
      productDetails = response['product'];
      verifiedBy = productDetails!['verifiedBy'];
      sellerName = productDetails!['seller'];
      verifierId = productDetails!['verifierId'];
      sellerId = productDetails!['sellerId'];
      productImages = (productDetails!['image'] as List<dynamic>?)
          ?.cast<String>() ??
          [];
      if (productImages.isNotEmpty) {
        Timer.periodic(Duration(seconds: 3), (Timer timer) {
          if (!mounted) return;
          _currentIndex = (_currentIndex + 1) % productImages.length;
          _pageController.animateToPage(
            _currentIndex,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      }

      setState(() {
        isLoading = false;
        isSelf = (verifierId == userId || sellerId ==userId);
      });
    }
  }

  void _verify() async {
    String? token = await TokenManager.getToken();
    if (token == null) return;
    Map<String, dynamic> jwtDecoded = JwtDecoder.decode(token);
    String userId = jwtDecoded['id'];
    await ListProduct.verifyProduct(widget.productId, userId);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || productDetails == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Loading...", style: GoogleFonts.poppins()),
          backgroundColor: UtilitiesPages.pageColor,
          centerTitle: true,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    String title = productDetails!['title'] ?? "No Title";
    String description = productDetails!['description'] ?? "No Description";
    String price = productDetails!['price']?.toString() ?? "N/A";
    Map<String, dynamic> details =
        (productDetails!['details'] as Map<String, dynamic>?) ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: UtilitiesPages.pageColor,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: UtilWidgets.buildBackgroundContainer(
              child: Padding(
                padding: UtilitiesPages.buildPadding(context),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      height: MediaQuery.of(context).size.width * 0.6,
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
                    Expanded(
                      child: SingleChildScrollView(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                )),
                            SizedBox(height: 4),
                            buildExpandableText(description),
                            SizedBox(height: 10),
                            Text("₹ $price",
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            SizedBox(height: 20),
                            Divider(color: Colors.grey[700]),
                            ...details.entries.map((entry) =>
                                _detailRow(entry.key, entry.value.toString())),
                            Divider(color: Colors.grey[700]),
                            if (verifiedBy != null)
                              _detailRow('Verified By', verifiedBy),
                            _detailRow("Seller Name", sellerName),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
              child:
              _customButton("Chat Now", Icons.local_offer,(userId==sellerId) ? Colors.grey: Colors.green,(userId==sellerId)?null: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(senderUserId: userId!, receiverUserId: sellerId!, receiverName: sellerName!)));}, 10),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _customButton(
                (verifiedBy != null || isSelf) ? "Already Verified" : "Verify",
                Icons.verified,
                (verifiedBy != null || isSelf) ? Colors.grey : Colors.deepPurple,
                (verifiedBy != null || isSelf) ? null : _verify,
                10,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _customButton(String text, IconData icon, Color color,
      VoidCallback? onPressed, double sizes) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: screenWidth * 0.045, color: Colors.white),
      label: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
          fontSize: screenWidth * 0.035,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: onPressed == null ? 0 : 5,
        shadowColor: onPressed == null ? Colors.transparent : Colors.black45,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _detailRow(String label, String? value) {
    if (value == null || value.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label: ",
            style: GoogleFonts.poppins(
              color: Colors.lightBlue,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
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
          crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
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
