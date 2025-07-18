import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/orders/presentation/controller/controller_order.dart';
import 'package:animate_do/animate_do.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';

class OrderSuccessfully extends StatefulWidget {
  const OrderSuccessfully({super.key});

  @override
  State<OrderSuccessfully> createState() => _OrderSuccessfullyState();
}

class _OrderSuccessfullyState extends State<OrderSuccessfully> {
  final ControllerOrder _controllerOrder = Get.put(ControllerOrder());
  final ControllerLogin _controllerLogin = Get.find();

  @override
  void initState() {
    super.initState();

    Future(() async {
      final cartController = Get.find<ControllerCart>();
      await cartController.clearCartFromServer(); // ← من السيرفر
      cartController.clearCartData(); // ← من الحالة
    });

    Future.delayed(const Duration(seconds: 5), () {
      Get.offAllNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        color: AppColors.background,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        width: screenWidth,
        height: screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: AppColors.background,
              height: screenHeight * 0.35,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  BounceInDown(
                    duration: const Duration(milliseconds: 2300),
                    child: SvgPicture.asset(
                      'images/test10.svg',
                      fit: BoxFit.fill,
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.35,
                      placeholderBuilder: (BuildContext context) =>
                          const CircularProgressIndicator(),
                      semanticsLabel: 'Success Image',
                    ),
                  ),
                  ZoomIn(
                    duration: const Duration(milliseconds: 2300),
                    child: CircleAvatar(
                      radius: screenHeight * 0.10,
                      backgroundColor: AppColors.primaryColor,
                      child: const Icon(
                        Icons.check,
                        size: 75,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Text(
              '58'.tr,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.borderBlack28,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              '${'59'.tr} ${_controllerOrder.orderIdSuccess ?? ''}',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.borderBlack28,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              '60'.tr,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.borderBlack28,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
