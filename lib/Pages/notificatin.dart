import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/ProductDetailPage.dart';
import 'package:flutter_project/Pages/TokenManager.dart';
import 'package:flutter_project/Services/ListProduct.dart';
import 'package:flutter_project/Util/UtilPages.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../Services/socket_service.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage();

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  void getUserId() async {
    String? token = await TokenManager.getToken();
    Map<String, dynamic> jwtDecoded = JwtDecoder.decode(token!);
    String? userId = jwtDecoded['id'];
    await loadNotifications(userId!);
  }

  Future<void> loadNotifications(String userId) async {
    try {
      var response = await SocketService.getNotification(userId);

      if (response != null && response is String) {
        final List<dynamic> parsed = jsonDecode(response);

        setState(() {
          notifications = parsed.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void openProductDetail(String productId) async {
    var response = await ListProduct.getProductById(productId);
    if (response != null) {
      final Map<String, dynamic> parsed = jsonDecode(response);

      if (parsed['success'] == true &&
          parsed['data'] is List &&
          parsed['data'].isNotEmpty) {
        final productWithSeller = parsed['data'][0];
        final Map<String, dynamic> product =
            Map<String, dynamic>.from(productWithSeller['products'][0]);

        final Map<String, dynamic> seller = {
          'Name': productWithSeller['contactName'],
          'Mobile': productWithSeller['contactMobile'],
        };

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetailPage(product: product, seller: seller),
            ));
      } else {
        print("No product found or bad format.");
      }
    } else {
      print("Failed to fetch product.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: UtilitiesPages.APP_BAR_COLOR,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(child: Text('No notifications yet.'))
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text(
                        notification['title'] ?? 'Welcome to Trustify',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        notification['message'] ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                        ),
                        ),
                      trailing: Text(notification['timestamp'] ?? ''),
                      onTap: () {
                        if (notification['productId'] != null) {
                          openProductDetail(notification['productId']);
                        }
                      },
                    );
                  },
                ),
    );
  }
}
