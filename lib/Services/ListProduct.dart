import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class ListProduct {
    static const baseUrl = "http://10.0.2.2:3000/api/v1/product";
  //static const baseUrl = "https://trustify-backend.onrender.com/api/v1/product";
  static Future<bool>addProduct(Map<String,dynamic>p_details) async{
    List<File> img_list = (p_details.remove('img_list') as List<dynamic>).cast<File>();
    final List<String>img_urls = await uploadImageOnCloudinary(img_list);
    p_details['img_urls']=img_urls;
   print(p_details);
   print("yha aa gye hai");
   try{
    var posturl = Uri.parse('$baseUrl/addProductCar');
    final res = await http.post(
      posturl,
      headers: {
        "Content-Type":"application/json",
      },
      body: jsonEncode(p_details),

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
  static Future<bool>getProduct() async{
    try{
      return true;
    }catch(error){
      return false;
    }
  }
  static Future<List<String>> uploadImageOnCloudinary(List<File>img_list) async{
     List<String>img_urls=[];
    final uri = Uri.parse("https://api.cloudinary.com/v1_1/dvfz67hyi/image/upload");
    for(File file in img_list){
 var request=http.MultipartRequest('POST',uri)
     ..fields['upload_preset'] = "Trustify_preset"
     ..fields['folder'] = 'product'
    ..files.add(await http.MultipartFile.fromPath(
      'file', 
      file.path,
      filename: "pdimg.jpg", // Cloudinary requires a filename
    ));
    var response = await request.send();
      if (response.statusCode == 200) {
    final responseData = await response.stream.bytesToString();
    final imageUrl = jsonDecode(responseData)['secure_url'];
  img_urls.add( imageUrl);
  } else {
    print("Failed to upload image: ${response.statusCode}");
    
  }

    }
    return img_urls;
     
  }

}
