import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';
import 'package:nylon/features/cart/presentation/screens/cart_screens/cart.dart';
import 'package:nylon/features/cart/presentation/screens/cart_screens/order_confirmation_new.dart';
import 'package:nylon/features/cart/presentation/screens/cart_screens/verification_user.dart';
import 'package:nylon/features/cart/presentation/screens/cart_screens/order_successfully.dart';

class ScreenCart extends StatefulWidget {
  const ScreenCart({super.key});

  @override
  State<ScreenCart> createState() => _ScreenCartState();
}

class _ScreenCartState extends State<ScreenCart> {
  final ControllerCart _controller = Get.find<ControllerCart>();

  final List<Widget> screensCart = [
    Cart(),
    VerificationUserCart(),
    OrderConfirmationNew(),
    const OrderSuccessfully(),
  ];

  final List<String> screensCartTitle = ['33'.tr, '34'.tr, '36'.tr, '37'.tr];

  @override
  void initState() {
    super.initState();
    _controller.indexScreensCart = 0; // Reset once only here ✅
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerCart>(
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 2,
            leading: controller.indexScreensCart != 0
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    child: InkWell(
                      onTap: () {
                        if (controller.indexScreensCart == 3) {
                          Get.offAllNamed(NamePages.pBottomBar);
                        } else {
                          controller.minusIndexScreensCart();
                        }
                      },
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.03,
                        backgroundColor: Colors.black,
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            centerTitle: false,
            title: Text(
              screensCartTitle[controller.indexScreensCart],
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textColor),
            ),
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: LayoutBuilder(
              builder: (context, boxSize) {
                return Column(
                  children: [
                    SizedBox(
                      height: boxSize.maxHeight * 0.04,
                    ),
                    Expanded(
                      child: PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: screensCart.length,
                        itemBuilder: (context, i) {
                          print('Page index: ${controller.indexScreensCart}');
                          return screensCart[controller.indexScreensCart];
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
