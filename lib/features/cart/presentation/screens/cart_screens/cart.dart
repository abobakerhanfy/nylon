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
  // استخدم الموجود إن كان مسجّل
  final ControllerCart _controller = Get.isRegistered<ControllerCart>()
      ? Get.find<ControllerCart>()
      : Get.put(ControllerCart());

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;

    return Container(
      color: fullAppBackgroundColor, // ✅ نفس خلفية الثيم
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: LayoutBuilder(
        builder: (context, boxSize) {
          return Obx(() {
            final controller = Get.find<ControllerCart>();
            final cartModel = controller.cartModel.value;

            final hasUnavailableProduct = cartModel?.products?.any(
                  (p) =>
                      (p.name?.contains('***') ?? false) || (p.stock == false),
                ) ??
                false;

            return HandlingDataView(
              statusRequest:
                  controller.statusRequestGetCart ?? StatusRequest.loading,
              onRefresh: () => controller.getCart(),
              widget: (cartModel?.products?.isNotEmpty ?? false)
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
                                      height: boxSize.maxHeight * 0.012),
                                  itemCount: cartModel!.products!.length,
                                  itemBuilder: (context, i) {
                                    final product = cartModel.products![i];
                                    final delay =
                                        Duration(milliseconds: 100 * i);

                                    // ✅ كرت المنتج: خلفية من الثيم + حدود من dividerColor
                                    return SlideInDown(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      delay: delay,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: cs.surface,
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                            color: t.dividerColor,
                                            width: 1,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: ContainerProductCart(
                                          products: product,
                                          onCart: false,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: boxSize.maxHeight * 0.02),

                        // ✅ إدخال كوبون (الزر ديناميكي اللون)
                        SlideInLeft(
                          duration: const Duration(milliseconds: 500),
                          child: const ApplyCouponWidget(),
                        ),

                        SizedBox(height: boxSize.maxHeight * 0.03),

                        // سطر الوصول لهدف الشحن
                        Row(
                          children: [
                            Icon(
                              controller.hasReachedTarget == true
                                  ? Icons.check_circle
                                  : Icons.delivery_dining,
                              size: 18,
                              color: controller.hasReachedTarget == true
                                  ? cs.primary
                                  : t.iconTheme.color,
                            ),
                            const SizedBox(width: 7),
                            Flexible(
                              child: Text(
                                controller.hasReachedTarget == true
                                    ? '189'.tr
                                    : '188'.tr,
                                style: t.textTheme.bodySmall
                                    ?.copyWith(fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: boxSize.maxHeight * 0.03),

                        // ✅ شريط التقدم لهدف 350 (لوان من الثيم)
                        CartProgressLine(
                          totalAmount: controller.remainingAmount,
                        ),

                        SizedBox(height: boxSize.maxHeight * 0.03),

                        // ✅ زر الإتمام (ياخذ ألوان الثيم)
                        FadeInUp(
                          duration: const Duration(milliseconds: 500),
                          child: Center(
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
                                    onTap: controller.plusIndexScreensCart,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: boxSize.maxHeight * 0.02),
                      ],
                    )
                  : Container(
                      color: fullAppBackgroundColor, // ✅ نفس خلفية الثيم

                      child: Center(
                        child: Text(
                          '149'.tr,
                          style: t.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            );
          });
        },
      ),
    );
  }
}

class ApplyCouponWidget extends StatelessWidget {
  const ApplyCouponWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    final ControllerCoupon controller = Get.isRegistered<ControllerCoupon>()
        ? Get.find<ControllerCoupon>()
        : Get.put(ControllerCoupon());

    return GetBuilder<ControllerCoupon>(builder: (_) {
      final enabled = controller.codeApplyCoupon.text.trim().isNotEmpty;

      return Form(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomFiledCart(
              width: MediaQuery.of(context).size.width * 0.60,
              hint: '43'.tr,
              controller: controller.codeApplyCoupon,
              validator: (value) =>
                  (value == null || value.isEmpty) ? '163'.tr : null,
              // ✅ مهم لتحديث لون الزر مع الكتابة:
              onChanged: (_) => controller.update(),
            ),
            controller.statusRequestApplyCoupon == StatusRequest.loading
                ? Center(child: CircularProgressIndicator(color: cs.primary))
                : InkWell(
                    onTap: enabled ? controller.applyCoupon : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.30,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: enabled
                              ? AppColors.primaryColor
                              : AppColors.primaryColor,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '44'.tr, // كلمة "تطبيق"
                        style: t.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
  final t = Theme.of(context);
  final cs = t.colorScheme;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FadeIn(
        child: AlertDialog(
          backgroundColor: cs.surface,
          title: Text('184'.tr, style: t.textTheme.bodyLarge),
          content: remainingAmount > 0
              ? RichText(
                  text: TextSpan(
                    style: t.textTheme.bodyMedium,
                    children: [
                      TextSpan(text: '${'181'.tr} '),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: remainingAmount.toStringAsFixed(2),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Image.asset(
                            'images/riyalsymbol_compressed.png',
                            height: 14,
                          ),
                        ),
                      ),
                      TextSpan(text: ' ${'182'.tr}'),
                    ],
                  ),
                )
              : Text('183'.tr, style: t.textTheme.bodyMedium),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('185'.tr, style: TextStyle(color: cs.primary)),
            ),
          ],
        ),
      );
    },
  );
}

class CartProgressLine extends StatelessWidget {
  final double totalAmount; // هنا هي المتبقي للوصول للهدف في كنترولرك
  final double targetAmount = 350.0;

  const CartProgressLine({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;

    // لو totalAmount = المتبقي → التقدم = (الهدف - المتبقي) / الهدف
    final remaining = totalAmount;
    final progress = (targetAmount - remaining) / targetAmount;
    final clamped = progress.clamp(0.0, 1.0);

    return LinearPercentIndicator(
      lineHeight: 6.0,
      percent: clamped.toDouble(),
      barRadius: const Radius.circular(999),
      backgroundColor: t.dividerColor.withOpacity(0.35),
      progressColor: cs.primary,
      animation: true,
      animationDuration: 500,
    );
  }
}
