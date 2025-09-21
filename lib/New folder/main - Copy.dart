import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/languages/controllerLocale.dart';
import 'package:nylon/core/languages/locale.dart';
import 'package:nylon/core/routes/pages.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';
import 'package:nylon/features/orders/data/data_sources/orders_data_source.dart';
import 'package:nylon/features/orders/presentation/controller/controller_order.dart';
import 'package:nylon/features/fortune_wheel/presentation/controller/controller_fortune.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    // WebView.platform = SurfaceAndroidWebView();
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initServices();

  Get.put(Method());
  await Get.put(ControllerLogin()).createToken();

  Get.put(OrdersDataSourceImpl(Get.find<Method>()));
  Get.put(ControllerCart());
  Get.put(ControllerOrder());
  Get.put(ControllerFortune());

  // 🔐 التحقق من customer_id
  final shared = Get.find<MyServices>().sharedPreferences;
  final customerId = shared.getString("customer_id");
  if (customerId == null || customerId.isEmpty) {
    Get.find<ControllerCart>().indexScreensCart = 1; // يفتح شاشة التحقق
  }

  await Get.find<ControllerFortune>().checkAndRunForToday();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()));
}

Future<void> initServices() async {
  await Get.putAsync(() => MyServices().initShared(), permanent: true);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ControllerLocal controllerLocal = Get.put(ControllerLocal());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nylon',
      translations: MyLocale(),
      locale: controllerLocal.languages,
      theme: controllerLocal.abbThem,
      getPages: routes,
    );
  }
}
