import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/controller/home/controller_home_widget.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/theme/colors_app.dart';

import '../../core/languages/controllerLocale.dart';
import '../home/widgets.dart';

// ignore: must_be_immutable
class Language extends StatelessWidget {
  Language({super.key});

  final MyServices _myServices = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(
          label: '26'.tr,
          isBack: true,
          onTap: () {
            ControllerHomeWidget controllerHomeWidget = Get.find();
            Get.offNamed(NamePages.pBottomBar);
            controllerHomeWidget.onTapBottomBar(2);
          }),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: GetBuilder<ControllerLocal>(builder: (controller) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile(
                    activeColor: AppColors.primaryColor,
                    title: Text(
                      'العربية',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 14, fontFamily: 'ar'),
                    ),
                    value: 'ar',
                    groupValue: _myServices.sharedPreferences.getString('Lang'),
                    onChanged: (value) {
                      controller.chooseLanguages(
                          codeLocale: 'ar',
                          than: () {
                            controller.update();
                          });
                    }),
                RadioListTile(
                    activeColor: AppColors.primaryColor,
                    title: Text(
                      'English',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 14,
                            fontFamily: 'en',
                          ),
                    ),
                    value: 'en',
                    groupValue: _myServices.sharedPreferences.getString('Lang'),
                    onChanged: (value) {
                      controller.chooseLanguages(
                          codeLocale: 'en',
                          than: () {
                            controller.update();
                          });
                    }),
              ],
            ),
          );
        }),
      ),
    );
  }
}
