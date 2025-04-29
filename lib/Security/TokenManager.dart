import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const String _tokenKey = "userToken";
    static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void>saveToken(String token) async{
     await _storage.write(key: _tokenKey, value: token);
  }
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
   static Future<void> removeToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
/*
user1-
{
	"name": "bob1",
    "mobileNo":"4499559966",
    "password":"person2@126",
    "email":"person2@gmail.com",
    "profileImg":null
}
    "status": true,
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjE4MWQ2Y2RjLTdhNmEtNGVlMy05ZmQwLWJhNTZmMDk0M2EzMiIsIm5hbWUiOiJib2IxIiwibW9iaWxlTm8iOiI0NDk5NTU5OTY2IiwiZW1haWwiOiJwZXJzb24yQGdtYWlsLmNvbSIsImlhdCI6MTc0NTU5MjM0NCwiZXhwIjoxNzQ1Njc4NzQ0fQ.Kyg7cHcCyf9ZCTywvKlURhuBWw5bHVd9CMyIuyz1rMk",
    "id": "181d6cdc-7a6a-4ee3-9fd0-ba56f0943a32"

user2-
{
	"name": "bob2",
    "mobileNo":"4499559967",
    "password":"person2@127",
    "email":"person2@gmail.com",
    "profileImg":null
}
    "status": true,
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZlOWMxNjdkLThlYWQtNGViMS1hNDMwLTE2YmMwZjE3YmMzNCIsIm5hbWUiOiJib2IyIiwibW9iaWxlTm8iOiI0NDk5NTU5OTY3IiwiZW1haWwiOiJwZXJzb24yQGdtYWlsLmNvbSIsImlhdCI6MTc0NTU5MjQ0NywiZXhwIjoxNzQ1Njc4ODQ3fQ.mYTWIj4vJ_6Eu4XZdRWDeava3jnHvTyl1Wd104lW7a0",
    "id": "6e9c167d-8ead-4eb1-a430-16bc0f17bc34"


    */