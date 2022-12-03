import 'package:get_storage/get_storage.dart';

class PrefrenceManager {
  static GetStorage getStorage = GetStorage();

  static String logIn = 'LogIn';
  static String name = 'Name';
  static String fcmToken = 'token';

  /// LogIn
  static Future setLogIn(String name) async {
    await getStorage.write(logIn, name);
  }

  static getLogIn() {
    return getStorage.read(logIn);
  }

  /// LogIn
  static Future setFcmToken(String name) async {
    await getStorage.write(fcmToken, name);
  }

  static getFcmToken() {
    return getStorage.read(fcmToken);
  }

  /// Name
  static Future setName(String name1) async {
    await getStorage.write(name, name1);
  }

  static getName() {
    return getStorage.read(name);
  }

  static remove() {
    return getStorage.erase();
  }
}
