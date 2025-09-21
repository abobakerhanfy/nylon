import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/shipping/data/models/shipping_methods.dart';
import 'package:nylon/features/shipping/presentation/controller/controller_shipping.dart';

// ignore: must_be_immutable
class ContainerSelectShippingMethod extends StatelessWidget {
  final ShippingMethod shippingMethod;
  String? codeShipping;

  ContainerSelectShippingMethod({
    super.key,
    required this.shippingMethod,
    this.codeShipping,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerShipping>(
      builder: (controller) {
        return InkWell(
          onTap: () {
            if (shippingMethod.quotes != null &&
                shippingMethod.quotes!.isNotEmpty) {
              controller.slectCode(
                  code: shippingMethod.quotes!.values.first.code ?? '',
                  title: shippingMethod.quotes!.values.first.title != null
                      ? '${shippingMethod.quotes!.values.first.title}'
                      : '');
            } else {
              print('Quotes is null or empty');
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.90,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: AppColors.colorCreditCard,
                borderRadius: BorderRadius.circular(0),
                border: Border.all(
                    color:
                        codeShipping == shippingMethod.quotes!.values.first.code
                            ? AppColors.primaryColor
                            : AppColors.colorCreditCard,
                    width: 2)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      shippingMethod.quotes!.values.first.title != null
                          ? '${shippingMethod.quotes!.values.first.title}'
                          : '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            color: const Color.fromARGB(255, 31, 27, 27),
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  if (codeShipping == shippingMethod.quotes!.values.first.code)
                    Icon(
                      Icons.check_circle,
                      color: AppColors.primaryColor,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
