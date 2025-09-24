import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/stepr_widget.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';

class WidgetStepper extends StatefulWidget {
  final int currentIndex;
  const WidgetStepper({super.key, required this.currentIndex});

  @override
  State<WidgetStepper> createState() => _WidgetStepperState();
}

class _WidgetStepperState extends State<WidgetStepper>
    with TickerProviderStateMixin {
  late AnimationController _cartPulseController;
  late Animation<double> _cartPulseAnimation;

  @override
  void initState() {
    super.initState();

    _cartPulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cartPulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _cartPulseController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _cartPulseController.dispose();
    super.dispose();
  }

  void triggerCartAnimation() {
    _cartPulseController.forward().then((_) {
      _cartPulseController.reverse();
    });
  }

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
              // Cart step with animation
              EasyStep(
                customStep: AnimatedBuilder(
                  animation: _cartPulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: widget.currentIndex == 0
                          ? _cartPulseAnimation.value
                          : 1.0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.indexScreensCart >= 0
                              ? AppColors.primaryColor
                              : Colors.grey.shade400,
                          boxShadow: controller.indexScreensCart >= 0
                              ? [
                                  BoxShadow(
                                    color:
                                        AppColors.primaryColor.withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  )
                                ]
                              : null,
                        ),
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    );
                  },
                ),
                title: '38'.tr,
              ),

              // باقي الخطوات عادية
              easyStepWidget(
                  index: 1,
                  currentIndex: widget.currentIndex,
                  label: '40'.tr,
                  icon: Icons.location_on_outlined),
              easyStepWidget(
                index: 2,
                currentIndex: widget.currentIndex,
                label: '39'.tr,
                icon: Icons.attach_money,
              ),
              easyStepWidget(
                index: 3,
                currentIndex: widget.currentIndex,
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

// إضافة method للتحكم في animation من خارج الكلاس
extension StepperAnimation on _WidgetStepperState {
  void animateCart() {
    triggerCartAnimation();
  }
}
