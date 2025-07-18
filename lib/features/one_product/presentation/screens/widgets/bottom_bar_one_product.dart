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
                    // التحقق من نوع السعر
                    print(controller.count);

                    return Text(
                      ' ${'45'.tr} ${(controller.count * controller.products!.calculatePriceWithDiscount(controller.count)).toStringAsFixed(2)} ${"11".tr}',
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
                      _controller.plusCount();
                      _countController.text = _controller.count.toString();
                      _controller.update();

//   // تحقق من وجود المنتج في السلة وقم بتحديثه
//   if (_controllerCart.cartMap.containsKey(_controller.products!.productId!)) {
//     _controllerCart.editCartProduct(
//       cartId: _controllerCart.cartMap[_controller.products!.productId!]!,
//       quantity: _controller.count
//     );
//     _controller.update(); // تحديث الواجهة
//   } else {
//     print('المنتج مش موجود في السلة');
//   }

//   // تحديث الكمية والسعر
//   _controller.getCount();
//   _controller.update();
// },
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
                      _controller.minusCount();
                      _countController.text = _controller.count.toString();
                      _controller.update();
                      // // تحقق من وجود المنتج في السلة وقم بتحديثه
                      // if (_controllerCart.cartMap.containsKey(_controller.products!.productId!)) {
                      //   _controllerCart.editCartProduct(
                      //     cartId: _controllerCart.cartMap[_controller.products!.productId!]!,
                      //     quantity: _controller.count
                      //   );
                      //   _controller.update(); // تحديث الواجهة
                      // } else {
                      //   print('المنتج مش موجود في السلة');
                      // }

                      // // تحديث الكمية والسعر
                      // _controller.getCount();
                      // _controller.update();
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
                  await controllerCart.addOrRemoveCart(
                    idProduct: _controller.products!.productId!,
                    quantity: _controller.count,
                  );
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
                        controllerCart.cartMap
                                .containsKey(_controller.products!.productId!)
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
