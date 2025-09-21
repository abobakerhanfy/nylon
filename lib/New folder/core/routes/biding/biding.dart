import 'package:get/get.dart';
import 'package:nylon/features/balance/presentation/controller/controller_balance.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';
import 'package:nylon/features/category/presentation/controller/controller_one_category.dart';
import 'package:nylon/features/coupon/presentation/controller/controller_coupon.dart';
import 'package:nylon/features/favorites/presentation/controller/controller_favorites.dart';
import 'package:nylon/features/home/presentation/controller/home_controller.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';
import 'package:nylon/features/notification/presentation/controller/controller_notification.dart';

import '../../function/method_GPUD.dart';

class BidingMethod implements Bindings {
  @override
  void dependencies() {
    Get.put(Method(), permanent: true);
    Get.put(ControllerNotifications(), permanent: true);
  }
}

class HomeBiding implements Bindings {
  @override
  void dependencies() {
    BidingMethod().dependencies();
    Get.put(ControllerHome());
    Get.put(ControllerCart());
    Get.put(ControllerFavorites());
  }
}

class ControllerLoginBiding implements Bindings {
  @override
  void dependencies() {
    BidingMethod().dependencies();
    Get.put(ControllerLogin());
  }
}

class ControllerCouponBiding implements Bindings {
  @override
  void dependencies() {
    Get.put(ControllerCoupon());
  }
}

class ControllerOneCategoryBiding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControllerOneCategory>(() => ControllerOneCategory());
  }
}

class ControllerBalanceBiding implements Bindings {
  @override
  void dependencies() {
    Get.put(ControllerBalance());
  }
}
