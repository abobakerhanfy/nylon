import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/login/fild_phone.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/button_on_cart.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';
import 'package:nylon/features/payment/presentation/controller/controller_payment.dart';
import 'package:otp_text_field/style.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';

// ignore: use_key_in_widget_constructors
class VerificationUserCart extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _VerificationUserCartState createState() => _VerificationUserCartState();
}

class _VerificationUserCartState extends State<VerificationUserCart> {
  var x = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // ✅ متين: لو متسجل نلاقيه، لو مش متسجل نسجله مرة
  final ControllerLogin _login = Get.isRegistered<ControllerLogin>()
      ? Get.find<ControllerLogin>()
      : Get.put(ControllerLogin(), permanent: true);

  final ControllerCart _controllerCart = Get.isRegistered<ControllerCart>()
      ? Get.find<ControllerCart>()
      : Get.put(ControllerCart(), permanent: true);

  // لو مش عايز تفتح الدفع إلا وقت الحاجة، سيبها زي ما هي. وإلا:
// خليها كده لو مش محتاجه فورًا:
  ControllerPayment get _controllerPayment =>
      Get.isRegistered<ControllerPayment>()
          ? Get.find<ControllerPayment>()
          : Get.put(ControllerPayment());
  bool _appliedOnce = false; // ✅ تمنع تكرار التحويل للحالة المتحققة

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _applyVerifiedStateIfAny());
  }

  void _applyVerifiedStateIfAny() {
    if (_appliedOnce) return;

    // تحقق من customer_id و session معاً
    if (_login.hasCartSession) {
      final customerId =
          _login.myServices.sharedPreferences.getString('UserId'); // ← غير هنا

      if (customerId?.isNotEmpty == true) {
        // كل حاجة تمام - المستخدم مسجل ومتحقق
        _login.isSendC = true;
        _login.statusRequestSPhoneC = StatusRequest.empty;

        final saved = _login.savedPhoneOnCart;
        if (saved?.isNotEmpty == true) {
          _login.cPhoneOnCart.text = saved!;
        }

        _login.showOtp.value = false;
        _login.otp1.clear();
        _login.otp2.clear();
        _login.otp3.clear();
        _login.otp4.clear();
        _login.update();

        print('✅ المستخدم مسجل ومتحقق - يمكنه المتابعة');
      }
    } else {
      // مفيش session صالحة - يحتاج تسجيل
      print('❌ يتطلب تسجيل دخل جديد');
    }

    _appliedOnce = true;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(17),
        child: Center(
          child: GetBuilder<ControllerLogin>(builder: (controller) {
            return controller.isSendC == true
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 140),
                        Text('send_transfer_image'.tr),
                        const SizedBox(height: 40),
                        ButtonOnCart(
                          width: MediaQuery.of(context).size.width * 0.80,
                          label: 'continue'.tr,
                          onTap: () {
                            _controllerCart.plusIndexScreensCart();
                          },
                        ),
                      ],
                    ),
                  )
                : Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'vericfy_page_text'.tr,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                        ),
                        const SizedBox(height: 50),
                        CustomFieldPhone(
                          controller: controller.cPhoneOnCart,
                          hint: '592090000',
                          validators: validatePhone,
                        ),
                        if (controller.statusRequestSPhoneC ==
                            StatusRequest.success) ...{
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  controller.startEndTime == true
                                      ? Text(
                                          '00:${controller.xx} ',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black),
                                        )
                                      : const Text(
                                          '00:00 ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black),
                                        ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (controller.startEndTime == false) {
                                        controller.sendPhoneOnCart();
                                        // _controller.sendCodetoUser();
                                      } else {
                                        print('الوقت شغال');
                                      }
                                    },
                                    child: Text(
                                      '7'.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: controller.startEndTime ==
                                                      false
                                                  ? AppColors.primaryColor
                                                  : Colors.black45),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Text(
                                'code_active'.tr,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 15),
                              Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _otpBox(
                                          controller: controller.otp1,
                                          focus: controller.f1,
                                          next: controller.f2),
                                      const SizedBox(width: 8),
                                      _otpBox(
                                          controller: controller.otp2,
                                          focus: controller.f2,
                                          next: controller.f3,
                                          prev: controller.f1),
                                      const SizedBox(width: 8),
                                      _otpBox(
                                          controller: controller.otp3,
                                          focus: controller.f3,
                                          next: controller.f4,
                                          prev: controller.f2),
                                      const SizedBox(width: 8),
                                      _otpBox(
                                        controller: controller.otp4,
                                        focus: controller.f4,
                                        prev: controller.f3,
                                        onFilled: () {
                                          if (controller.otpCode.length == 4) {
                                            controller.sendCodefromUserOnCart(
                                                code: controller.otpCode);
                                          }
                                        },
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        },
                        const SizedBox(height: 30),
                        if (controller.statusRequestSPhoneC !=
                            StatusRequest.success) ...{
                          controller.statusRequestSPhoneC ==
                                  StatusRequest.loading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              : ButtonOnCart(
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                  label: 'confirm_text'.tr,
                                  onTap: () {
                                    controller.sendPhoneOnCart();
                                    //  ControllerCart _controllerCart = Get.find();
                                    //   _controllerCart.plusIndexScreensCart();
                                  }),
                        },
                        if (controller.statusRequestSPhoneC ==
                            StatusRequest.success) ...{
                          controller.statusRequestSendCodeOnCart ==
                                  StatusRequest.loading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              : ButtonOnCart(
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                  label: '54'.tr,
                                  onTap: () {
                                    if (_formKey.currentState?.validate() ==
                                        true) {
                                      controller.sendPhoneOnCart();
                                    } else {
                                      Get.snackbar(
                                        "error".tr,
                                        "error_number".tr,
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: AppColors.primaryColor,
                                        colorText: Colors.white,
                                      );
                                    }
                                  }),
                        },
                        const SizedBox(height: 30),
                      ],
                    ),
                  );
          }),
        ),
      ),
    );
  }
}

Widget _otpBox({
  required TextEditingController controller,
  required FocusNode focus,
  FocusNode? next,
  FocusNode? prev,
  VoidCallback? onFilled,
}) {
  return SizedBox(
    width: 60,
    child: TextField(
      controller: controller,
      focusNode: focus,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: 1,
      decoration: const InputDecoration(counterText: ''),
      onChanged: (v) {
        if (v.isNotEmpty) {
          // خليه حرف واحد
          if (v.length > 1) {
            controller.text = v.characters.last;
            controller.selection = const TextSelection.collapsed(offset: 1);
          }
          if (next != null) next.requestFocus();
          onFilled?.call();
        } else {
          if (prev != null) prev.requestFocus();
        }
      },
    ),
  );
}

String? validatePhone(PhoneNumber? phone) {
  print(phone?.completeNumber); // فحص إذا كانت القيمة موجودة
  if (phone == null || phone.number.isEmpty) {
    return '163'.tr; // رسالة الخطأ عند ترك الحقل فارغاً
  }

  // التحقق من النمط
  String pattern = r'^(?:\+9665\d{8}|05\d{8})$';
  RegExp regex = RegExp(pattern);

  if (!regex.hasMatch(phone.completeNumber)) {
    return '172'.tr; // رسالة الخطأ عند وجود مدخل غير مطابق للرقم السعودي
  }

  return null; // المدخل صحيح
}
