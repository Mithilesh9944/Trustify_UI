import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'ChatBox.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final String token;

  const ProductDetailsPage({
    Key? key,
    required this.product,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Decode token to get user's mobile number
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String myMobile = decodedToken['mobileNo'];
    
    // Check if the current user is the product owner
    bool isOwner = myMobile == product['ownerMobile'];

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            if (product['imageUrl'] != null)
              Image.network(
                product['imageUrl'],
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    product['name'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Price
                  Text(
                    '₹${product['price']}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product['description'] ?? 'No description available',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  
                  // Owner information
                  Text(
                    'Seller Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Mobile: ${product['ownerMobile']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  
                  // Chat button (only show if not the owner)
                  if (!isOwner)
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatBox(
                                  token: token,
                                  partnerMobile: product['ownerMobile'],
                                  partnerName: 'Product Owner',
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.chat),
                          label: Text('Chat with Seller'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            textStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 