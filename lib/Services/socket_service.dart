import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class SocketService {
  static const baseUrl = "http://10.0.2.2:3000/api/v1"; // Change to your production URL when necessary.

  static Future<List<Map<String, dynamic>>> getChatHistory({
    required String token,
  }) async {
    try {
      // Decode the token to get your mobile number
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String myMobile = decodedToken['mobileNo']; // Assuming payload has 'mobileNo'

      // Use the new chat list endpoint
      var getUrl = Uri.parse('$baseUrl/chats/list?mobile=$myMobile');

      final res = await http.get(
        getUrl,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        try {
          List data = json.decode(res.body);
          
          // Convert the data to the format expected by the UI
          List<Map<String, dynamic>> chatList = data.map<Map<String, dynamic>>((chat) => {
            'senderMobile': chat['partnerMobile'],
            'message': chat['lastMessage'],
            'timestamp': chat['timestamp'],
          }).toList();

          print("✅ Chats fetched successfully: ${chatList.length} conversations");
          return chatList;
        } catch (e) {
          debugPrint("❌ Error parsing chat history: $e");
          return [];
        }
      } else {
        print("❌ Something wrong: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("❌ Error fetching chat history: $e");
      return [];
    }
  }
  
  // Get messages for a specific chat
  static Future<List<Map<String, dynamic>>> getMessages({
    required String token,
    required String mobile1,
    required String mobile2,
  }) async {
    try {
      var getUrl = Uri.parse('$baseUrl/chats/messages?mobile1=$mobile1&mobile2=$mobile2');

      final res = await http.get(
        getUrl,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        try {
          List data = json.decode(res.body);
          
          // Convert the data to the format expected by the UI
          List<Map<String, dynamic>> messages = data.map<Map<String, dynamic>>((msg) => {
            'message': msg['message'],
            'senderMobile': msg['from'],
            'timestamp': msg['timestamp'],
          }).toList();

          print("✅ Messages fetched successfully: ${messages.length} messages");
          return messages;
        } catch (e) {
          debugPrint("❌ Error parsing messages: $e");
          return [];
        }
      } else {
        print("❌ Something wrong: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("❌ Error fetching messages: $e");
      return [];
    }
  }
  
  // Save a message
  static Future<bool> saveMessage({
    required String token,
    required String senderMobile,
    required String receiverMobile,
    required String message,
  }) async {
    try {
      var postUrl = Uri.parse('$baseUrl/chats/save');

      final res = await http.post(
        postUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'senderMobile': senderMobile,
          'receiverMobile': receiverMobile,
          'message': message,
        }),
      );

      if (res.statusCode == 200) {
        print("✅ Message saved successfully");
        return true;
      } else {
        print("❌ Something wrong: ${res.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Error saving message: $e");
      return false;
    }
  }
}
