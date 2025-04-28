import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_project/main.dart'; // For notification plugin
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class SocketService {
  static IO.Socket? socket;
  static List<Map<String, String>> notifications = [];

  static void connect(String mobileNo) {
    socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket?.connect();
    print("Socket connected: ${socket?.id}");
    
    socket?.onConnect((_) {
      print('Connected to socket server');
      // Ensure the mobileNo is passed properly
      socket?.emit('register', mobileNo);
    });

    socket?.on('notification', (data) {
      print('Notification received: $data');
      _showLocalNotification(data['title'], data['message']);
      
      // Save in notifications list
      notifications.add({
        'title': data['title'],
        'message': data['message'],
      });
    });

    socket?.onDisconnect((_) {
      print('Disconnected from socket server');
    });
  }

  static void _showLocalNotification(String title, String body) async {
    var androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'Realtime Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(
      0,
      title,
      body,
      generalNotificationDetails,
    );
  }
}
