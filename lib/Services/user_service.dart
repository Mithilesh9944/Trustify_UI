import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_project/Security/TokenManager.dart';
import 'package:flutter_project/Services/api_service.dart';

class UserService {

  static Future<Map<String, dynamic>?> updateProfile(
      Map<String, dynamic> profileData) async {
    try {
      String? token = await TokenManager.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'User not authenticated',
          'data': null
        };
      }

      final response = await http.put(
        Uri.parse('${ApiService.baseUrl}/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(profileData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': 'Profile updated successfully',
          'data': data
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to update profile',
          'data': null
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e', 'data': null};
    }
  }

  static Future<Map<String, dynamic>?> updateProfileImage(
      Uint8List imageBytes) async {
    try {
      String? token = await TokenManager.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'User not authenticated',
          'data': null
        };
      }

      // Upload image to Cloudinary
      String? imageUrl =
          await ApiService.uploadImageOnCloudinary('profile', imageBytes);
      if (imageUrl == null) {
        return {
          'success': false,
          'message': 'Failed to upload image',
          'data': null
        };
      }

      // Update profile with new image URL
      final response = await http.put(
        Uri.parse('${ApiService.baseUrl}/user/profile/image'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'profileImg': imageUrl}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': 'Profile image updated successfully',
          'data': data
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to update profile image',
          'data': null
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e', 'data': null};
    }
  }

  static Future<Map<String, dynamic>?> updatePassword(
      String currentPassword, String newPassword) async {
    try {
      String? token = await TokenManager.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'User not authenticated',
          'data': null
        };
      }

      final response = await http.put(
        Uri.parse('${ApiService.baseUrl}/user/password'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            {'currentPassword': currentPassword, 'newPassword': newPassword}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': 'Password updated successfully',
          'data': data
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to update password',
          'data': null
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e', 'data': null};
    }
  }

  static Future<Map<String, dynamic>?> verifyUserForPasswordReset(
      String email, String mobile) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/verify-reset'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'mobile': mobile,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
    
        return {
          'success': true,
          'message': 'User verified successfully',
          'data': data
        };
      } else {
  
        return {
          'success': false,
          'message': 'Failed to verify user',
          'data': null
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e', 'data': null};
    }
  }

  static Future<Map<String, dynamic>?> resetPassword(
      String mobile, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/reset-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'mobile': mobile,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': 'Password reset successfully',
          'data': data
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to reset password',
          'data': null
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e', 'data': null};
    }
  }
}