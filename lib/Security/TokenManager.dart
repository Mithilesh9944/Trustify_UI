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