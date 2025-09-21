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
          final currentCode = Get.locale?.languageCode ??
              _myServices.sharedPreferences.getString('Lang') ??
              'ar';

          final isAr = currentCode == 'ar';

          return Directionality(
            textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile(
                  activeColor: AppColors.primaryColor,
                  title: Text('العربية',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 14, fontFamily: 'ar')),
                  value: 'ar',
                  groupValue: currentCode, // <-- بدل الـ prefs هنا
                  onChanged: (_) {
                    controller.chooseLanguages(
                        codeLocale: 'ar',
                        than: () {
                          // نرجّع للواجهة الرئيسية
                          Get.offAllNamed(NamePages.pBottomBar);
                        });
                  },
                ),
                RadioListTile(
                  activeColor: AppColors.primaryColor,
                  title: Text('English',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 14, fontFamily: 'en')),
                  value: 'en',
                  groupValue: currentCode, // <-- بدل الـ prefs هنا
                  onChanged: (_) {
                    controller.chooseLanguages(
                        codeLocale: 'en',
                        than: () {
                          Get.offAllNamed(NamePages.pBottomBar);
                        });
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
