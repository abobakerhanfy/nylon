import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/theme/colors_app.dart';

AwesomeDialog customDialog(
    {required String body,
    required String title,
    required DialogType dialogType,
    required BuildContext context}) {
  return AwesomeDialog(
      context: context,
      title: title,
      padding: const EdgeInsets.all(10),
      dialogType: dialogType,
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(body,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center)
          ],
        ),
      ),
      titleTextStyle: Theme.of(context).textTheme.labelSmall)
    ..show();
}

AwesomeDialog customDialogAcation(
    {required String title,
    required Function() onTap,
    required DialogType dialogType}) {
  return AwesomeDialog(
      context: Get.context!,
      title: title,
      padding: const EdgeInsets.all(10),
      dialogType: dialogType,
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    onTap();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.primaryColor
                        // border: Border.all(color:colorBorder,width: 1)
                        ),
                    child: Text(
                      'موافق',
                      style: Theme.of(Get.context!)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Get.theme.scaffoldBackgroundColor),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.colorRed
                        // border: Border.all(color:colorBorder,width: 1)
                        ),
                    child: Text(
                      'الغاء',
                      style: Theme.of(Get.context!)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Get.theme.scaffoldBackgroundColor),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      titleTextStyle: Theme.of(Get.context!).textTheme.labelSmall)
    ..show();
}

AwesomeDialog newCustomDialog({
  required String title,
  required DialogType dialogType,
  Widget? body,
}) {
  return AwesomeDialog(
      context: Get.context!,
      title: title,
      padding: const EdgeInsets.all(10),
      dialogType: dialogType,
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: Theme.of(Get.context!)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            body!
          ],
        ),
      ),
      titleTextStyle: Theme.of(Get.context!).textTheme.labelSmall)
    ..show();
}
