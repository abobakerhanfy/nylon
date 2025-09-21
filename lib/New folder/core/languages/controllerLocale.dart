import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../services/services.dart';
import '../theme/text_theme.dart';
import 'package:nylon/controller/home/controller_home_widget.dart' as home;
import 'package:nylon/features/category/presentation/controller/controller_one_category.dart'
    as cat;

class ControllerLocal extends GetxController {
  MyServices myServices = Get.find();
  Locale? languages;
  ThemeData abbThem = themeDataEn;
  late bool isLangAr;
  chooseLanguages({required String codeLocale, required Function() than}) {
    Locale locale = _normalizeLocale(codeLocale); // ✅ بدل Locale(codeLocale)

    myServices.sharedPreferences.setString('Lang', codeLocale);
    abbThem = codeLocale == 'en' ? themeDataEn : themeDataAr;
    Get.changeTheme(abbThem);
    isLangAr = codeLocale != 'en';

// ✅ خلّي re-fetch يتم بعد ما اللغة تتطبّق
    Get.updateLocale(locale).then((_) async {
      await _refreshHomeAfterLocale(); // ✅ أهم سطر

      than();
    });

    print(codeLocale);
    update();
  }

  /// ترجمة كود اللغة إلى باراميتر الـ API
  String get apiLang {
    final code = Get.locale?.languageCode ??
        myServices.sharedPreferences.getString('Lang') ??
        'en';
    return code == 'ar' ? 'ar' : 'en-gb';
  }

  /// نطبع Locale قياسي (ar_SA / en_GB)
  Locale _normalizeLocale(String code) {
    if (code == 'ar') return const Locale('ar', 'SA');
    return const Locale('en', 'GB');
  }

  /// نعمل ريفرش للصفحات اللي بتسحب داتا حسب اللغة (من غير حذف أي كود عندك)
  Future<void> refreshAfterLocaleChange() async {
    try {
      if (Get.isRegistered<home.ControllerHomeWidget>()) {
        final h = Get.find<home.ControllerHomeWidget>();
        // دالة الهوم اللي بتجيب Home/full_screen — متوقع عندك
        await h.refreshHome();
        h.update();
      }
    } catch (_) {}

    try {
      if (Get.isRegistered<cat.ControllerOneCategory>()) {
        final c = Get.find<cat.ControllerOneCategory>();
        // لو واقف في صفحة قسم معيّن أعد الجلب بنفس الـ id
        if ((c.categoryId ?? '').isNotEmpty) {
          c.initPage = 1;
          await c.getOneCategory(id: c.categoryId!);
          await c.getMoreCategory();
          c.update();
        }
      }
    } catch (_) {}
  }

  Future<void> _refreshHomeAfterLocale() async {
    if (Get.isRegistered<home.ControllerHomeWidget>()) {
      await Get.find<home.ControllerHomeWidget>().refreshHome();
    }
  }

  @override
  void onInit() {
    String? sharedPrefLang = myServices.sharedPreferences.getString('Lang');
    if (sharedPrefLang == 'ar') {
      languages = const Locale('ar');
      initializeDateFormatting("ar");
      abbThem = themeDataAr;
      isLangAr = true;
    } else if (sharedPrefLang == 'en') {
      initializeDateFormatting('en');
      languages = const Locale('en');
      abbThem = themeDataEn;
      isLangAr = false;
    } else {
      final deviceCode = Get.deviceLocale?.languageCode ?? 'en';
      languages = _normalizeLocale(deviceCode);
    }
    print(languages);
    super.onInit();
    update();
  }
}
