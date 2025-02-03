import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://10.0.2.2:3000/api/v1";
  static Future<bool> RegisterUser(Map<String, dynamic> userData) async {
    print(userData);
    try {
    var postUrl = Uri.parse('$baseUrl/registerUser');

      final res = await http.post(postUrl, headers: {
      "Content-Type": "application/json",
  },
  body: jsonEncode(userData),);
      if (res.statusCode == 200) {
        print("user register succesfully");
        return true;
      } else {
        print("somthing wrong please try again");
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
  static Future<bool>  LoginUser(Map<String, dynamic> userData) async {
    print(userData);
    try {
      var queryParams = userData.entries
          .map((e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
          .join('&');
      var getUrl = Uri.parse('$baseUrl/login?$queryParams');

      final response = await http.get(
        getUrl,
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic>userData = jsonDecode(response.body);
        print(userData);
        return true;

      } else {
        print("User Not found");
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
  static AddContacts(Map<String, dynamic> userData) async{
     try {
    var postUrl = Uri.parse('$baseUrl/updateContactList');

      final res = await http.post(postUrl, headers: {
      "Content-Type": "application/json",
  },
  body: jsonEncode(userData),);
      if (res.statusCode == 200) {
        print("user's contact list updated succesfully");
      } else {
        print("somthing wrong please try again");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
