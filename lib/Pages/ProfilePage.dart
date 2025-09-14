import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_project/Security/TokenManager.dart';
import 'package:flutter_project/Services/user_service.dart';
import 'package:flutter_project/Util/MyRoutes.dart';

import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../Util/UtilWidgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;
  String? name;
  String? email;
  String? profileImg;
  bool isEditing = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    setState(() => isLoading = true);

    try {
      String? token = await TokenManager.getToken();
      if (token != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        setState(() {
          name = decodedToken['name'];
          email = decodedToken['email'];
          profileImg = decodedToken['profileImg'];
          nameController.text = name ?? '';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profile: $e')),
      );
    }
  }

  // Future<void> _updateProfile() async {
  //   if (nameController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Name cannot be empty')),
  //     );
  //     return;
  //   }

  //   setState(() => isLoading = true);

  //   try {
  //     final response = await UserService.updateProfile({'name': nameController.text});

  //     if (response != null && response['success']) {
  //       setState(() {
  //         name = nameController.text;
  //         isEditing = false;
  //         isLoading = false;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Profile updated successfully')),
  //       );
  //     } else {
  //       setState(() => isLoading = false);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(response?['message'] ?? 'Failed to update profile')),
  //       );
  //     }
  //   } catch (e) {
  //     setState(() => isLoading = false);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error updating profile: $e')),
  //     );
  //   }
  // }

  Future<void> _updatePassword() async {
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All password fields are required')),
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New passwords do not match')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await UserService.updatePassword(
        currentPasswordController.text,
        newPasswordController.text,
      );

      if (response != null && response['success']) {
        setState(() => isLoading = false);
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')),
        );
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response?['message'] ?? 'Failed to update password')),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating password: $e')),
      );
    }
  }

  Future<void> _pickAndUpdateImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() => isLoading = true);

        final response = await UserService.updateProfileImage(
          await File(image.path).readAsBytes(),
        );

        if (response != null && response['success']) {
          setState(() {
            profileImg = response['data']['profileImg'];
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile image updated successfully')),
          );
        } else {
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response?['message'] ?? 'Failed to update profile image')),
          );
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile image: $e')),
      );
    }
  }

  void _showPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: const InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm New Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              currentPasswordController.clear();
              newPasswordController.clear();
              confirmPasswordController.clear();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updatePassword();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UtilWidgets.buildAppBar(title: 'Profile', icon: Icons.notifications, context: context,route:MyRoutes.NotificationPage,back: true),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickAndUpdateImage,
              child: Stack(
                children: [
                  ClipOval(
                    child: profileImg != null && profileImg!.isNotEmpty
                        ? Image.network(
                      profileImg!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[300],
                          child: const Icon(Icons.person, size: 50),
                        );
                      },
                    )
                        : Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.person, size: 50),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 109, 190, 231),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            isEditing
                ? TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            )
                : Text(
              name ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              email ?? '',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _showPasswordDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 109, 190, 231),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Change Password',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                profileTile(Icons.shopping_bag, "My Posts", MyRoutes.MyProducts),
                const Divider(),
                profileTile(Icons.location_on, "Address", ''),
                const Divider(),
                profileTile(Icons.settings, "Settings", ''),
                const Divider(),
                profileTile(Icons.help_outline, "Help", MyRoutes.HelpPage),
                const Divider(),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _logOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 109, 190, 231),
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileTile(IconData icon, String title, String routeName) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: UtilWidgets.buildText(text: title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        if (routeName.isNotEmpty) {
          Navigator.pushNamed(context, routeName);
        }
      },
    );
  }

  void _logOut() async {
    await TokenManager.removeToken();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, MyRoutes.LoginPage, (route) => false);
    }
  }
}
