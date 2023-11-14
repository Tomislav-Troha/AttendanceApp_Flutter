import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager extends GetxController{
   static late SharedPreferences prefs;


   @override
   void onInit() {
     sharedData();
     super.onInit();
   }

   static void sharedData() async{
     prefs = await SharedPreferences.getInstance();
   }

   static void clearPrefs() async {
     prefs = await SharedPreferences.getInstance();
     prefs.clear();
   }

   static Future<void> setToken(String token) async {
     sharedData();
     await prefs.setString('token', token);
  }

  static String? getToken(String token) {
    sharedData();
    Object? o = prefs.get('token');
    if (o != null && o != ""){
      return o.toString();
    }
    return null;
  }

   Map<String, dynamic> getTokenUserRole() {
     String? jsonToken = getToken('token');
     if (jsonToken != null) {
       var isExpired = JwtDecoder.isExpired(jsonToken);
       if (isExpired) {
         return {};
       } else {
         return JwtDecoder.decode(jsonToken);
       }
     }
     return {};
   }


}