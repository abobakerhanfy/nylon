import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/routes/name_pages.dart';

class OneCategoryGuard extends GetMiddleware {
  // يتنفّذ قبل إنشاء الصفحة
  @override
  RouteSettings? redirect(String? route) {
    final args = Get.arguments;
    final params = Get.parameters;

    String? id;
    if (args is Map) {
      id = (args['categoryId'] ??
              args['idCategory'] ??
              args['category_id'] ??
              args['id'])
          ?.toString();
    } else {
      id = (params['categoryId'] ?? params['category_id'] ?? params['id']);
    }

    if ((id ?? '').isEmpty) {
      // اطبع تتبّع واضح في اللوج عشان نعرف مين اللي نادى الراوت غلط
      debugPrint(
        '[OneCategoryGuard] Blocked navigation to $route without categoryId.\n'
        '  - Get.arguments: $args\n'
        '  - Get.parameters: $params\n'
        '  - Previous route: ${Get.previousRoute}',
      );

      // ارجع للـ BottomBar (أو أي شاشة مناسبة عندك)
      return const RouteSettings(name: NamePages.pBottomBar);
    }

    // اقبل التنقّل
    return null;
  }
}
