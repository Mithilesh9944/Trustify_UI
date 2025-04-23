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
  int _selectedTabPosition = 0;
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
    String? mobileNO = jwtDecoded['mobileNo'];

    var response = await ListProduct.getProduct({"mobileNo": mobileNO});
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
            var elementId = product['elementId']; // En sure 'elementId' exists
            if (elementId != null) {
              uniqueProducts[elementId] =
                  product; // Store unique products by elementId
            }
          }
        }
      }
      print(uniqueProducts);

      isLoading = false;
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
                          var product = products[index];
                          var properties = product['properties'] ?? {};

                          String title = properties['p_title'] ?? "No Title";
                          String description =
                              properties['p_description'] ?? "No Description";
                          String brand = properties['brand'] ?? "Unknown Brand";
                          String price =
                              properties['price']?.toString() ?? "N/A";
                          List<dynamic>? images = properties['p_img'];

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
                                        ProductDetailPage(product: product),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 200, 240, 250),
          currentIndex: _selectedTabPosition,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, MyRoutes.Dashboard);
                break;
              case 1:
                Navigator.pushNamed(context, MyRoutes.Dashboard);
                break;
              case 2:
                Navigator.pushNamed(context, MyRoutes.CategoryPage);
                break;
              case 3:
                Navigator.pushNamed(context, MyRoutes.Dashboard);
                break;
              case 4:
                Navigator.pushNamed(context, MyRoutes.Profile);
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.black12,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_sharp), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
            BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'My Ads'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _selectedTabPosition = 2;
            });
            Navigator.pushNamed(context, MyRoutes.CategoryPage);
          },
          child: const Icon(
            Icons.add,
            size: 50,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
}
