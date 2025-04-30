import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'ChatBox.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final Map<String, dynamic> seller;

  const ProductDetailPage({super.key, required this.product,required this.seller});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}
class _ProductDetailPageState extends State<ProductDetailPage> {
  int selectedTabPosition = 0;
  late PageController _pageController;
  int _currentIndex = 0;
  late List<String> productImages;
  late Map<String, dynamic> productDetails;
  late Map<String, dynamic> seller;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    seller = widget.seller;
    productDetails = widget.product;
    productImages =
        (productDetails['image'] as List<dynamic>?)?.cast<String>() ?? [];

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
    // Decode token to get user's mobile number
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String myMobile = decodedToken['mobileNo'];
    
    // Check if the current user is the product owner
    bool isOwner = myMobile == product['ownerMobile'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          productDetails['title'] ?? "Details",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: UtilitiesPages.pageColor,
        centerTitle: true,
      ),
      //backgroundColor: UtilitiesPages.APP_BAR_COLOR,
      body: Stack(
        children: [
          // Scrollable content
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
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productDetails['title'] ?? "No Title",
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              buildExpandableText(
                                  productDetails['description'] ??
                                      "No Description"),
                              SizedBox(height: 10),
                              Text(
                                "₹ ${productDetails['price']?.toString() ?? 'N/A'}",
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 20),
                              Divider(color: Colors.grey[700]),
                              ...(productDetails['details'] as Map<String, dynamic>)
                                  .entries
                                  .map(
                                    (entry) =>
                                    _detailRow(entry.key, entry.value.toString()),
                              ),
                              SizedBox(
                                  height:
                                      20),
                              Divider(color: Colors.grey[700]),
                              _detailRow("Seller Name", seller['Name']),
                              SizedBox(height: 20),
                              // extra space to avoid overlap with bottom buttons
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Fixed bottom buttons
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
              child: _customButton("Make Offer", Icons.local_offer, Colors.green, (){},10),
            ),
            SizedBox(width: 16,),
            Expanded(
              child: _customButton("Verify", Icons.verified, Colors.deepPurple, (){},10),
            )
          ],
        ),
      ),
    );
  }

  Widget _customButton(String text, IconData icon, Color color,
      VoidCallback onPressed, double sizes) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = MediaQuery.of(context).size.width;
        double buttonFontSize = screenWidth * 0.035; // Adjust font size
        double iconSize = screenWidth * 0.045; // Adjust icon size
        double horizontalPadding = screenWidth * 0.04; // Padding

        return ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 5,
            shadowColor: Colors.black45,
          ),
          icon: Icon(
            icon,
            color: Colors.white,
            size: iconSize,
          ),
          label: Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: buttonFontSize,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
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
