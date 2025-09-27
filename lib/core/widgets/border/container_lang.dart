import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/languages/controllerLocale.dart';
import 'package:nylon/core/routes/name_pages.dart';

import '../../theme/colors_app.dart';

// ignore: must_be_immutable
class ContainerLang extends StatelessWidget {
  final BoxConstraints boxSize;
  final String label;
  final String local;
  ContainerLang(
      {super.key,
      required this.boxSize,
      required this.label,
      required this.local});
  final ControllerLocal _controllerLocal = Get.find();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _controllerLocal.chooseLanguages(
            codeLocale: local, than: () => Get.toNamed(NamePages.pOnBordering));
      },
      child: Container(
        alignment: Alignment.center,
        width: boxSize.maxWidth * 0.40,
        height: 50,
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          border: Border.all(color: AppColors.borderBlack28, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.normal,
                  color: AppColors.borderBlack28,
                  fontSize: 20,
                )),
      ),
    );
  }
}
