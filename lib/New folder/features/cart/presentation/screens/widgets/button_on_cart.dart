import 'package:flutter/material.dart';

import '../../../../../../../core/theme/colors_app.dart';

class ButtonOnCart extends StatelessWidget {
  final double width;
  final String label;
  final Function() onTap;
  const ButtonOnCart(
      {super.key,
      required this.width,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(20), // إضافة border radius للـ ripple effect
        onTap: onTap,
        child: Container(
          height: 50,
          width: width,
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Text(label,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
