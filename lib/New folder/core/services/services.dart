import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyServices extends GetxService {
  late SharedPreferences sharedPreferences;
  Future<MyServices> initShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }

  bool userIsLogin() {
    var isLogin = sharedPreferences.getString('UserId');
    return isLogin?.isNotEmpty ?? false;
  }

  String getLanguageCode() {
    String? lang = sharedPreferences.getString('Lang');
    if (lang == 'ar') {
      return '&lang=ar';
    } else if (lang == 'en') {
      return '&lang=en-gb';
    } else {
      return '&lang=ar';
    }
  }

  Future<void> clearUserData() async {
    await sharedPreferences.remove('customer_id');
    await sharedPreferences.remove('UserId');
    await sharedPreferences.remove('Phone');
    await sharedPreferences.remove('Phon_User');
    await sharedPreferences.remove('NewCustomer_id');
    await sharedPreferences.remove('telephone');
  }

  void printAllSharedPreferences() {
    final keys = sharedPreferences.getKeys();
    print("📦 SharedPreferences محتوى:");

    for (var key in keys) {
      final value = sharedPreferences.get(key);
      print("🔑 $key : $value");
    }
  }
}
