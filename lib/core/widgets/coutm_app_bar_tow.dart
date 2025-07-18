import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/static/static_images.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/home/presentation/controller/home_controller.dart';

AppBar customAppBarTow({required String title, List<Widget>? actions}) {
  return AppBar(
    backgroundColor: AppColors.background,
    centerTitle: true,
    shadowColor: AppColors.background,
    surfaceTintColor: AppColors.background,
    elevation: 2,
    actions: actions,
    title: GetBuilder<ControllerHome>(builder: (controller) {
      return controller.logo != '' &&
              controller.statusRequestLogo == StatusRequest.success
          ? Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover, image: NetworkImage(controller.logo))),
            )
          : Container(
              width: 100,
              height: 50,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage(StaticAppImages.imageLogo))),
            );

      // Text(title,style:const  TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black,),textAlign: TextAlign.center,),
    }),
  );
}
