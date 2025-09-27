// lib/core/theme/app_theme_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:flutter/services.dart';

import 'package:nylon/core/url/url_api.dart'; // AppApi.getThemeColor
import 'package:nylon/core/function/method_GPUD.dart'; // Method

class AppThemeController extends GetxController {
  // قيم افتراضية في حال فشل API
  Color _backgroundColor = const Color(0xFFFFFFFF);
  Color _textColor = const Color(0xFF000000);

  Color get backgroundColor => _backgroundColor;
  Color get textColor => _textColor;

  /// نحقن ألوان الـ API في الثيم الأساسي (العربي/الإنجليزي)
  ThemeData applyTo(ThemeData base) {
    TextStyle _withColor(TextStyle? s) =>
        (s ?? const TextStyle()).copyWith(color: _textColor);

    // نفـرض نفس لون النص على كل الستايلات
    final forcedText = base.textTheme.copyWith(
      displayLarge: _withColor(base.textTheme.displayLarge),
      displayMedium: _withColor(base.textTheme.displayMedium),
      displaySmall: _withColor(base.textTheme.displaySmall),
      headlineLarge: _withColor(base.textTheme.headlineLarge),
      headlineMedium: _withColor(base.textTheme.headlineMedium),
      headlineSmall: _withColor(base.textTheme.headlineSmall),
      titleLarge: _withColor(base.textTheme.titleLarge),
      titleMedium: _withColor(base.textTheme.titleMedium),
      titleSmall: _withColor(base.textTheme.titleSmall),
      bodyLarge: _withColor(base.textTheme.bodyLarge),
      bodyMedium: _withColor(base.textTheme.bodyMedium),
      bodySmall: _withColor(base.textTheme.bodySmall),
      labelLarge: _withColor(base.textTheme.labelLarge),
      labelMedium: _withColor(base.textTheme.labelMedium),
      labelSmall: _withColor(base.textTheme.labelSmall),
    );

    final scheme = base.colorScheme.copyWith(
      background: _backgroundColor,
      surface: _backgroundColor,
      onBackground: _textColor,
      onSurface: _textColor,
      primary: _textColor,
      onPrimary: _backgroundColor,
    );

    return base.copyWith(
      scaffoldBackgroundColor: _backgroundColor,
      canvasColor: _backgroundColor,
      colorScheme: scheme,
      textTheme: forcedText,
      primaryTextTheme: forcedText,
      iconTheme: base.iconTheme.copyWith(color: _textColor),
      appBarTheme: AppBarTheme(
        backgroundColor: _backgroundColor, // اللون من API
        foregroundColor: _textColor, // يغير لون الـ back/suffix icons
        iconTheme: IconThemeData(color: _textColor),
        titleTextStyle: TextStyle(
          color: _textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      listTileTheme: base.listTileTheme.copyWith(
        textColor: _textColor,
        iconColor: _textColor,
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        hintStyle: _withColor(base.textTheme.bodyMedium)
            .copyWith(color: _textColor.withOpacity(0.6)),
        labelStyle: _withColor(base.textTheme.bodyMedium),
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('🎨 AppThemeController.onInit()');
    fetchRemoteTheme();
  }

  Future<void> fetchRemoteTheme() async {
    debugPrint('🎨 fetching theme from: ${AppApi.getThemeColor}');
    try {
      final method = Get.find<Method>();
      final either = await method.getData(url: AppApi.getThemeColor);
      either.fold(
        (f) => debugPrint('🎨 theme fetch failed: $f'),
        (json) {
          final data = (json['data'] as Map?) ?? {};
          final bg = (data['background_color'] as String?)?.trim();
          final tx = (data['text_color'] as String?)?.trim();
          debugPrint('🎨 theme API data: bg=$bg, text=$tx');

          if (bg != null && bg.isNotEmpty) _backgroundColor = _parseHex(bg);
          if (tx != null && tx.isNotEmpty) _textColor = _parseHex(tx);
          try {
            // جسر للـ code القديم اللي بيعتمد على AppColors / المتغيّر العام
            AppColors.background = _backgroundColor;
            AppColors.textBlack = _textColor;
            AppColors.textColor = _textColor; // اختياري لو بتستخدمه كتير
            AppColors.textColorHome = _textColor; // اختياري
            fullAppBackgroundColor = _backgroundColor; // لو في أماكن لسه بتقراه
          } catch (_) {
            // تجاهل لو الملف مختلف/الأسماء مختلفة
          }
          debugPrint('🎨 applying: bg=$_backgroundColor, text=$_textColor');
          update();
        },
      );
    } catch (e) {
      debugPrint('🎨 theme error: $e');
    }
  }

  Color _parseHex(String hex) {
    var c = hex.replaceAll('#', '');
    if (c.length == 6) c = 'FF$c'; // أضف ألفا لو ناقصة
    final v = int.tryParse(c, radix: 16) ?? 0xFF000000;
    return Color(v);
  }
}
