import 'package:hive/hive.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/services/helper/hiveService.dart';

class TokenService {
  Box _box = HiveService().getHiveBox();

  String get getToken => _box.get(hkToken, defaultValue: null);

  void setToken({required String token}) {
    _box.put(hkToken, token);
  }

  void deleteToken() => _box.delete(hkToken);
}
