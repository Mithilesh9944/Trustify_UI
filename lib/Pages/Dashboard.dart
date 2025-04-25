import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/ProductDetailPage.dart';
import 'package:flutter_project/Pages/TokenManager.dart';
import 'package:flutter_project/Services/ListProduct.dart';
import 'package:flutter_project/Util/MyRoutes.dart';
import '../Util/UtilPages.dart';
import '../Util/UtilWidgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedTabPosition = 0;
  List<dynamic> products = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    String? token = await TokenManager.getToken();
    if (token == null) {
      _navigateLogin();
      return;
    }

    Map<String, dynamic> jwtDecoded = JwtDecoder.decode(token);
    String? mobileNo = jwtDecoded['mobileNo'];

    var response = await ListProduct.getProduct({"mobileNo": mobileNo});
    print("Fetched Products: ");

    if (!mounted) return;

    if (response != null &&
        response['success'] == true &&
        response['data'] is List) {
      List<dynamic> sellers = response['data'];
      Map<dynamic, dynamic> uniqueProducts = {}; // Store products by ID

      for (var seller in sellers) {
        if (seller["products"] is List) {
          for (var product in seller["products"]) {
            var elementId = product['id']; // En sure 'elementId' exists
            if (elementId != null) {
              uniqueProducts[elementId] = {
                'seller': {
                  'Name': seller['contactName'],
                  'Mobile': seller['contactMobile'],
                },
                'product': product,
              };
              // Store unique products by elementId
            }
          }
        }
      }
      print(uniqueProducts);
      setState(() {
        products = uniqueProducts.values.toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load products")),
      );
    }
  }

  void _navigateLogin() {
    Navigator.pushNamed(context, MyRoutes.LoginPage);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: UtilWidgets.buildAppBar(
            title: "Products", icon: Icons.shopping_cart, context: context),
        body: UtilWidgets.buildBackgroundContainer(
          child: Padding(
            padding: UtilitiesPages.buildPadding(context),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : products.isEmpty
                    ? Center(child: Text("No products available"))
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          var productData = products[index];
                          var product = productData['product'];
                          var seller = productData['seller'];
                          String title = product['title'] ?? "No Title";
                          String description =
                              product['description'] ?? "No Description";
                          String brand =
                              (product['details'] as Map?)?['brand'] ??
                                  'Unknown Brand';
                          String price = product['price']?.toString() ?? "N/A";
                          List<dynamic>? images = product['image'];

                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(10),
                              leading: images != null && images.isNotEmpty
                                  ? Image.network(
                                      images[0],
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(Icons.image, size: 50),
                              title: Text(title,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Brand: $brand",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700])),
                                  Text("Price: ₹$price",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.green)),
                                  Text(description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailPage(product: product,seller:seller),
                                  ),
                                );
                              },
                            ),
                          );
                        },
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
            context: context),
        floatingActionButton: UtilWidgets.createFloatingActionButton(
            context: context,
            onTabChange: () {
              setState(() {
                selectedTabPosition = 2;
              });
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
}
