import 'package:flutter/material.dart';
import '../Services/socket_service.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var notifications = SocketService.notifications;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
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
