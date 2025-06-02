import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  // Kullanıcının oturum açık/kapalı bilgisini kaydeder
  static Future<void> saveLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      'isLoggedIn',
      isLoggedIn,
    ); // true veya false olarak saklanır
  }

  // Kullanıcının oturum bilgisini getirir. Yoksa false döner.
  static Future<bool> getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // varsayılan olarak false
  }

  // Kullanıcının e-posta, ad ve soyad bilgilerini kaydeder
  static Future<void> saveUserInfo({
    required String email,
    required String name,
    required String surname,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('name', name);
    await prefs.setString('surname', surname);
  }

  // Kullanıcının e-posta, ad ve soyad bilgilerini getirir
  static Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString('email'),
      'name': prefs.getString('name'),
      'surname': prefs.getString('surname'),
    };
  }

  // Tüm SharedPreferences verilerini temizler (çıkışta veya sıfırlamada kullanılabilir)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Tüm anahtarlar silinir
  }
}
