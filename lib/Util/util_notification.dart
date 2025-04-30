import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_project/Util/MyRoutes.dart';
import 'package:flutter_project/Util/UtilWidgets.dart';
import 'package:flutter_project/main.dart';
import 'package:permission_handler/permission_handler.dart';

class MyNotification extends StatefulWidget {
  const MyNotification({super.key});

  @override
  State<MyNotification> createState() => _MyNotificationState();
}

class _MyNotificationState extends State<MyNotification> {

  void showNotification() async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      "user_logging", // channelId
      "User LogIn",   // channelName
      priority: Priority.max,
      importance: Importance.max,
    );

    NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(
      0,
      "Product is Added",
      "Hello welcome To A Trusted Seller Application",
      notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UtilWidgets.buildAppBar(title: 'Trustify', icon: Icons.home, context: context, route: MyRoutes.Dashboard, back: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNotification();
        },
        child: Icon(Icons.notification_add),
      ),
      body: Center(
        child: Text(
          'Coming Soon...',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

Future<void> notificationPermission() async {
  var status = await Permission.notification.status;

  if (status.isGranted) {
    print("Notification permission is Granted");
    return;
  }

  if (status.isDenied) {
    final result = await Permission.notification.request();

    if (result.isGranted) {
      print("Permission is given");
    } else if (result.isDenied) {
      print("Permission is not given");
    }
  }
}
