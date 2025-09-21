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
    _countController.text = _controller.count.toString();
  }

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ارتفاع ثابت لتفادي overflow الغريب
    const double kBarHeight = 110;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
      height: kBarHeight,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              // الإجمالي
              Expanded(
                child: GetBuilder<ControllerOneProduct>(
                  builder: (controller) {
                    final unit =
                        controller.unitPriceWithDiscount(controller.count);
                    final total = unit * controller.count;

                    return Text(
                      ' ${'45'.tr} ${total.toStringAsFixed(2)} ${"11".tr}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textColor1,
                            fontSize: 13,
                          ),
                    );
                  },
                ),
              ),

              // عداد الكمية
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // +
                  InkWell(
                    onTap: () {
                      _controller.plusCount();
                      _countController.text = _controller.count.toString();
                      _controller.update();
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

                  // input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: 60,
                      height: 30,
                      child: TextField(
                        controller: _countController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                        ),
                        onSubmitted: (value) {
                          final parsed = int.tryParse(value) ?? 1;
                          _controller.count = parsed > 0 ? parsed : 1;

                          // لو في منتج بالسلة — حدّثه
                          final pid = _controller.safeProductId;
                          if (pid != null) {
                            final cartId = _controllerCart.cartMap[pid];
                            if (cartId != null) {
                              _controllerCart.editCartProduct(
                                cartId: cartId,
                                quantity: _controller.count,
                              );
                            }
                          }

                          _controller.getCount();
                          _controller.update();
                          _countController.text = _controller.count.toString();
                        },
                        onChanged: (value) {
                          _controller.count = int.tryParse(value) ?? 1;
                        },
                      ),
                    ),
                  ),

                  // -
                  InkWell(
                    onTap: () {
                      _controller.minusCount();
                      _countController.text = _controller.count.toString();
                      _controller.update();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 29,
                      height: 29,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColors.grayO,
                      ),
                      child: const Text(
                        '-',
                        style: TextStyle(fontSize: 20, color: Colors.black38),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // زر السلة
          GetBuilder<ControllerCart>(
            builder: (controllerCart) {
              final pid = _controller.safeProductId;
              final enabled = pid != null && pid.isNotEmpty;
              final inCart =
                  enabled ? controllerCart.cartMap.containsKey(pid) : false;

              return Opacity(
                opacity: enabled ? 1 : 0.5,
                child: IgnorePointer(
                  ignoring: !enabled,
                  child: InkWell(
                    onTap: () async {
                      if (!enabled) return;

                      await controllerCart.addOrRemoveCart(
                        idProduct: pid!, // String آمن
                        quantity: _controller.count,
                      );

                      // ✅ بعد الإضافة/الإزالة حدّث العداد فورًا (يرجع السلوك القديم)
                      _controller.getCount();
                      _controller.update();
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
                          SvgPicture.asset('images/cart.svg',
                              color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            inCart ? '150'.tr : '62'.tr,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
