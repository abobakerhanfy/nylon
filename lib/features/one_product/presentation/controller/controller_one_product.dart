import 'package:get/get.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';
import 'package:nylon/features/home/data/models/mobile_featured.dart';
import 'package:nylon/features/one_product/data/data_sources/one_product_data_source.dart';
import 'package:nylon/features/one_product/data/models/one_product_model.dart';

abstract class OneProductController extends GetxController {
  arguments();
  getOneProduct(String? id);

  //    minusCount();
  // plusCount();
  // getTotal();
}

class ControllerOneProduct extends OneProductController {
  final ControllerCart _controllerCart = Get.find();
  final OneProductDataSourceImpl _oneProductDataSourceImpl =
      OneProductDataSourceImpl(Get.find());
  StatusRequest? statusRequestGetOP;
  Productss? products;
  OneProductModel? productModel;
  int count = 1;

  getCount() {
    if (_controllerCart.cartMap.containsKey(products!.productId!)) {
      for (var e in _controllerCart.cartModel.value?.products ?? []) {
        if (e.productId == products!.productId!) {
          count = int.parse(e.quantity!);
        }
      }
      products!.calculatePriceWithDiscount(count);
      update();
    } else {
      products!.calculatePriceWithDiscount(count);
      update();
    }

    update();
  }

  @override
  arguments() {
    products = Get.arguments;
    update();
  }

  @override
  void onInit() async {
    print('sooooooooooooooooooooo');
    arguments();
    update();
    await getOneProduct(null);
    getCount();
    super.onInit();
  }

  @override
  getOneProduct(String? id) async {
    statusRequestGetOP = StatusRequest.loading;
    update();
    var response = await _oneProductDataSourceImpl.getOneProduct(
        idProduct: id ?? products!.productId!);
    return response.fold((failure) {
      statusRequestGetOP = failure;
      print(statusRequestGetOP);
      print('errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
      update();
    }, (data) {
      productModel = OneProductModel.fromJson(data as Map<String, dynamic>);
      // print(productModel!.description!.description);
      statusRequestGetOP = StatusRequest.success;
      List tt = productModel!.getAllImages();

      if (productModel!.discounts!.isNotEmpty) {
        print(productModel!.discounts!.first.price);
      }
      update();
      print('ssssssssssssssssssssssssssssssssssssssssssus');
    });
  }

  void plusCount() {
    count++;
    products!.calculatePriceWithDiscount(count);
    update();
    // تحديث السلة إن كان المنتج موجود
    if (_controllerCart.cartMap.containsKey(products!.productId!)) {
      _controllerCart.editCartProduct(
          cartId: _controllerCart.cartMap[products!.productId!]!,
          quantity: count);
    }
    update();
  }

  void minusCount() {
    if (count > 1) {
      count--;
      products!.calculatePriceWithDiscount(count);
      update();
      // تحديث السلة إن كان المنتج موجود
      if (_controllerCart.cartMap.containsKey(products!.productId!)) {
        _controllerCart.editCartProduct(
            cartId: _controllerCart.cartMap[products!.productId!]!,
            quantity: count);
      }
    }
    update();
  }
}
