import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static SharedPreferences? prefs;
  static final _tokenStreamController = BehaviorSubject<String?>();

  // Stream getter
  static Stream<String?> get tokenStream => _tokenStreamController.stream;

  static Future<void> sharedData() async {
    prefs = await SharedPreferences.getInstance();
    _updateTokenStream();
  }

  static void clearPrefs() async {
    prefs = await SharedPreferences.getInstance();
    prefs!.clear();
  }

  static Future<void> setToken(String token) async {
    await sharedData();
    await prefs!.setString('token', token);
  }

  static Future<String?> getToken(String tokenKey) async {
    if (prefs == null) {
      await sharedData();
    }
    Object? o = prefs!.get(tokenKey);
    return o?.toString();
  }

  static void _updateTokenStream() async {
    String? token = await getToken('token');
    _tokenStreamController.add(token);
  }

  static Future<Map<String, dynamic>> getTokenUserRole() async {
    String? jsonToken = await getToken('token');
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
