import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/addresses/presentation/controller/adreess_controller.dart';

class SelectNameAddressContainer extends StatelessWidget {
  final String label;
  final int index;
  final Function() onTap;
  const SelectNameAddressContainer({
    super.key,
    required this.label,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerAddress>(
        init: ControllerAddress(),
        builder: (controller) {
          return InkWell(
            onTap: onTap,
            child: Container(
              alignment: Alignment.center,
              height: 42,
              width: MediaQuery.of(context).size.width / 4,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: controller.cCompany.text == label
                      ? AppColors.primaryColor
                      : null,
                  border: Border.all(color: AppColors.backGFieldPh, width: 2)),
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: controller.cCompany.text == label
                        ? Colors.white
                        : Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
            ),
          );
        });
  }
}
