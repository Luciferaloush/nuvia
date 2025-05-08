import '../helper/cache_helper.dart';

class Constant{
  static Future<String?> getUserToken() async {
    return await CacheHelper.getData(key: "token");
  }
}