import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/stepr_widget.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';

class WidgetStepper extends StatelessWidget {
  final int currentIndex;
  const WidgetStepper({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerCart>(builder: (controller) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EasyStepper(
            activeStep: controller.indexScreensCart,
            borderThickness: 0,
            lineStyle: LineStyle(
                lineLength: 25,
                lineType: LineType.normal,
                lineThickness: 0.5,
                lineSpace: 1,
                lineWidth: 10,
                defaultLineColor: AppColors.primaryColor),
            internalPadding: 2,
            showLoadingAnimation: false,
            showStepBorder: false,
            steps: [
              easyStepWidget(
                  index: 0,
                  currentIndex: currentIndex,
                  label: '38'.tr,
                  icon: Icons.shopping_cart),
              easyStepWidget(
                  index: 1,
                  currentIndex: currentIndex,
                  label: '40'.tr,
                  icon: Icons.location_on_outlined),
              easyStepWidget(
                index: 2,
                currentIndex: currentIndex,
                label: '39'.tr,
                icon: Icons.attach_money,
              ),
              //   easyStepWidget(index: 3, currentIndex: currentIndex, label:'167'.tr,icon:Icons.local_shipping_outlined,),
              easyStepWidget(
                index: 3,
                currentIndex: currentIndex,
                label: '41'.tr,
                icon: Icons.check_circle_outline,
              ),
            ],
          ),
        ],
      );
    });
  }
}
