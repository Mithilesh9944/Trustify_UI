import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class ListProduct {
    //static const baseUrl = "http://10.0.2.2:3000/api/v1/product";
   static const baseUrl = "https://trustify-backend.onrender.com/api/v1/product";
  static Future<bool>addProduct(Map<String,dynamic>pDetails) async{
    List<File> imgList = (pDetails.remove('img_list') as List<dynamic>).cast<File>();
    final List<String>imgUrls = await uploadImageOnCloudinary(imgList);
    pDetails['img_urls']=imgUrls;
   print(pDetails);
   print("yha aa gye hai url bna di images ki ");
   try{
    var posturl = Uri.parse('$baseUrl/addProduct');
    final res = await http.post(
      posturl,
      headers: {
        "Content-Type":"application/json",
      },
      body: jsonEncode(pDetails),

    );
    if(res.statusCode==201){
      print("product added successfully");
      return true;
    }else{
      print("something get wrong");
      return false;
    }
   }catch(error){
    debugPrint(error.toString());
    return false;
   }
  }
  static Future<dynamic> getProduct(Map<String, dynamic> userData) async{
    print("user data at getProduct UI");
    print(userData);
    try{
      var queryParams = userData.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
          .join('&');
      var getUrl = Uri.parse('$baseUrl/getProducts?$queryParams');

      final response = await http.get(
        getUrl,
        headers: {
          "Content-Type": "application/json",
        },
      );
     if(response.statusCode==200){
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
     }

      print("Internal server error please try after some time");
        return {"error": "Internal server error, please try again later."};
     

    }catch(error){
      debugPrint(error.toString());
      return null;
    }
    
  }
  static Future<List<String>> uploadImageOnCloudinary(List<File>imgList) async{
     List<String>imgUrls=[];
    final uri = Uri.parse("https://api.cloudinary.com/v1_1/dvfz67hyi/image/upload");
    for(File file in imgList){
 var request=http.MultipartRequest('POST',uri)
     ..fields['upload_preset'] = "Trustify_preset"
     ..fields['folder'] = 'product'
    ..files.add(await http.MultipartFile.fromPath(
      'file', 
      file.path,
      filename: "pimg.jpg", // Cloudinary requires a filename
    ));
    var response = await request.send();
      if (response.statusCode == 200) {
    final responseData = await response.stream.bytesToString();
    final imageUrl = jsonDecode(responseData)['secure_url'];
  imgUrls.add( imageUrl);
  } else {
    print("Failed to upload image: ${response.statusCode}");
    
  }

    }
    return imgUrls;
     
  }

}
