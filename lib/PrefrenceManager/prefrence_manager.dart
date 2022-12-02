import 'package:get_storage/get_storage.dart';

class PrefrenceManager {
  static GetStorage getStorage = GetStorage();

  static String logIn = 'LogIn';
  static String name = 'Name';

  /// LogIn
  static Future setLogIn(String name) async {
    await getStorage.write(logIn, name);
  }

  static getLogIn() {
    return getStorage.read(logIn);
  }

  /// Name
  static Future setName(String name) async {
    await getStorage.write(name, name);
  }

  static getName() {
    return getStorage.read(name);
  }

  static remove() {
    return getStorage.erase();
  }
}
