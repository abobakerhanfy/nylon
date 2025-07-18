import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/theme/colors_app.dart';

easyStepWidget(
    {required int index,
    required int currentIndex,
    required String label,
    required IconData icon}) {
  return EasyStep(
      customStep: Container(
          width: 68,
          height: 69,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: index == currentIndex || index < currentIndex
                ? AppColors.primaryColor
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
              child: Icon(
            icon,
            size: 24,
            color: index == currentIndex || index < currentIndex
                ? Colors.white
                : Colors.black,
          ))),
      customTitle: index == currentIndex || index < currentIndex
          ? Text(
              label,
              style: Theme.of(Get.context!)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textColor1),
              textAlign: TextAlign.center,
            )
          : Text(
              label,
              style: Theme.of(Get.context!)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.black38),
              textAlign: TextAlign.center,
            ));
}
