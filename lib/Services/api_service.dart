import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {

  //static const baseUrl = "http://10.0.2.2:3000/api/v1";
  static const baseUrl = "https://trustify-backend-csm6.onrender.com/api/v1";
  static Future<dynamic> registerUser(Map<String, dynamic> userData,Uint8List? imgBytes) async {
    //print(userData);
    String? _imgUrl;
    if(imgBytes!=null){
      _imgUrl = await uploadImageOnCloudinary(userData['name'],imgBytes);

    }
    userData['profileImg'] = _imgUrl;

    try {
      var postUrl = Uri.parse('$baseUrl/register');

      final response = await http.post(
        postUrl,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(userData),
      );
      if (response.statusCode == 200) {
        print("user register succesfully");
        return jsonDecode(response.body) ;
      } else {
        print("somthing wrong please try again");
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<dynamic> loginUser(Map<String, dynamic> userData) async {
    print(userData); //print data for checking
    try {
      var getUrl = Uri.parse('$baseUrl/login');

      final response = await http.post(
        getUrl,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(userData),
      );
      // if (response.statusCode == 200) {
      //   var  jsonResponse = jsonDecode(response.body);
      //   return true;
      // } else {
      //   print("User Not found");
      //   return false;
      // }
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static AddContacts(Map<String, dynamic> userData) async {
    try {
      var postUrl = Uri.parse('$baseUrl/updateContactList');
      final res = await http.post(
        postUrl,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(userData),
      );
      if (res.statusCode == 200) {
        print("user's contact list updated succesfully");
      } else {
        print("somthing wrong please try again");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<String?> uploadImageOnCloudinary(
      String name, Uint8List imgBytes) async {
    final uri =
    Uri.parse("https://api.cloudinary.com/v1_1/dvfz67hyi/image/upload");
    var request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = "Trustify_preset"
      ..fields['folder'] = 'UserProfile'
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        imgBytes,
        filename: "$name.jpg", // Cloudinary requires a filename
      ));
    var response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final imageUrl = jsonDecode(responseData)['secure_url'];
      return imageUrl;
    } else {
      // print("Failed to upload image: ${response.statusCode}");
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getChatList(String currentUserId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/chat/list/$currentUserId"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["success"] == true) {
          final List<dynamic> chatList = data["chatList"];

          return chatList.map<Map<String, dynamic>>((chat) {
            return {
              "receiverId": chat["partnerId"],
              "receiverName": chat["partnerName"],
              "lastMessage": chat["lastMessage"]["text"],
              "time": chat["lastMessage"]["timestamp"],
            };
          }).toList();
        }
      }
      return [];
    } catch (e) {
      print("Error fetching chats: $e");
      return [];
    }
  }
  static Future<List<Map<String, dynamic>>> getIndividualMessages(
      String senderId, String receiverId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/chat/messages"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "senderId": senderId,
          "receiverId": receiverId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["success"] == true) {
          final List<dynamic> messages = data["messages"];

          return messages.map<Map<String, dynamic>>((msg) {
            return {
              "senderId": msg["senderId"],
              "senderName": msg["senderName"],
              "receiverId": msg["receiverId"],
              "receiverName": msg["receiverName"],
              "text": msg["text"],
              "timestamp": msg["timestamp"],
              "read": msg["read"] ?? false,
            };
          }).toList();
        }
      }
      return [];
    } catch (e) {
      print("Error fetching messages: $e");
      return [];
    }
  }


}