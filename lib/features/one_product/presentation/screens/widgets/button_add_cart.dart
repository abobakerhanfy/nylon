import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nylon/core/theme/colors_app.dart';

class ButtonAddToCart extends StatelessWidget {
  const ButtonAddToCart({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('ddd');
        // Get.toNamed(NamePages.pSignIn);
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
                color: Theme.of(context).scaffoldBackgroundColor),
            const SizedBox(width: 8),
            Text(
              '62'.tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Get.theme.scaffoldBackgroundColor,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
