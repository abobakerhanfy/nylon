import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/login/fild_phone.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/button_on_cart.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';
import 'package:nylon/features/payment/presentation/controller/controller_payment.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../../controller/controller_cart.dart';

// ignore: use_key_in_widget_constructors
class VerificationUserCart extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _VerificationUserCartState createState() => _VerificationUserCartState();
}

class _VerificationUserCartState extends State<VerificationUserCart> {
  var x = TextEditingController();
  final ControllerCart _controllerCart = Get.put(ControllerCart());
  final ControllerPayment _controllerPayment = Get.put(ControllerPayment());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(17),
        child: Center(
          child: GetBuilder<ControllerLogin>(
              init: ControllerLogin(),
              builder: (controller) {
                return controller.isSendC == true
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 140),
                            const Text(
                                "تم التحقق سابقا من رقم هاتفك \n يمكنك الان المتابعة لاتمام الطلب"),
                            const SizedBox(height: 40),
                            ButtonOnCart(
                              width: MediaQuery.of(context).size.width * 0.80,
                              label: 'متابعة',
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
                              'يرجى إدخال رقم هاتفك لتأكيد الطلب وإتمام عملية الشراء. '
                              'إذا كنت مسجلاً من قبل، سنعرض بياناتك تلقائيًا. '
                              ' وإذا لم يكن لديك حساب، يمكنك إنشاء حساب جديد، واضافة عنوان',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                            ),
                            const SizedBox(height: 50),
                            CustomFieldPhone(
                              controller: controller.cPhoneOnCart,
                              hint: '09209',
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
                                          if (controller.startEndTime ==
                                              false) {
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
                                                  color: controller
                                                              .startEndTime ==
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
                                    "برجاء ادخال رمز التحقق ",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 15),
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: OTPTextField(
                                      outlineBorderRadius: 12,
                                      length: 4,
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      fieldWidth: 60,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 12),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textFieldAlignment:
                                          MainAxisAlignment.spaceAround,
                                      fieldStyle: FieldStyle.box,
                                      onCompleted: (code) async {
                                        controller.inputCodeCart = code;
                                        controller.update();
                                        controller.sendCodefromUserOnCart(
                                            code: code);

                                        //  _controller.sendCodefromUserNew(code:_controller.inputCodeFUser!,
                                        //   // onSuccess: (){
                                        //   //   ControllerCart _controllerCart = Get.find();
                                        //   //   _controllerCart.plusIndexScreensCart();
                                        //   // }
                                        //   );
                                      },
                                      onChanged: (text) {
                                        print(
                                            '$text ===========================');
                                      },
                                    ),
                                  ),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.80,
                                      label: 'تأكيد',
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
                                      width: MediaQuery.of(context).size.width *
                                          0.80,
                                      label: 'الخطوه التالي ',
                                      onTap: () {
                                        controller.sendCodefromUserOnCart(
                                            code: controller.inputCodeCart!);
                                        //  ControllerCart _controllerCart = Get.find();
                                        // _controllerCart.plusIndexScreensCart();
                                        // if(_controller.inputCodeFUser!.isNotEmpty&&_controller.inputCodeFUser!=null) {
                                        //   _controller.sendCodefromUserNew(code:_controller.inputCodeFUser!,
                                        // onSuccess: (){
                                        //6518

                                        // });
                                        // }
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

String? validatePhone(PhoneNumber? phone) {
  print(phone?.completeNumber); // فحص إذا كانت القيمة موجودة
  if (phone == null || phone.number.isEmpty) {
    return '163'.tr; // رسالة الخطأ عند ترك الحقل فارغاً
  }

  // التحقق من النمط
  String pattern = r'^(?:\+966|05)[0-9]{8}$';
  RegExp regex = RegExp(pattern);

  if (!regex.hasMatch(phone.completeNumber)) {
    return '172'.tr; // رسالة الخطأ عند وجود مدخل غير مطابق للرقم السعودي
  }

  return null; // المدخل صحيح
}
    
                  //    Row(
                  //   children: [
                  //     Transform.scale(
                  //       scale: 0.8, 
                  //       child: Radio<String>(
                  //         value: 'new',
                  //         groupValue:_controller.selectedUserTypeOnCart,
                  //         onChanged: (value) {
                  //           _controller.userTypeOnCart(value: value!);
                  //         },
                  //       ),
                  //     ),
                  //     const SizedBox(width: 8), // إضافة مسافة صغيرة بين الراديو والنص
                  //     const Text(
                  //       'مستخدم جديد',
                  //       style: TextStyle(fontSize: 12), // تصغير حجم النص
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     Transform.scale(
                  //       scale: 0.8, // تصغير حجم الدائرة
                  //       child: Radio<String>(
                  //         value: 'existing',
                  //         groupValue: _controller.selectedUserTypeOnCart,
                  //         onChanged: (value) {
                  //        _controller.userTypeOnCart(value: value!);
                  //         },
                  //       ),
                  //     ),
                  //     const SizedBox(width: 8), // إضافة مسافة صغيرة بين الراديو والنص
                  //     const Text(
                  //       'مستخدم مسجل من قبل',
                  //       style: TextStyle(fontSize: 12), // تصغير حجم النص
                  //     ),
                  //   ],
                  // ),
                  //onTap ====================
                    //     if (_formKey.currentState!.validate() &&_controller.controllerPhone.text!=null&&_controller.controllerPhone.text.isNotEmpty) {
                      //  _controller.getCustomerByphone(phone: _controller.controllerPhone.text).then((v){
                      //   if(_controller.statusRequestgetUserBP==StatusRequest.success){
                      //     _controllerCart.plusIndexScreensCart();
                      //   }
                      //  });
                      //  }else{
                      //   print('sss');
                      //  }
                          //  _controllerPayment.getPayment().then((c){
                          //    _controllerCart.plusIndexScreensCart();
                          //  });
                         
                         
                    //  if (_controller.selectedUserTypeOnCart == null) {
                    //   showSnackBar( 'خطأ \n يجب عليك اختيار نوع المستخدم ',);
                    // }else{
                    
                    // };