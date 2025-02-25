import 'package:flutter/material.dart';

class MyHelpSupportScreen extends StatelessWidget {
  const MyHelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        children: [
          _buildListTile(
            title: 'Help Center',
            subtitle: 'See FAQ and contact support',
            onTap: () {
              // Add navigation or action here
            },
          ),
          _buildListTile(
            title: 'Rate us',
            subtitle: 'If you love our app, please take a moment to rate it',
            onTap: () {
              // Add navigation or action here
            },
          ),
          _buildListTile(
            title: 'Invite friends to Trustify',
            subtitle: 'Invite your friends to buy and sell',
            onTap: () {
              // Add navigation or action here
            },
          ),
          _buildListTile(
            title: 'Become a beta tester',
            subtitle: 'Test new features in advance',
            onTap: () {
              // Add navigation or action here
            },
          ),

          ListTile(
            title: const Text('Version'),
            subtitle: const Text('19.19.005'),
          ),
        ],
      ),
    );
  }


  Widget _buildListTile({
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}