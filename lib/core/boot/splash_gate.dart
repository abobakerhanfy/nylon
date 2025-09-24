import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/services/auth_service.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';

class SplashGate extends StatefulWidget {
  const SplashGate({super.key});
  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _boot());
  }

  Future<void> _boot() async {
    final auth = Get.find<AuthService>();

// لو لسه بيحمّل من التخزين انتظر
    while (!auth.ready) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }

// (اختياري) مزامنة سريعة للسلة قبل الدخول
    try {
      await Get.find<ControllerCart>().getCart();
    } catch (_) {}

    if (auth.isLoggedIn) {
      Get.offAllNamed(
          NamePages.pBottomBar); // أو pCart لو عايز تفتح السلة مباشرة
    } else {
      Get.offAllNamed(NamePages.pFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
