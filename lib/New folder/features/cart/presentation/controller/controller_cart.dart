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
  Future getCart();
  Future addCart({required String idProduct, required int quantity});
  Future removeCart({required String cartId});
  Future editCartProduct({required String cartId, required int quantity});
  minusIndexScreensCart();
  plusIndexScreensCart();
  bool _stockWarningShown = false; // 👈 جديد
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

  // متغير للتحقق ما إذا تم الوصول إلى الهدف أم لا
  void clearCartData() {
    cartModel.value = null;
    cartMap.clear();
    remainingAmount = 0.0;
    hasReachedTarget = false;
    _stockWarningShown = false; // 👈 مهم
    update();
  }

  Future<void> clearCartFromServer() async {
    try {
      final response = await _cartDataSourceImpl
          .clearCart(); // ← تأكد إن دي موجودة في الـ data source
      if (response.isRight()) {
        print("✅ Cart cleared from server");
      } else {
        print("❌ Failed to clear cart from server");
      }
    } catch (e) {
      print("❌ Exception while clearing cart from server: $e");
    }
  }

  getTotalCart() {
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
        hasReachedTarget =
            totalAmount >= targetAmount; // التحقق إذا كان الإجمالي وصل للهدف
        update();

        print('المبلغ المتبقي للوصول إلى 350: $remainingAmount');
        print('تم الوصول إلى الهدف؟: $hasReachedTarget');
        print('$hasReachedTarget =========================');
        update();
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

    var response = await _cartDataSourceImpl.getCart();

    return response.fold((failure) {
      statusRequestGetCart = failure;
      print('❌ Error occurred: $failure');
      update();
    }, (rawData) async {
      // 🧼 تنظيف البيانات القديمة
      cartModel.value = null;
      cartMap.clear();

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

      // ✅ تحويل البيانات إلى model
      cartModel.value = GetCartModel.fromJson(rawData);
      statusRequestGetCart = StatusRequest.success;

      // 🧾 طباعة عدد المنتجات للتأكيد
      print(
          "🔄 عدد المنتجات بعد getCart: ${cartModel.value?.products?.length ?? 0}");

      // 🟢 لو السلة فاضية → امسح order_id/status
      // 🟢 امسح الـ order_id / order_status لو السلة فاضية فعلاً
      if (cartModel.value == null ||
          cartModel.value?.products?.isEmpty == true) {
        await _myServices.sharedPreferences.remove("order_id");
        await _myServices.sharedPreferences.remove("order_status");
        print("🗑️ Cleared order_id and order_status because cart is empty.");
      }

      // 🗂️ إعداد الخرائط
      if (cartModel.value != null &&
          cartModel.value?.totals != null &&
          cartModel.value?.products?.isNotEmpty == true) {
        for (var element in cartModel.value?.products ?? []) {
          if (element.productId != null && element.cartId != null) {
            cartMap[element.productId!] = element.cartId!;
          }
        }
      }

      // 🧮 تحديث الكمية والإجمالي
      getTotalQuantity();
      getTotalCart();
      update();
    });
  }

  // @override
  // Future getCart() async {
  //   statusRequestGetCart = StatusRequest.loading;
  //   update();

  //   var response = await _cartDataSourceImpl.getCart();

  //   return response.fold((failure) {
  //     statusRequestGetCart = failure;
  //     print('Error occurred: $failure');
  //     update();
  //   }, (data) {
  //     cartModel = data;
  //     statusRequestGetCart = StatusRequest.success;
  //     if (cartModel != null &&
  //         cartModel!.products != null &&
  //         cartModel!.products!.isNotEmpty) {
  //       for (var element in cartModel!.products!) {
  //         if (element.productId != null && element.cartId != null) {
  //           cartMap.addAll({
  //             element.productId!: element.cartId!,
  //           });
  //         } else {
  //           print('Invalid product or cart ID');
  //         }
  //       }
  //       print(cartMap);
  //       print(cartModel!.products!.length);
  //       print('Success');
  //     } else {
  //       print('No products found');
  //     }
  //     getTotalQuantity();
  //     getTotalCart();

  //     update(); // تحديث واحد بعد إتمام العمل
  //   });
  // }

  @override
  minusIndexScreensCart() {
    if (indexScreensCart > 0) {
      indexScreensCart--;
      print(indexScreensCart);
    }
    print(indexScreensCart);
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
    _checkCustomerAndRedirect(); // ✅ تحقق هنا

    super.onInit();
  }

  void _checkCustomerAndRedirect() async {
    final prefs = Get.find<MyServices>().sharedPreferences;
    final customerId = prefs.getString('customer_id');

    if (customerId == null || customerId.isEmpty) {
      indexScreensCart = 1; // 1 معناها شاشة رقم الهاتف
      update();
    }
  }

  @override
  Future addCart({required String idProduct, required int quantity}) async {
    var response = await _cartDataSourceImpl.addCart(
        idProduct: idProduct, quantity: quantity);
    return response.fold((failure) {
      statusRequestAddCart = failure;
      handleStatusRequestInput(statusRequestAddCart!);
      update();
    }, (data) {
      statusRequestAddCart = StatusRequest.success;
      showSnackBar('159'.tr);
      update();
    });
  }

  @override
  Future removeCart({required String cartId}) async {
    var response = await _cartDataSourceImpl.removeCart(cartId: cartId);
    return response.fold((failure) {
      statusRequestRemove = failure;
      // update();
    }, (data) {
      print(data);
      showSnackBar('160'.tr);
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
    var response = await _cartDataSourceImpl.editCartProduct(
        cartId: cartId, quantity: quantity);
    return response.fold((failure) {
      statusRequestEdit = failure;
      update();
    }, (data) {
      print(data);
      getCart();
      getTotalQuantity();
      update();
    });
  }
}
