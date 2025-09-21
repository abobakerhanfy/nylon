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
  String? _productId; // ← هنملأه من Get.arguments سواء Map أو موديل
  bool _argWasModel = false; // ← نعرف إذا اللي جالنا Productss جاهز
  final ControllerCart _controllerCart = Get.find();
  final OneProductDataSourceImpl _oneProductDataSourceImpl =
      OneProductDataSourceImpl(Get.find());
  StatusRequest? statusRequestGetOP;
  Productss? products;
  OneProductModel? productModel;
  int count = 1;

  getCount() {
    // لو ما عندناش productId لسه، خلّي العدّاد الافتراضي 1
    final pid = (_productId ?? products?.productId)?.toString().trim();
    if (pid == null || pid.isEmpty) {
      count = 1;
      update();
      return;
    }

    // لو المنتج موجود بالفعل في السلة خُد الكمية منه
    if (_controllerCart.cartMap.containsKey(pid)) {
      for (var e in _controllerCart.cartModel.value?.products ?? []) {
        if (e.productId == pid) {
          count = int.tryParse(e.quantity ?? e.quantityC ?? '1') ?? 1;
          break;
        }
      }
    } else {
      count = 1;
    }

    // حدّث سعر العرض لو عندنا موديل Productss
    try {
      products?.calculatePriceWithDiscount(count);
    } catch (_) {
      // لا تتوقف لو مش متاحة
    }

    update();
  }

  @override
  arguments() {
    final args = Get.arguments;

    if (args is Productss) {
      // جالك موديل جاهز
      products = args;
      _productId = args.productId?.toString().trim();
      _argWasModel = true;
    } else if (args is Map) {
      // جالك Map {product_id, rawLink, source, ...}
      final id = (args['product_id'] ?? args['id'] ?? '').toString().trim();
      _productId = id.isEmpty ? null : id;
      _argWasModel = false;
    } else if (args != null) {
      // fallback لو اتبعت id كـ int مثلاً
      _productId = args.toString().trim();
    }

    // Debug
    print('🧭 OneProduct args → productId=$_productId, hasModel=$_argWasModel');

    update();
  }

  @override
  void onInit() async {
    print('sooooooooooooooooooooo');
    arguments();
    update();

    // لو مفيش موديل جاهز هنحمّل بالمُعرف
    await getOneProduct(_productId);

    // عدّل العدّاد بعد ما تتوفر بيانات المنتج أو على الأقل عندنا productId
    getCount();

    super.onInit();
  }

  @override
  getOneProduct(String? id) async {
    final effectiveId =
        (id ?? _productId ?? products?.productId)?.toString().trim();

    if (effectiveId == null || effectiveId.isEmpty) {
      print('❌ getOneProduct: no id to load');
      statusRequestGetOP = StatusRequest.failure;
      update();
      return;
    }

    statusRequestGetOP = StatusRequest.loading;
    update();

    final response =
        await _oneProductDataSourceImpl.getOneProduct(idProduct: effectiveId);
    return response.fold((failure) {
      statusRequestGetOP = failure;
      print(statusRequestGetOP);
      print('errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
      update();
    }, (data) {
      productModel = OneProductModel.fromJson(data as Map<String, dynamic>);
      statusRequestGetOP = StatusRequest.success;

      // لو ماجاش موديل Productss من الـ arguments، حاول تطلّع منه نسخة خفيفة للاستخدام المحلي
      try {
        if (!_argWasModel && (productModel?.product?.isNotEmpty ?? false)) {
          final p = productModel!.product!.first;
          products ??= Productss(
            productId: p.productId,
            name: p.name,
            price: p.price,
            special: p.special,
            description: p.description,
            image: p.image,
            rating: p.rating,
          );
          _productId ??= p.productId?.toString().trim();
        }
      } catch (e) {
        // لو Productss مش مناسب هنا سيبها زي ما هي
        print('ℹ️ Could not map to Productss: $e');
      }

      // Debug
      final imgs = productModel!.getAllImages();
      print('🖼 images count: ${imgs.length}');
      if ((productModel!.discounts ?? []).isNotEmpty) {
        print(
            '💸 first discount price: ${productModel!.discounts!.first.price}');
      }

      update();
      print('ssssssssssssssssssssssssssssssssssssssssssus');
    });
  }

  void plusCount() {
    count++;
    try {
      products?.calculatePriceWithDiscount(count);
    } catch (_) {}
    update();

    final pid = (_productId ?? products?.productId)?.toString().trim();
    if (pid != null &&
        pid.isNotEmpty &&
        _controllerCart.cartMap.containsKey(pid)) {
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
      try {
        products?.calculatePriceWithDiscount(count);
      } catch (_) {}
      update();

      final pid = (_productId ?? products?.productId)?.toString().trim();
      if (pid != null &&
          pid.isNotEmpty &&
          _controllerCart.cartMap.containsKey(pid)) {
        _controllerCart.editCartProduct(
          cartId: _controllerCart.cartMap[pid]!,
          quantity: count,
        );
      }
    }
    update();
  }
}
