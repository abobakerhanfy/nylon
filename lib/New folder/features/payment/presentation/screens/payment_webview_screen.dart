import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/features/cart/presentation/screens/cart_screens/order_successfully.dart';
import 'package:nylon/features/orders/presentation/controller/controller_order.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String url;
  final String successKeyword;
  final String failKeyword;
  final String orderId; // ✅ هذا مهم

  const PaymentWebViewScreen({
    super.key,
    required this.url,
    required this.orderId,
    this.successKeyword = "success",
    this.failKeyword = "failure",
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController controller;
  final MyServices myServices = Get.find();
  final ControllerOrder controllerOrder = Get.put(ControllerOrder());

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            print("📍 Navigating to: $url");

            if (url.startsWith("myapp://order_success")) {
              controllerOrder.orderIdSuccess = widget.orderId;

              // بدل await
              Future.microtask(() {
                Get.offAll(() => const OrderSuccessfully());
              });

              return NavigationDecision.prevent;
            }

            if (url.contains(widget.successKeyword)) {
              Future.microtask(() async {
                await myServices.sharedPreferences.remove("order_id");
                await myServices.sharedPreferences.remove("order_status");

                controllerOrder.orderIdSuccess = widget.orderId;

                await Get.offAll(() => const OrderSuccessfully());
              });

              return NavigationDecision.prevent;
            } else if (url.contains(widget.failKeyword)) {
              Future.microtask(() {
                Get.back();
                Get.snackbar("فشل الدفع", "تم إلغاء أو فشل عملية الدفع");
              });

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) async {
            print("✅ Page finished loading: $url");

            if (url.contains('/checkout/success')) {
              controllerOrder.orderIdSuccess = widget.orderId;
              await Get.offAll(() => const OrderSuccessfully());
            }
          },
          onWebResourceError: (error) {
            print("❌ WebView error: ${error.errorCode} - ${error.description}");
            Get.snackbar("خطأ في الاتصال", error.description);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('  الدفع ')),
      body: WebViewWidget(controller: controller),
    );
  }
}
