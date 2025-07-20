import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';

import 'package:nylon/features/home/presentation/screens/home_screen.dart';
import 'package:nylon/features/category/presentation/screens/screen_all_categories.dart';
import 'package:nylon/features/favorites/presentation/screens/favorites.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';

import '../../features/cart/presentation/screens/cart_screens/basic_screen_cart.dart';

import '../../view/profile/profile.dart';

abstract class HomeWidgetController extends GetxController {
  onTapBottomBar(int index);
  onTapSlider(int index);
}

class ControllerHomeWidget extends HomeWidgetController {
  int indexBar = 0;
  int indexSlider = 0;

  final _loginController = Get.find<ControllerLogin>(); // ✅ هنا

  List<Widget> screens = [
    ScreenHome(),
    ViewcCategories(),
    GetBuilder<ControllerCart>(
        init: ControllerCart(),
        builder: (_controller) {
          return const ScreenCart();
        }),
    const Favorite(),
    Profile()
  ];

  @override
  void onInit() {
    super.onInit();

    // ✅ هنا نتحقق من وجود token
    _loginController.checkAndCreateToken();
  }

  @override
  onTapBottomBar(int index) {
    indexBar = index;
    update();
  }

  @override
  onTapSlider(int index) {
    indexSlider = index;
    update();
  }
}
