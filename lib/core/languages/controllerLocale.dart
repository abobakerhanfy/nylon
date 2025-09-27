// lib/core/languages/controllerLocale.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../services/services.dart';
import '../theme/text_theme.dart'; // buildBaseTextTheme()
import 'package:nylon/controller/home/controller_home_widget.dart' as home;
import 'package:nylon/features/category/presentation/controller/controller_one_category.dart'
    as cat;

class ControllerLocal extends GetxController {
  final MyServices myServices = Get.find();

  Locale? languages;
  late ThemeData abbThem;
  late bool isLangAr;

  // ===== ثيمين أساسيين (بدون ألوان API) =====
  ThemeData get themeDataAr => ThemeData(
        useMaterial3: false,
        fontFamily: 'Cairo',
        brightness: Brightness.light,
        textTheme: buildBaseTextTheme(),
        scaffoldBackgroundColor: Colors.white,
      );

  ThemeData get themeDataEn => ThemeData(
        useMaterial3: false,
        fontFamily: 'Poppins',
        brightness: Brightness.light,
        textTheme: buildBaseTextTheme(),
        scaffoldBackgroundColor: Colors.white,
      );

  // تغيير اللغة + تطبيق الثيم + ريفرش الداتا المتأثرة
  void chooseLanguages({
    required String codeLocale,
    required Function() than,
  }) async {
    final Locale locale = _normalizeLocale(codeLocale);

    // احفظ الاختيار
    myServices.sharedPreferences.setString('Lang', codeLocale);

    // حدّد الثيم
    abbThem = codeLocale == 'en' ? themeDataEn : themeDataAr;
    isLangAr = codeLocale != 'en';

    // طبّق اللغة والثيم
    Get.updateLocale(locale);
    Get.changeTheme(abbThem);

    // ريفرش الشاشات اللي بتسحب داتا حسب اللغة
    await _refreshHomeAfterLocale();
    await refreshAfterLocaleChange();

    // كولباكك
    than();

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

  /// نعمل ريفرش للصفحات اللي بتسحب داتا حسب اللغة
  Future<void> refreshAfterLocaleChange() async {
    try {
      if (Get.isRegistered<home.ControllerHomeWidget>()) {
        final h = Get.find<home.ControllerHomeWidget>();
        await h.refreshHome();
        h.update();
      }
    } catch (_) {}

    try {
      if (Get.isRegistered<cat.ControllerOneCategory>()) {
        final c = Get.find<cat.ControllerOneCategory>();
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
    super.onInit();

    final String? sharedPrefLang =
        myServices.sharedPreferences.getString('Lang');

    if (sharedPrefLang == 'ar') {
      languages = const Locale('ar', 'SA');
      initializeDateFormatting('ar');
      abbThem = themeDataAr;
      isLangAr = true;
    } else if (sharedPrefLang == 'en') {
      languages = const Locale('en', 'GB');
      initializeDateFormatting('en');
      abbThem = themeDataEn;
      isLangAr = false;
    } else {
      // لغة الجهاز
      final deviceCode = Get.deviceLocale?.languageCode ?? 'en';
      languages = _normalizeLocale(deviceCode);
      final useAr = deviceCode == 'ar';
      abbThem = useAr ? themeDataAr : themeDataEn;
      isLangAr = useAr;
      initializeDateFormatting(useAr ? 'ar' : 'en');
    }

    // طبّق الوضع الحالي (مهم في أول تشغيل)
    Get.updateLocale(languages ?? const Locale('en', 'GB'));
    Get.changeTheme(abbThem);

    update();
  }
}
