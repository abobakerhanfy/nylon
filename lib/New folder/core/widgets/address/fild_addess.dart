import 'package:flutter/material.dart';
import 'package:nylon/core/theme/colors_app.dart';

class TextFildAddess extends StatelessWidget {
  final String label;
   final String? Function(String?)?  valid;
  final TextInputType textInputType;
  final TextEditingController controller;
  const TextFildAddess({
    super.key, required this.label,required this.valid, required this.textInputType, required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Colors.black,fontSize: 15
      ),
      validator:valid,
       autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: textInputType,
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:AppColors.primaryColor),),
           enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey,width: 0.5), // لون الحدود عند عدم التركيز
            ),
        hoverColor: Colors.amber,
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.colorLabel,fontWeight: FontWeight.normal
        ),
    ),
      
    );
  }
}