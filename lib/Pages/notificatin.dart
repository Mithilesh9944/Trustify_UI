import 'package:flutter/material.dart';
import 'package:flutter_project/Util/UtilPages.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Services/socket_service.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var notifications = SocketService.notifications;

    return Scaffold(
      appBar: AppBar(
        title:Text('Notifications',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: UtilitiesPages.APP_BAR_COLOR,
      ),

      body: notifications.isEmpty
          ? Center(child: Text('No notifications yet.'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text(notification['title'] ?? ''),
                  subtitle: Text(notification['message'] ?? ''),
                );
              },
            ),
    );
  }
}
