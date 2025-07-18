import 'package:get/get.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/features/category/data/data_sources/category_data_source.dart';
import 'package:nylon/features/category/data/models/full_category_model.dart';

abstract class CategoryController extends GetxController {
  Future<void> getAllCategory();
}

class ControllerCategory extends CategoryController {
  final CategoryDataSourceImpl _categoryDataSourceImpl =
      CategoryDataSourceImpl(Get.find());
  final MyServices _myServices = Get.find();
  StatusRequest? statusRequest;
  RxInt selectedIndex = 0.obs;
  Rx<FullCategory?> categories = Rx<FullCategory?>(null);

  @override
  Future<void> getAllCategory() async {
    statusRequest = StatusRequest.loading;
    update();

    var response = await _categoryDataSourceImpl.getAllCategory();
    response.fold(
      (failure) {
        statusRequest = failure;
        print(statusRequest);
        update();
      },
      (data) {
        categories.value = data;
        updateCategories(); // تحديث الفئات بناءً على اللغة
        statusRequest = StatusRequest.success;
        print(
            'controller ${categories.value!.productsFeatured![0].nameAr} success');
        update();
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    getAllCategory();
  }

  Future<void> updateCategories() async {
    final local = _myServices.sharedPreferences.getString('Lang') ??
        'ar'; // افتراضياً اللغة العربية
    if (categories.value != null) {
      for (var feature in categories.value!.productsFeatured!) {
        print('s');
        feature.products =
            local == 'en' ? feature.productsEn : feature.productsAr;
      }
    }
  }
}
