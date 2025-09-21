import 'package:get/get.dart';
import 'package:nylon/core/function/snack_bar.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/features/cart/data/data_sources/cart_data_source.dart';
import 'package:nylon/features/cart/data/models/get_cart_model.dart';
import 'package:flutter/material.dart';
import 'package:nylon/core/services/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:nylon/core/widgets/login/dialog.dart';
import 'package:nylon/core/widgets/primary_button.dart';

abstract class CartController extends GetxController {
  Future<void> getCart();
  Future addCart({required String idProduct, required int quantity});
  Future removeCart({required String cartId});
  Future editCartProduct({required String cartId, required int quantity});
  minusIndexScreensCart();
  plusIndexScreensCart();
  // ❌ اشطب السطر ده من الـ abstract:
  // bool _stockWarningShown = false;
}

class ControllerCart extends CartController {
  final MyServices _myServices = Get.find();
  final CartDataSourceImpl _cartDataSourceImpl = CartDataSourceImpl(Get.find());

  StatusRequest? statusRequestGetCart,
      statusRequestAddCart,
      statusRequestRemove,
      statusRequestEdit;

  Rxn<GetCartModel> cartModel = Rxn<GetCartModel>();
  Map<String, String> cartMap = {};
  int indexScreensCart = 0;

  final double targetAmount = 350.0;
  double remainingAmount = 0.0;
  bool hasReachedTarget = false;
  bool isUpdatingInvoice = false;

  bool _stockWarningShown = false; // ✅ هنا مكانها الصح

  // عدد الأسطر (distinct products)
  int getLinesCount() {
    final len = cartModel.value?.products?.length ?? 0;
    print("🧮 lines in cart: $len");
    return len;
  }

  // مجموع الكميات (لو حبيت تستخدمه)
  int getTotalQuantity() {
    print("📦 getTotalQuantity() executed");
    int totalQuantity = 0;
    if (cartModel.value?.products != null) {
      for (var product in cartModel.value?.products ?? []) {
        if (product.quantityC != null) {
          totalQuantity += int.tryParse(product.quantityC!) ?? 0;
        }
      }
    }
    print(totalQuantity);
    return totalQuantity;
  }

  void clearCartData() {
    cartModel.value = null;
    cartMap.clear();
    remainingAmount = 0.0;
    hasReachedTarget = false;
    _stockWarningShown = false;
    update();
  }

  Future<void> clearCartFromServer() async {
    try {
      final response = await _cartDataSourceImpl.clearCart();
      if (response.isRight()) {
        print("✅ Cart cleared from server");
      } else {
        print("❌ Failed to clear cart from server");
      }
    } catch (e) {
      print("❌ Exception while clearing cart from server: $e");
    }
  }

  void getTotalCart() {
    print("📦 getTotalCart() executed");
    remainingAmount = 0.0;
    hasReachedTarget = false;
    update();

    if (cartModel.value != null &&
        cartModel.value?.totals != null &&
        cartModel.value?.products?.isNotEmpty == true) {
      try {
        var totalMap = cartModel.value!.totals!.firstWhere(
          (total) => total.title == 'الاجمالي' || total.title == "Sub-Total",
        );

        String totalText = totalMap.text!;
        double totalAmount = double.parse(totalText.replaceAll(' ريال', ''));
        print('الإجمالي: $totalAmount');

        remainingAmount = targetAmount - totalAmount;
        hasReachedTarget = totalAmount >= targetAmount;
        update();

        print('المبلغ المتبقي للوصول إلى 350: $remainingAmount');
        print('تم الوصول إلى الهدف؟: $hasReachedTarget');
      } catch (e) {
        print('خطأ أثناء حساب الإجمالي: $e');
      }
    } else {
      print('بيانات السلة غير موجودة');
    }
  }

