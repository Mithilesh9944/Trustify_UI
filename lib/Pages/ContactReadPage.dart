import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_project/Services/api_service.dart';
import 'package:flutter_project/Security/SecurityDetails.dart';
import '../Util/MyRoutes.dart';

class ContactReadPage extends StatefulWidget {
  const ContactReadPage({super.key});

  @override
  _ContactReadPageState createState() => _ContactReadPageState();
}

class _ContactReadPageState extends State<ContactReadPage> {
  @override
  void initState() {
    super.initState();
    _handlePermissionAndProceed();
  }

  Future<void> _handlePermissionAndProceed() async {
    bool granted = await FlutterContacts.requestPermission(readonly: true);

    if (granted) {
      final contacts = await FlutterContacts.getContacts();
      List<String> normalized = [];

      for (final contact in contacts) {
        final fullContact = await FlutterContacts.getContact(contact.id);
        if (fullContact != null && fullContact.phones.isNotEmpty) {
          normalized.add(fullContact.phones.first.normalizedNumber);
        }
      }

      // Send to backend (non-blocking)
      ApiService.AddContacts({
        "mobileNo": Details.mobile,
        "contacts": normalized,
      });
    }

    // Navigate regardless of permission result
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, MyRoutes.Dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(), // Optional loader
      ),
    );
  }
}

