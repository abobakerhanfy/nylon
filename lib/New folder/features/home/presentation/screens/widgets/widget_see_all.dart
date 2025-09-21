import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/languages/function_string.dart';
import '../../../../../core/theme/colors_app.dart';

Widget SeeAll({
  required Function() onTap,
  required String titleAr,
  required String titleEn,
  String? categoryId, // ✅ أضف هذا
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    child: Row(
      children: [
        Text(
          translate(titleAr, titleEn)!,
          style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                color: AppColors.textColorHome,
              ),
        ),
        const Spacer(),
        InkWell(
          onTap: onTap,

          // onTap: () {
          //   Get.toNamed(
          //     NamePages.pOneCategory,
          //     arguments: {
          //       "categoryId": 131,
          //       "titleAr": titleAr,
          //       "titleEn": titleEn,
          //     },
          //   );
          // },
          child: Text(
            'more_item'.tr,
            style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
                  color: AppColors.textColorHome,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ),
      ],
    ),
  );
}
