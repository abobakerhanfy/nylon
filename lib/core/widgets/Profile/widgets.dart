import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../theme/colors_app.dart';

// ignore: non_constant_identifier_names
Widget ContainerProfileImage({required Function() onTap,required String svg,IconData? icon,
  required String label, required BoxConstraints boxSize}){
  return InkWell(
    onTap:onTap,
    child: Column(
      children: [
        svg != ''?
    Container(
          padding: const EdgeInsets.all(25),
          width: boxSize.maxWidth*0.25,
          height: boxSize.maxWidth*0.25,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderBlack28,width: 1),
            borderRadius: BorderRadius.circular(100),
          ),
          child: SvgPicture.asset(svg,fit: BoxFit.contain,),
        ):
          Container(
          padding: const EdgeInsets.all(25),
          width: boxSize.maxWidth*0.25,
          height: boxSize.maxWidth*0.25,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderBlack28,width: 1),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Icon(icon,color: Colors.black38,size: 40,),
        ),
        


    
       const  SizedBox(height: 10,),
        Text(label,style: Theme.of(Get.context!).textTheme.bodyMedium,
        textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}