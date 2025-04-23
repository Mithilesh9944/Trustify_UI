// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:flutter_project/Pages/ContactDetailsPage.dart';
// import 'package:flutter_project/Util/UtilAppDrawer.dart';
// import 'package:flutter_project/Util/UtilWidgets.dart';
// import 'package:flutter_project/Services/api_service.dart';
// import 'package:flutter_project/Security/SecurityDetails.dart';

// import '../Util/MyRoutes.dart';
// import '../Util/UtilPages.dart';

// class MyContactReadPage extends StatefulWidget {
//   const MyContactReadPage({super.key});

//   @override
//   _MyContactReadPageState createState() => _MyContactReadPageState();
// }

// class _MyContactReadPageState extends State<MyContactReadPage> {
//   int _selectedTabPosition = 0;
//   List<Contact>? _contacts;
//   List<String>? _normalisedContact;
//   bool _permissionDenied = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchContacts();
//   }

//   Future _fetchContacts() async {
//     if (!await FlutterContacts.requestPermission(readonly: true)) {
//       setState(() => _permissionDenied = true);
//     } else {
//       final contacts = await FlutterContacts.getContacts();
//       setState(() => _contacts = contacts);
//       _contactList();

//     }
//   }
  

//   @override
//   @override
//   Widget build(BuildContext context) => MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: UtilWidgets.buildAppBar(
//             title: 'Messenger', icon: Icons.chat, context: context),
//         body: UtilWidgets.buildBackgroundContainer(child: _body()),
//         drawer: AppDrawer(imgPath: "assets/profile.png",email: "xyz@gmail.com",mobile_no: "+91XXXXXXXXXX",),
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _selectedTabPosition,
//           onTap: (index) {
//             if (index != 2) {
//               setState(() {
//                 _selectedTabPosition = index;
//               });
//             }
//           },
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: Colors.teal,
//           unselectedItemColor: Colors.black12,
//           items: [
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.chat),
//                 label: 'Chats',
//                 backgroundColor: Colors.transparent),
//             BottomNavigationBarItem(icon: SizedBox.shrink(), label: 'Sell'),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.favorite), label: 'My Ads'),
//             BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//           ],
//           selectedLabelStyle: TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.bold,
//               color: Colors.lightBlueAccent),
//           unselectedLabelStyle: TextStyle(
//             fontSize: 13,
//             color: Colors.black,
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             setState(() {
//               _selectedTabPosition = 2;
//             });
//             Navigator.pushNamed(context, MyRoutes.CategoryList);
//           },
//           child: const Icon(
//             Icons.add,
//             size: 50,
//           ),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       ));

//   Widget _body() {
//     if (_permissionDenied) return Center(child: Text('Permission denied'));
//     if (_contacts == null) return Center(child: CircularProgressIndicator());
//     return Padding(
//       padding: UtilitiesPages.buildPadding(context),
//       child: ListView.builder(
//           itemCount: _contacts!.length,
//           itemBuilder: (context, i) => ListTile(
//               title: Text(_contacts![i].displayName),
//               onTap: () async {
//                 final fullContact =
//                     await FlutterContacts.getContact(_contacts![i].id);
//                 await Navigator.of(context).push(MaterialPageRoute(
//                     builder: (_) => MyContactDetails(fullContact!)));
//               })),
//     );
//   }

//   void _contactList() async {
//     _normalisedContact = [];

//     if (_contacts != null) {
//       for (int i = 0; i < _contacts!.length; i++) {
//         final fcontact = await FlutterContacts.getContact(_contacts![i].id);
//         if (fcontact!.phones.isNotEmpty) {
//           _normalisedContact!.add(fcontact.phones.first.normalizedNumber);

//         }
//       }
//       ApiService.AddContacts({
//         "mobileNo": Details.mobile,
//         "contactsList": _normalisedContact
//       });
//     }
//     print(_normalisedContact);
//     if (context.mounted) {
//       Navigator.pushReplacementNamed(context, MyRoutes.Dashboard);
//     }
//   }
// }
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
        "contactsList": normalized,
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

