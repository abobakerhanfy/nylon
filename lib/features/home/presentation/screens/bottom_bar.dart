import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nylon/controller/home/controller_home_widget.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerHomeWidget>(
      init: ControllerHomeWidget(),
      builder: (controller) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.indexBar,
            elevation: 16,
            backgroundColor: Get.theme.scaffoldBackgroundColor,
            selectedItemColor: Colors.black,
            unselectedItemColor: AppColors.textColor,
            showUnselectedLabels: true,
            onTap: (value) {
              controller.onTapBottomBar(value);
            },
            unselectedLabelStyle: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                    fontSize: 8,
                    color: Colors.red,
                    fontWeight: FontWeight.normal),
            selectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 8, color: Colors.red, fontWeight: FontWeight.normal),
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SvgPicture.asset('images/home.svg'),
                ),
                label: '16'.tr,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SvgPicture.asset('images/cartigries.svg'),
                ),
                label: '17'.tr,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SvgPicture.asset('images/cart.svg'),

                      // ✅ البادج يتبنَى على تحديثات ControllerCart
                      GetBuilder<ControllerCart>(
                        builder: (cartController) {
                          final count =
                              cartController.getLinesCount(); // ← عدد الأسطر
                          if (count == 0) return const SizedBox.shrink();
                          return Positioned(
                            right: -4,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              constraints: const BoxConstraints(
                                  minWidth: 18, minHeight: 18),
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  color: Get.theme.scaffoldBackgroundColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                label: '18'.tr,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SvgPicture.asset('images/fov.svg'),
                ),
                label: '19'.tr,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SvgPicture.asset('images/profile.svg'),
                ),
                label: '20'.tr,
              ),
            ],
          ),
          body: controller.screens.elementAt(controller.indexBar),
        );
      },
    );
  }
}
