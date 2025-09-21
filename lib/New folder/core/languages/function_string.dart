import 'package:get/get.dart';

import '../services/services.dart';

String? translate(String? ar, String? en) {
  MyServices myServices = Get.find();
  if (myServices.sharedPreferences.getString('Lang') == 'ar') {
    return ar;
  } else {
    return en;
  }
}
