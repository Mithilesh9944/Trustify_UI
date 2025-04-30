import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_project/Pages/TokenManager.dart';
import 'package:flutter_project/Services/api_service.dart';
import '../Util/MyRoutes.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


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
     String? token =  await  TokenManager.getToken();
     Map<String, dynamic> jwtDecoded = JwtDecoder.decode(token!);
    String? mobileNo = jwtDecoded['mobileNo'];
    if (granted) {
      final contacts = await FlutterContacts.getContacts();
      List<String> normalized = [];

      for (final contact in contacts) {
        final fullContact = await FlutterContacts.getContact(contact.id);
        if (fullContact != null && fullContact.phones.isNotEmpty) {
          normalized.add(fullContact.phones.first.normalizedNumber);
        }
      }
      ApiService.AddContacts({
        "mobileNo": mobileNo,
        "contacts": normalized,
      });
    }

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
/*
tushar-
{
    "status": true,
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImJhZTdlN2RkLTkzNTEtNDU5Mi05OGE1LWY1NzA3ODQ0MDlkZCIsIm5hbWUiOiJ2aWNreSIsIm1vYmlsZU5vIjoiNDQ0NDQ0NDQ0NCIsImVtYWlsIjoidmlja3lAZ21haWwuY29tIiwiaWF0IjoxNzQ1NjE4NDE5LCJleHAiOjE3NDU3MDQ4MTl9.2lcZoPitXanE6iV8dkw635S_7vUF6EavfJhn5DkuyRs",
    "id": "bae7e7dd-9351-4592-98a5-f570784409dd"
}
paji-
{
    "status": true,
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Ijg1NDQyNTIwLTZmMDgtNGRiOC05NjVkLTk5MmQ3OTBhOGQzMiIsIm5hbWUiOiJwYWppIiwibW9iaWxlTm8iOiI0NDQ0NDY2NjY2IiwiZW1haWwiOiJwYWppQGdtYWlsLmNvbSIsImlhdCI6MTc0NTYyMDU0OSwiZXhwIjoxNzQ1NzA2OTQ5fQ.2_a0c5XV3tQJqhwUr0gWzF4_M3XM45CpTeC19lji-vU",
    "id": "85442520-6f08-4db8-965d-992d790a8d32"
}
*/