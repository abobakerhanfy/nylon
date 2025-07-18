import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';

import '../../core/theme/colors_app.dart';

AppBar customAppBar(
    {required String label, required bool isBack, required Function onTap}) {
  ControllerCart conrollerr = Get.find();
  return AppBar(
    backgroundColor: AppColors.background,
    shadowColor: AppColors.background,
    surfaceTintColor: AppColors.background,
    elevation: 2,
    leading: isBack == true
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: CircleAvatar(
                radius: MediaQuery.of(Get.context!).size.width * 0.03,
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
      label,
      style: Theme.of(Get.context!)
          .textTheme
          .bodyMedium
          ?.copyWith(color: Colors.black),
    ),
    actions: [
      InkWell(
        onTap: () {
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GetBuilder<ControllerCart>(
                builder: (controller) {
                  return controller.cartMap.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 20, left: 0),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${controller.getTotalQuantity()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox();
                },
              ),
              SvgPicture.asset(
                'images/cart.svg',
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
