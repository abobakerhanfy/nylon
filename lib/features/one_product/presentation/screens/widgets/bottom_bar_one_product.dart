import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';
import 'package:nylon/features/one_product/presentation/controller/controller_one_product.dart';

class BottomNavigationBarOneProduct extends StatefulWidget {
  const BottomNavigationBarOneProduct({super.key});

  @override
  State<BottomNavigationBarOneProduct> createState() =>
      _BottomNavigationBarOneProductState();
}

class _BottomNavigationBarOneProductState
    extends State<BottomNavigationBarOneProduct> {
  final ControllerOneProduct _controller = Get.find();
  final ControllerCart _controllerCart = Get.find();

  final TextEditingController _countController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_controller.count = _controller.getCount();
    _countController.text =
        _controller.count.toString(); // تهيئة الحقل بالنص الحالي
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
      height: MediaQuery.of(context).size.height * 0.15,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Expanded(
                child: GetBuilder<ControllerOneProduct>(
                  builder: (controller) {
                    // التحقق من وجود البيانات قبل الحساب
                    if (controller.products == null ||
                        controller.productModel == null) {
                      return Text(
                        '${'45'.tr} 0.00 ${"11".tr}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textColor1,
                              fontSize: 13,
                            ),
                      );
                    }

                    // التحقق من نوع السعر
                    print(controller.count);

                    // حساب آمن للسعر
                    double totalPrice = 0.0;
                    try {
                      if (controller.productModel?.calculatePriceWithDiscount !=
                          null) {
                        totalPrice = controller.count *
                            controller.productModel!
                                .calculatePriceWithDiscount(controller.count);
                      } else if (controller.products != null) {
                        // fallback calculation
                        final price = controller.products!.special ??
                            controller.products!.price ??
                            0.0;
                        totalPrice = (controller.count * price).toDouble();
                      }
                    } catch (e) {
                      print('Error calculating price: $e');
                      totalPrice = 0.0;
                    }

                    return Text(
                      ' ${'45'.tr} ${totalPrice.toStringAsFixed(2)} ${"11".tr}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textColor1,
                            fontSize: 13,
                          ),
                    );
                  },
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      // تحقق من وجود البيانات قبل العمليات
                      if (_controller.products != null) {
                        _controller.plusCount();
                        _countController.text = _controller.count.toString();
                        _controller.update();
                      }
                    },
                    child: Container(
                      width: 29,
                      height: 29,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColors.primaryColor,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: 60,
                      height: 30, // عرض ثابت لحقل النص
                      child: TextField(
                          controller: _countController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                          ),
                          onSubmitted: (value) {
                            // تحقق من وجود البيانات قبل العمليات
                            if (_controller.products == null) return;

                            _controller.count = int.tryParse(value) ?? 1;
                            if (_controller.count > 0) {
                              if (_controllerCart.cartMap.containsKey(
                                  _controller.products!.productId!)) {
                                _controllerCart.editCartProduct(
                                    cartId: _controllerCart.cartMap[
                                        _controller.products!.productId!]!,
                                    quantity: _controller.count);
                                _controller.update();
                              } else {
                                print('المنتج مش موجود في السلة');
                              }
                            } else {
                              print(
                                  'يجب أن تكون القيمة المدخلة رقمًا أكبر من الصفر');
                            }
                            _controller.getCount();
                            _controller.update();
                          },
                          onChanged: (value) {
                            _controller.count = int.tryParse(value) ?? 1;
                          }),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // تحقق من وجود البيانات قبل العمليات
                      if (_controller.products != null) {
                        _controller.minusCount();
                        _countController.text = _controller.count.toString();
                        _controller.update();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 29,
                      height: 29,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColors.grayO,
                      ),
                      child: const Text('-',
                          style:
                              TextStyle(fontSize: 20, color: Colors.black38)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GetBuilder<ControllerCart>(
            builder: (controllerCart) {
              return InkWell(
                onTap: () async {
                  // تحقق من وجود البيانات قبل إضافة للسلة
                  if (_controller.products?.productId != null) {
                    try {
                      await controllerCart.addOrRemoveCart(
                        idProduct: _controller.products!.productId!,
                        quantity: _controller.count,
                      );
                    } catch (e) {
                      print('Error adding to cart: $e');
                      Get.snackbar(
                        'خطأ',
                        'حدث خطأ أثناء إضافة المنتج للسلة',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  } else {
                    print('Product data not available');
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('images/cart.svg', color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        // تحقق آمن من وجود البيانات
                        (_controller.products?.productId != null &&
                                controllerCart.cartMap.containsKey(
                                    _controller.products!.productId!))
                            ? '150'.tr
                            : '62'.tr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