  @override
  Future<void> getCart() async {
    statusRequestGetCart = StatusRequest.loading;
    update();

    final response = await _cartDataSourceImpl.getCart();

    return response.fold((failure) {
      statusRequestGetCart = failure;
      print('❌ Error occurred: $failure');
      update();
    }, (rawData) async {
      // 🧼 تنظيف
      cartModel.value = null;
      cartMap.clear();

      // تنبيه المخزون لو موجود
      if (rawData.containsKey("error") &&
          rawData["error"].containsKey("stock")) {
        if (!_stockWarningShown && (Get.isDialogOpen != true)) {
          newCustomDialog(
            title: "تنبيه",
            dialogType: DialogType.warning,
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  rawData["error"]["stock"],
                  textAlign: TextAlign.center,
                  style: Theme.of(Get.context!).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                PrimaryButton(label: "حسناً", onTap: () => Get.back()),
              ],
            ),
          );
          _stockWarningShown = true;
        }
      } else {
        _stockWarningShown = false;
      }

      // تحويل لـ model
      cartModel.value = GetCartModel.fromJson(rawData);
      statusRequestGetCart = StatusRequest.success;

      print(
          "🔄 عدد المنتجات بعد getCart: ${cartModel.value?.products?.length ?? 0}");

      // تفريغ order_id/status لو السلة فاضية
      if (cartModel.value == null ||
          cartModel.value?.products?.isEmpty == true) {
        await _myServices.sharedPreferences.remove("order_id");
        await _myServices.sharedPreferences.remove("order_status");
        print("🗑️ Cleared order_id and order_status because cart is empty.");
      }

      // إعداد cartMap
      if (cartModel.value != null &&
          cartModel.value?.totals != null &&
          cartModel.value?.products?.isNotEmpty == true) {
        for (var element in cartModel.value?.products ?? []) {
          if (element.productId != null && element.cartId != null) {
            cartMap[element.productId!] = element.cartId!;
          }
        }
      }

      // تحديث الحسابات
      getTotalQuantity();
      getTotalCart();
      update();
    });
  }

  @override
  Future addCart({required String idProduct, required int quantity}) async {
    final response = await _cartDataSourceImpl.addCart(
        idProduct: idProduct, quantity: quantity);

    return response.fold((failure) {
      statusRequestAddCart = failure;
      handleStatusRequestInput(statusRequestAddCart!);
      update();
    }, (data) async {
      statusRequestAddCart = StatusRequest.success;
      showSnackBar('159'.tr);
      await getCart(); // مهم لتحديث البادج/الشاشة
      update();
    });
  }

  @override
  Future removeCart({required String cartId}) async {
    final response = await _cartDataSourceImpl.removeCart(cartId: cartId);

    return response.fold((failure) {
      statusRequestRemove = failure;
      update();
    }, (data) async {
      print(data);
      showSnackBar('160'.tr);
      await getCart(); // مهم لتحديث البادج/الشاشة
      update();
    });
  }

  Future addOrRemoveCart(
      {required String idProduct, required int quantity}) async {
    if (cartMap.containsKey(idProduct)) {
      await removeCart(cartId: cartMap[idProduct]!);
      cartMap.remove(idProduct);
      update();
    } else {
      await addCart(idProduct: idProduct, quantity: quantity);
      update();
    }
    await getCart();
    update();
  }

  @override
  Future editCartProduct(
      {required String cartId, required int quantity}) async {
    print(quantity);
    print("ssssssssssssssssss");
    final response = await _cartDataSourceImpl.editCartProduct(
        cartId: cartId, quantity: quantity);

    return response.fold((failure) {
      statusRequestEdit = failure;
      update();
    }, (data) async {
      print(data);
      await getCart();
      getTotalQuantity();
      update();
    });
  }

  @override
  minusIndexScreensCart() {
    if (indexScreensCart > 0) {
      indexScreensCart--;
      print(indexScreensCart);
    }
    update();
  }

  @override
  plusIndexScreensCart() {
    if (indexScreensCart <= 3) {
      indexScreensCart++;
      print(indexScreensCart);
    }
    update();
  }

  @override
  void onInit() {
    getCart();
    _checkCustomerAndRedirect();
    super.onInit();
  }

  void _checkCustomerAndRedirect() async {
    final prefs = Get.find<MyServices>().sharedPreferences;
    final customerId = prefs.getString('customer_id');
    if (customerId == null || customerId.isEmpty) {
      indexScreensCart = 1; // شاشة رقم الهاتف
      update();
    }
  }
}
