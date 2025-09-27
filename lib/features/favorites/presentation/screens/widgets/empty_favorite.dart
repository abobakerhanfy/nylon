import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/theme/colors_app.dart';

class EmptyFov extends StatelessWidget {
  const EmptyFov({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.40,
              child: Image.asset('images/test12.png')),
          Text('21'.tr,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(color: AppColors.borderBlack28, fontSize: 25))
        ],
      ),
    );
  }
}
