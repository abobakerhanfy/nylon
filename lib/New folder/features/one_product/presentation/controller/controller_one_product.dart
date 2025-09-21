import 'package:get/get.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';
import 'package:nylon/features/home/data/models/mobile_featured.dart';
import 'package:nylon/features/one_product/data/data_sources/one_product_data_source.dart';
import 'package:nylon/features/one_product/data/models/one_product_model.dart';

abstract class OneProductController extends GetxController {
  void arguments();
  Future<void> getOneProduct(String? id);
}

class ControllerOneProduct extends OneProductController {
  bool isLoadingById = false;
  String? lastErrorById;

  final ControllerCart _controllerCart = Get.find();
  final OneProductDataSourceImpl _oneProductDataSourceImpl =
      OneProductDataSourceImpl(Get.find());
  StatusRequest? statusRequestGetOP;
  Productss? products;
  OneProductModel? productModel;
  int count = 1;

  getCount() {
    final pid = safeProductId;
    if (pid != null && _controllerCart.cartMap.containsKey(pid)) {
      for (var e in _controllerCart.cartModel.value?.products ?? []) {
        if ((e.productId?.toString() ?? '') == pid) {
          count = int.tryParse(e.quantity ?? '1') ?? 1;
        }
      }
    }
    if (products != null) {
      products!.calculatePriceWithDiscount(count);
    }
    update();
  }

// جِب منتج بالـ product_id (من غير ما نغيّر السلوك الحالي)
  Future<void> loadByProductId(String id) async {
    isLoadingById = true;
    lastErrorById = null;
    update();

    await getOneProduct(id); // ما فيش باراميتر اسمه idProduct هنا
    getCount();
    isLoadingById = false;
    update();
  }

// سعر القطعة بطريقة لا تؤثر على السلوك الحالي:
// - لو products (القديمة) موجودة: نستخدمها
// - لو فتحنا بالـ product_id: ناخد السعر من productModel
  double unitPriceWithDiscount(int qty) {
    try {
      if (products != null) return products!.calculatePriceWithDiscount(qty);
    } catch (_) {}
    try {
      final list = productModel?.product;
      if (list != null && list.isNotEmpty) {
        final p = list.first;
        final price =
            (p.special != null && p.special! > 0) ? p.special! : (p.price ?? 0);
        return (price is num) ? price.toDouble() : 0.0;
      }
    } catch (_) {}
    return 0.0;
  }

// product_id الآمن (يُستخدم في زر السلة)
  String? get safeProductId {
    final idFromProducts = products?.productId?.toString();
    if (idFromProducts != null && idFromProducts.isNotEmpty)
      return idFromProducts;

    final list = productModel?.product;
    if (list != null && list.isNotEmpty) {
      final id = list.first.productId?.toString();
      if (id != null && id.isNotEmpty) return id;
    }
    return null;
  }

  @override
  arguments() {
    final args = Get.arguments;
    if (args is Productss) {
      products = args;
    } else {
      products = null; // مهم: ما نرميش Map جوه Productss
    }
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    arguments();
    ever(_controllerCart.cartModel, (_) {
      getCount(); // يقرأ الكمية من السلة مباشرة
      update();
    });

    final args = Get.arguments;

    // لو جاي بـ Map فيها product_id أو id
    if (args is Map) {
      final map = Map<String, dynamic>.from(args);
      final rawId = (map['product_id'] ?? map['id']);
      if (rawId != null && rawId.toString().isNotEmpty) {
        await loadByProductId(rawId.toString());
        return; // ما تكملش
      }
    }

    // لو جاي Productss (قديم)
    if (products?.productId != null) {
      await getOneProduct(products!.productId!.toString());
      getCount();
    }
  }

  @override
  Future<void> getOneProduct(String? id) async {
    statusRequestGetOP = StatusRequest.loading;
    update();

    final response = await _oneProductDataSourceImpl.getOneProduct(
      idProduct: id ?? products!.productId!,
    );

    response.fold((failure) {
      statusRequestGetOP = failure;
      lastErrorById = failure.toString();
      update();
    }, (data) {
      try {
        productModel = OneProductModel.fromJson(data as Map<String, dynamic>);
        statusRequestGetOP = StatusRequest.success;

        // ✅ مهم: بعد ما المنتج يتحمّل، حدّث العداد من السلة
        getCount();
        update();
      } catch (e) {
        lastErrorById = e.toString();
        statusRequestGetOP = StatusRequest.failure;
        update();
      }
    });
  }

  void plusCount() {
    count++;
    if (products != null) {
      products!.calculatePriceWithDiscount(count);
    }
    final pid = safeProductId;
    if (pid != null && _controllerCart.cartMap.containsKey(pid)) {
      _controllerCart.editCartProduct(
        cartId: _controllerCart.cartMap[pid]!,
        quantity: count,
      );
    }
    update();
  }

  void minusCount() {
    if (count > 1) {
      count--;
      if (products != null) {
        products!.calculatePriceWithDiscount(count);
      }
      final pid = safeProductId;
      if (pid != null && _controllerCart.cartMap.containsKey(pid)) {
        _controllerCart.editCartProduct(
          cartId: _controllerCart.cartMap[pid]!,
          quantity: count,
        );
      }
      update();
    }
  }

  // void minusCount() {
  //   if (count > 1) {
  //     count--;
  //     products!.calculatePriceWithDiscount(count);
  //     update();
  //     // تحديث السلة إن كان المنتج موجود
  //     if (_controllerCart.cartMap.containsKey(products!.productId!)) {
  //       _controllerCart.editCartProduct(
  //           cartId: _controllerCart.cartMap[products!.productId!]!,
  //           quantity: count);
  //     }
  //   }
  //   update();
  // }
}
