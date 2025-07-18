import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/container_cart_product.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/button_on_cart.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/field_cart.dart';
import 'package:nylon/features/coupon/presentation/controller/controller_coupon.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class StaggeredSlideIn extends StatelessWidget {
  final int index;
  final Widget child;

  const StaggeredSlideIn({super.key, required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return SlideInDown(
      duration: const Duration(milliseconds: 500),
      delay: Duration(milliseconds: 100 * index),
      child: child,
    );
  }
}

class _CartState extends State<Cart> {
  final ControllerCart _controller = Get.put(ControllerCart());
  var x = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: LayoutBuilder(
        builder: (context, boxSize) {
          return Obx(() {
            final controller = Get.find<ControllerCart>();
            final cartModel = controller.cartModel.value;
            final hasUnavailableProduct = cartModel?.products?.any(
                  (product) =>
                      product.name?.contains('***') == true ||
                      product.stock == false,
                ) ??
                false;

            return HandlingDataView(
              statusRequest:
                  controller.statusRequestGetCart ?? StatusRequest.loading,
              widget: cartModel != null &&
                      cartModel.products != null &&
                      cartModel.products!.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 8),
                                child: ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  separatorBuilder: (context, i) => SizedBox(
                                      height: boxSize.maxHeight * 0.01),
                                  itemCount: cartModel.products?.length ?? 0,
                                  itemBuilder: (context, i) {
                                    final delay =
                                        Duration(milliseconds: 100 * i);
                                    return SlideInDown(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      delay: delay,
                                      child: ContainerProductCart(
                                        products: cartModel.products![i],
                                        onCart: false,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: boxSize.maxHeight * 0.02),
                        SlideInLeft(
                          duration: const Duration(milliseconds: 500),
                          child: ApplyCouponWidget(),
                        ),
                        SizedBox(height: boxSize.maxHeight * 0.03),
                        Row(
                          children: [
                            Icon(
                              controller.hasReachedTarget == true
                                  ? Icons.check_circle
                                  : Icons.delivery_dining,
                              size: 18,
                              color: controller.hasReachedTarget == true
                                  ? AppColors.primaryColor
                                  : Colors.black,
                            ),
                            const SizedBox(width: 7),
                            Flexible(
                              child: Text(
                                controller.hasReachedTarget == true
                                    ? '189'.tr
                                    : '188'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: boxSize.maxHeight * 0.03),
                        CartProgressLine(
                          totalAmount: controller.remainingAmount,
                        ),
                        SizedBox(height: boxSize.maxHeight * 0.03),

                        // 🟢 الفاتورة

                        FadeInUp(
                          duration: const Duration(milliseconds: 500),
                          child: SizedBox(
                            height: 48,
                            child: IgnorePointer(
                              ignoring: hasUnavailableProduct,
                              child: Opacity(
                                opacity: hasUnavailableProduct ? 0.6 : 1.0,
                                child: ButtonOnCart(
                                  width: boxSize.maxWidth * 0.80,
                                  label: hasUnavailableProduct
                                      ? '214'.tr
                                      : '54'.tr,
                                  onTap: () {
                                    controller.plusIndexScreensCart();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: boxSize.maxHeight * 0.02),
                      ],
                    )
                  : Center(
                      child: Text(
                        '149'.tr,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
              onRefresh: () {
                controller.getCart();
              },
            );
          });
        },
      ),
    );
  }
}

class ApplyCouponWidget extends StatelessWidget {
  ApplyCouponWidget({super.key});
  final ControllerCoupon _controller = Get.put(ControllerCoupon());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerCoupon>(builder: (controller) {
      return Form(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomFiledCart(
              width: MediaQuery.of(context).size.width * 0.60,
              hint: '43'.tr,
              controller: controller.codeApplyCoupon,
              validator: (value) => value!.isEmpty ? '163'.tr : null,
            ),
            controller.statusRequestApplyCoupon == StatusRequest.loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : InkWell(
                    onTap: () {
                      controller.applyCoupon();
                    },
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.30,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          '44'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      );
    });
  }
}

void showDiscountMessage(BuildContext context, double remainingAmount) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FadeIn(
        child: AlertDialog(
          title: Text('184'.tr, style: Theme.of(context).textTheme.bodyLarge),
          content: remainingAmount > 0
              ? RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(text: '${'181'.tr} '),
                      TextSpan(
                        text: remainingAmount.toStringAsFixed(2),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Image.asset(
                            "images/riyalsymbol_compressed.png",
                            height: 14,
                          ),
                        ),
                      ),
                      TextSpan(text: ' ${'182'.tr}'),
                    ],
                  ),
                )
              : Text(
                  '183'.tr,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                '185'.tr,
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class CartProgressLine extends StatelessWidget {
  final double totalAmount;
  final double targetAmount = 350.0;

  const CartProgressLine({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    double progress = (totalAmount / targetAmount).clamp(0.0, 1.0);

    return LinearPercentIndicator(
      lineHeight: 5.0,
      percent: progress,
      backgroundColor: Colors.green,
      progressColor: Colors.grey.shade300,
      animation: true,
      animationDuration: 500,
    );
  }
}
