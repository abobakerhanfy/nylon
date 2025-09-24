import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/languages/controllerLocale.dart';
import 'package:nylon/core/languages/locale.dart';
import 'package:nylon/core/routes/pages.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';
import 'package:nylon/features/orders/data/data_sources/orders_data_source.dart';
import 'package:nylon/features/orders/presentation/controller/controller_order.dart';
import 'package:nylon/features/fortune_wheel/presentation/controller/controller_fortune.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';
// لا تستورد ControllerPayment هنا - سيتم تحميله عند الحاجة فقط
import 'package:nylon/features/cart/presentation/controller/cart_badge_controller.dart';
import 'package:nylon/core/bindings/app_bindings.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/services/auth_service.dart'; // ✅ جديد
import 'package:get_storage/get_storage.dart'; // ✅ جديد
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1) نظام + Firebase
    await _setupSystemConfiguration();
    await _initializeFirebase();

    // 2) MyServices (SharedPreferences) - ده الأهم يكون الأول
    await _initializeServices();

    // 3) GetStorage (auth)
    await GetStorage.init('auth');

    // 4) سجّل Method أولاً
    if (!Get.isRegistered<Method>()) {
      Get.put(Method(), permanent: true);
    }

    // 5) بقية الـ DataSources
    if (!Get.isRegistered<OrdersDataSourceImpl>()) {
      Get.put(OrdersDataSourceImpl(Get.find<Method>()), permanent: true);
    }

    // 6) الكنترولرز - بعد MyServices
    if (!Get.isRegistered<ControllerLogin>()) {
      Get.put(ControllerLogin(), permanent: true); // ← دلوقتي MyServices موجود
    }

    if (!Get.isRegistered<ControllerCart>()) {
      Get.put(ControllerCart(), permanent: true);
    }

    // 7) AuthService (اختياري)
    if (!Get.isRegistered<AuthService>()) {
      await Get.putAsync<AuthService>(() async => await AuthService().init(),
          permanent: true);
    }
    if (kReleaseMode) {
      debugPrint = (String? message, {int? wrapWidth}) {};
    }
    // 8) تسجيل Controllers الأساسية
    await _registerCoreControllers();

    // 9) أخيراً شغّل التطبيق مرة واحدة بس
    runApp(MyApp());
  } catch (e) {
    debugPrint('❌ خطأ في تهيئة التطبيق: $e');
    runApp(_ErrorApp(error: e.toString()));
  }
}

// تحسين إعدادات النظام
Future<void> _setupSystemConfiguration() async {
  // إعداد اتجاه الشاشة
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // إعداد WebView للأندرويد
  if (Platform.isAndroid) {
    // WebView.platform = SurfaceAndroidWebView();
  }
}

// تهيئة Firebase
Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase تم تهيئته بنجاح!");
  } catch (e) {
    print("خطأ في Firebase: $e");
  }
  debugPrint('✅ Firebase تم تهيئته بنجاح');
}

// تهيئة الخدمات الأساسية
Future<void> _initializeServices() async {
  await Get.putAsync(() => MyServices().initShared(), permanent: true);
  debugPrint('✅ الخدمات الأساسية تم تهيئتها');
}

// تسجيل Controllers الأساسية فقط
Future<void> _registerCoreControllers() async {
  try {
    // الخدمات الأساسية
    Get.put(Method(), permanent: true);

    // Controller تسجيل الدخول (مطلوب للتوكن)
    final loginController = Get.put(ControllerLogin(), permanent: true);

    if (!Get.isRegistered<CartBadgeController>()) {
      Get.put(CartBadgeController(), permanent: true);
    }
    await Get.find<CartBadgeController>().refresh();
    // مصدر بيانات الطلبات
    Get.put(OrdersDataSourceImpl(Get.find<Method>()), permanent: true);

    // Controllers المستخدمة في أكتر من مكان - lazyPut للتحسين
    Get.lazyPut(() => ControllerCart(), fenix: true);
    Get.lazyPut(() => ControllerOrder(), fenix: true);
    Get.lazyPut(() => ControllerFortune(), fenix: true);

    // التحقق من customer_id
    await _validateCustomerSession();

    // تشغيل عجلة الحظ للیوم
    await _initializeDailyFortune();

    debugPrint('✅ Controllers الأساسية تم تسجيلها');
  } catch (e) {
    debugPrint('❌ خطأ في تسجيل Controllers: $e');
    rethrow;
  }
}

// التحقق من جلسة العميل
Future<void> _validateCustomerSession() async {
  try {
    final shared = Get.find<MyServices>().sharedPreferences;
    final customerId = shared.getString("customer_id");

    if (customerId == null || customerId.isEmpty) {
      // تأجيل تحميل ControllerCart حتى الحاجة إليه
      Get.lazyPut(() => ControllerCart());
      // تعيين الفهرس بعد التحميل
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.isRegistered<ControllerCart>()) {
          Get.find<ControllerCart>().indexScreensCart = 1;
        }
      });
      debugPrint('⚠️ العميل غير مسجل - سيتم توجيهه لشاشة التحقق');
    } else {
      debugPrint('✅ العميل مسجل: $customerId');
    }
  } catch (e) {
    debugPrint('❌ خطأ في التحقق من جلسة العميل: $e');
  }
}

// تهيئة عجلة الحظ اليومية
Future<void> _initializeDailyFortune() async {
  try {
    // استخدام lazyPut ثم تحميل عند الحاجة
    if (Get.isRegistered<ControllerFortune>()) {
      await Get.find<ControllerFortune>().checkAndRunForToday();
      debugPrint('✅ عجلة الحظ تم تهيئتها');
    }
  } catch (e) {
    debugPrint('❌ خطأ في تهيئة عجلة الحظ: $e');
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // استخدام lazy loading للـ locale controller
  final ControllerLocal controllerLocal =
      Get.put(ControllerLocal(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: NamePages.pSplashGate,

      routingCallback: (routing) {
        if (routing == null) return;
        debugPrint(
            '🚦 ROUTE: ${routing.previous} -> ${routing.current}, args=${routing.args}');
      },
      debugShowCheckedModeBanner: false,
      title: 'Nylon',
      translations: MyLocale(),
      locale: controllerLocal.languages,
      theme: controllerLocal.abbThem,
      getPages: routes,
      initialBinding: AppBindings(), // ✅

      // إضافة معالجة الأخطاء العامة
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => const NotFoundPage(),
      ),

      // تحسين الأداء
      defaultTransition: Transition.native,
      transitionDuration: const Duration(milliseconds: 300),

      // تحسين إدارة الذاكرة
      smartManagement: SmartManagement.keepFactory,
    );
  }
}

// صفحة خطأ في حالة فشل التهيئة
class _ErrorApp extends StatelessWidget {
  final String error;

  const _ErrorApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'حدث خطأ في تهيئة التطبيق',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // إعادة تشغيل التطبيق
                  SystemNavigator.pop();
                },
                child: const Text('إغلاق التطبيق'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// صفحة عدم العثور على الصفحة
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('صفحة غير موجودة'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'الصفحة المطلوبة غير موجودة',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
