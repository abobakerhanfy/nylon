import 'package:get/get.dart';

import '../services/services.dart';

class AuthController extends GetMiddleware {
  final MyServices _myServices = Get.find();
  //  @override
  // RouteSettings? redirect(String? route){
  //    if(_myServices.sharedPreferences.getString('token') != null){
  //
  //      print('User is login');
  //      return const RouteSettings(name: NamePages.pScreenBottomBar);
  //    }
  //    print('User Not login');
  //   return null;
  //
  //
  //  }
}
