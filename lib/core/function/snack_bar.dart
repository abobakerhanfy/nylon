import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/theme/colors_app.dart';

void showSnackBar(String message) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 700),
      content: Center(
          child: Text(
        message,
        style: Theme.of(Get.context!)
            .textTheme
            .bodySmall
            ?.copyWith(color: Get.theme.scaffoldBackgroundColor),
      )),
      backgroundColor: AppColors.primaryColor,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
