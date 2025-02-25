import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_project/Util/MyRoutes.dart';

import '../Util/UtilPages.dart';
import '../Util/UtilWidgets.dart';

class MyContactDetails extends StatefulWidget {
  final Contact contact;
  const MyContactDetails(this.contact, {super.key});

  @override
  State<MyContactDetails> createState() => _MyContactDetailsState();
}

class _MyContactDetailsState extends State<MyContactDetails> {
  int _selectedTabPosition =0;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar:
    UtilWidgets.buildAppBar(title: widget.contact.displayName, icon: Icons.call,context: context),
    //drawer: AppDrawer(imgPath: widget.contact.photo),
    body: UtilWidgets.buildBackgroundContainer(
      child: Padding(
        padding: UtilitiesPages.buildPadding(context),
        child: Center(
          child: Column(children: [
            Text('First name: ${widget.contact.name.first}'),
            Text('Last name: ${widget.contact.name.last}'),
            Text(
                'Phone number: ${widget.contact.phones.isNotEmpty ? widget.contact.phones.first.normalizedNumber : '(none)'}'),
            Text(
                'Email address: ${widget.contact.emails.isNotEmpty ? widget.contact.emails.first.address : '(none)'}'),
          ]),
        ),
      ),
    ),
    bottomNavigationBar: BottomNavigationBar(
      backgroundColor: Color.fromARGB(255, 200, 240, 250),
      currentIndex: _selectedTabPosition,
      onTap: (index) {
        if (index != 2) {
          setState(() {
            _selectedTabPosition = index;
          });
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.black12,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_sharp), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
        BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite), label: 'My Ads'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        setState(() {
          _selectedTabPosition = 2;
        });
        Navigator.pushNamed(context, MyRoutes.AllCategoryPage);
      },
      child: const Icon(
        Icons.add,
        size: 50,
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  );
}