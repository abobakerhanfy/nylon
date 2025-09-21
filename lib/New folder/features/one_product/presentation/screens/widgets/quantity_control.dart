import 'package:flutter/material.dart';
import 'package:nylon/core/theme/colors_app.dart';

class QuantityControlWidget extends StatelessWidget {
  const QuantityControlWidget({super.key});

  @override
  Widget build(BuildContext context) {
   return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 29,
          height: 29,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: AppColors.primaryColor,
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('02', style: TextStyle(fontSize: 16, color: Colors.black)),
        ),
        Container(
          alignment: Alignment.center,
          width: 29,
          height: 29,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: AppColors.grayO,
          ),
          child: const Text('-', style: TextStyle(fontSize: 20, color: Colors.black38)),
        ),
      ],
    );
  }
}