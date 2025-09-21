import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';

import 'package:nylon/features/home/presentation/screens/home_screen.dart';
import 'package:nylon/features/category/presentation/screens/screen_all_categories.dart';
import 'package:nylon/features/favorites/presentation/screens/favorites.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';
import 'package:nylon/features/home/data/data_sources/home_data_source.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/features/home/data/models/new_model_test.dart';
import 'package:nylon/core/function/method_GPUD.dart';

import '../../features/cart/presentation/screens/cart_screens/basic_screen_cart.dart';

import '../../view/profile/profile.dart';
// لو بتستخدم DI: Get.put(HomeDataSourceImpl(Method())) في مكان التهيئة

abstract class HomeWidgetController extends GetxController {
  onTapBottomBar(int index);
  onTapSlider(int index);
}

class ControllerHomeWidget extends HomeWidgetController {
  int indexBar = 0;
  int indexSlider = 0;
  // لو already عندك NewModelHome? و StatusRequest، سيبهم
  NewModelHome? homeData; // <-- لو موجود عندك باسم مختلف سيب اسمك
  StatusRequest status =
      StatusRequest.none; // <-- لو عندك status سماه زي ما انت مسميه

  // خد الـ datasource من Get (لازم يكون متسجّل في الـ bindings)
  late final HomeDataSource _ds;
  final _loginController = Get.find<ControllerLogin>(); // ✅ هنا

  List<Widget> screens = [
    const ScreenHome(),
    const ViewcCategories(),
    GetBuilder<ControllerCart>(
        init: ControllerCart(),
        builder: (_controller) {
          return const ScreenCart();
        }),
    const Favorite(),
    Profile()
  ];
  Future<void> refreshHome() async {
    status = StatusRequest.loading;
    update();

    final res = await _ds
        .getData(); // دي بتستخدم &lang= من MyServices.getLanguageCode()
    res.fold(
      (failure) {
        status = failure;
      },
      (data) {
        homeData = data; // ← غيّر الاسم لو متغيّرك اسمه غير كده
        status = StatusRequest.success;
      },
    );

    update();
  }

  @override
  void onInit() {
    super.onInit();

    // سجل Method و HomeDataSource لو مش متسجلين
    if (!Get.isRegistered<Method>()) {
      Get.lazyPut<Method>(() => Method(), fenix: true);
    }
    if (!Get.isRegistered<HomeDataSource>()) {
      Get.lazyPut<HomeDataSource>(() => HomeDataSourceImpl(Get.find<Method>()),
          fenix: true);
    }
    _ds = Get.find<HomeDataSource>();

    // ✅ التوكن (كودك الحالي)
    _loginController.checkAndCreateToken();

    // ✅ أول تحميل للهوم
    refreshHome();
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
