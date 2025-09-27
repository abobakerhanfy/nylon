import 'package:get/get.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/features/home/data/data_sources/home_data_source.dart';
import 'package:nylon/core/theme/app_theme_controller.dart'; // ⬅️ مهم

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Method>(() => Method(), fenix: true);
    Get.lazyPut<HomeDataSource>(() => HomeDataSourceImpl(Get.find<Method>()),
        fenix: true);

    // ⬅️ سجّل AppThemeController قبل بناء MyApp
    Get.put<AppThemeController>(AppThemeController(), permanent: true);
  }
}
