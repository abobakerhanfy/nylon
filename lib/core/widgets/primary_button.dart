
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:nylon/core/theme/colors_app.dart';

class PrimaryButton extends StatelessWidget {
  final Function() onTap;
  final String label;
  double?  height;
 PrimaryButton({super.key, required this.onTap, required this.label,this.height});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap,
      child: Container(
        alignment: Alignment.center,
        width: 376,
        height:height?? 58,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label,style: Theme.of(context).textTheme.headlineMedium,),
      ),
    );
  }
}
