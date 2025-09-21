import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nylon/core/services/services.dart'; // للوصول لـ SharedPreferences
import 'package:nylon/core/url/url_api.dart'; // فيه AppApi.baseUrl2

class CartBadgeController extends GetxController {
  final RxInt totalItems = 0.obs; // مجموع الكميات
  final RxInt totalLines = 0.obs; // عدد الأسطر (distinct products)

  static const String _path = '/cart/products&api_token=';

  @override
  Future<void> refresh() async {
    try {
      final sp = Get.find<MyServices>().sharedPreferences;
      final token = sp.getString('token') ?? '';
      if (token.isEmpty) {
        totalItems.value = 0;
        totalLines.value = 0;
        return;
      }

      final url = Uri.parse('${AppApi.baseUrl2}$_path$token');
      final res = await http.get(url);
      if (res.statusCode != 200) {
        totalItems.value = 0;
        totalLines.value = 0;
        return;
      }

      final data = jsonDecode(res.body);
      final List products = (data['products'] as List?) ?? [];

      // عدد الأسطر
      totalLines.value = products.length;

      // مجموع الكميات
      int sumQty = 0;
      for (final p in products) {
        sumQty += int.tryParse('${p['quantity'] ?? '0'}') ?? 0;
      }
      totalItems.value = sumQty;
    } catch (_) {
      totalItems.value = 0;
      totalLines.value = 0;
    }
  }

  @override
  void onInit() {
    super.onInit();
    refresh();
  }
}
