import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/url/url_api.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';

class PaymentRedirectWatcher extends StatefulWidget {
  final int orderId;

  const PaymentRedirectWatcher({super.key, required this.orderId});

  @override
  State<PaymentRedirectWatcher> createState() => _PaymentRedirectWatcherState();
}

class _PaymentRedirectWatcherState extends State<PaymentRedirectWatcher> {
  final ControllerLogin _controllerLogin = Get.find();

  @override
  void initState() {
    super.initState();
    _checkOrderStatus();
  }

  Future<void> _checkOrderStatus() async {
    final url = "${AppApi.CheckOrder}${widget.orderId}";

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['success'] == true && data['status'] == 'allowed') {
        Get.offAllNamed(NamePages.pOrderConfirmation);
        await Future.delayed(const Duration(seconds: 3));
        await _controllerLogin.resetSession();
        Get.offAllNamed(NamePages.pBottomBar);
      } else {
        Get.snackbar("فشل الدفع", "لم يتم الدفع بنجاح، يرجى المحاولة مجددًا");
        Get.offAllNamed(NamePages.pBottomBar);
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل الاتصال بالسيرفر");
      Get.offAllNamed(NamePages.pBottomBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
