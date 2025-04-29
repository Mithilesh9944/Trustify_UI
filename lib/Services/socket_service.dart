import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_project/main.dart'; // For notification plugin
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class SocketService {
  //static const _baseUrl = 'http://10.0.2.2:3000';
  static const _baseUrl = "https://trustify-backend.onrender.com";
  static IO.Socket? socket;
  static List<Map<String, String>> notifications = [];

  static void connect(String userId) {
    socket = IO.io(_baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket?.connect();
    print("Socket connected: ${socket?.id}");

    socket?.onConnect((_) {
      print('Connected to socket server');
      // Ensure the mobileNo is passed properly
      socket?.emit('register', userId);
    });

    socket?.on('receiveNotification', (data) {
      print('Notification received: $data');
      _showLocalNotification('New Product Added', data['message']);

      // Save in notifications list
      notifications.add({
        'title': 'New Product Added',
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

    var generalNotificationDetails =
        NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(
      0,
      title,
      body,
      generalNotificationDetails,
    );
  }

  static Future<dynamic> getNotification(String userId) async {
    print("user notification fetching at getProduct UI");
    print(userId);
    try {
      var getUrl = Uri.parse(
          '$_baseUrl/api/v1/notification/notifications?userId=$userId');

      final response = await http.get(
        getUrl,
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        return response.body;
      }
      print("Internal server error");
      return null;
    } catch (error) {
      print("HTTP error: ${error.toString()}");
      return null;
    }
  }
}
