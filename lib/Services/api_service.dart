import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class ApiService {
 
  static const baseUrl = "http://10.0.2.2:3000/api/v1";
  //static const baseUrl = "https://trustify-backend.onrender.com/api/v1";
  static Future<bool> RegisterUser(Map<String, dynamic> userData,Uint8List? imgBytes) async {
    print(userData);
     String? imgUrl;
    if(imgBytes!=null){
    imgUrl = await uploadImageOnCloudinary(imgBytes);

    }
    else{
      imgUrl= await uploadImageOnCloudinary(await loadDefaultImage());

    }
   userData['img_url']=imgUrl;
   print("img_url");
   print(imgUrl);
    try {
      var postUrl = Uri.parse('$baseUrl/registerUser');

      final res = await http.post(
        postUrl,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(userData),
      );
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

  static Future<dynamic> LoginUser(Map<String, dynamic> userData) async {
    //print(userData); //print data for checking 
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
      // if (response.statusCode == 200) {
      //   var  jsonResponse = jsonDecode(response.body);
      //   return true;
      // } else {
      //   print("User Not found");
      //   return false;
      // }
      var  jsonResponse = jsonDecode(response.body);
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
  static Future<String?> uploadImageOnCloudinary(Uint8List imgBytes) async{
    final uri = Uri.parse("https://api.cloudinary.com/v1_1/dvfz67hyi/image/upload");
    var request=http.MultipartRequest('POST',uri)
     ..fields['upload_preset'] = "Trustify_preset"
     ..fields['folder'] = 'UserProfile'
    ..files.add(http.MultipartFile.fromBytes(
      'file', 
      imgBytes,
      filename: "userprofile.jpg", // Cloudinary requires a filename
    ));
    var response = await request.send();
      if (response.statusCode == 200) {
    final responseData = await response.stream.bytesToString();
    final imageUrl = jsonDecode(responseData)['secure_url'];
    return imageUrl;
  } else {
    print("Failed to upload image: ${response.statusCode}");
    return null;
  }
  }
  static Future<Uint8List> loadDefaultImage() async {
  final ByteData data = await rootBundle.load('assets/userIcon.png');
  return data.buffer.asUint8List();
}
}