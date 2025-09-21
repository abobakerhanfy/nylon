import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/primary_button.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
// ده بيحتوي OTPTextField و OtpFieldController
import '../../../../core/widgets/logo_widget.dart';

class VerificationCode extends StatelessWidget {
  VerificationCode({super.key});
  final ControllerLogin _controller = Get.find();
  // 👈 جديد: كونترولر لحقول الـ OTP عشان نوزّع الكود على الخانات
  final OtpFieldController otpCtrl = OtpFieldController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: LayoutBuilder(
            builder: (context, boxSize) {
              return GetBuilder<ControllerLogin>(builder: (controller) {
                return ListView(
                  children: [
                    logoWidget(),
                    SizedBox(
                      height: boxSize.maxHeight * 0.08,
                    ),
                    Text(
                      '5'.tr,
                      style: Theme.of(context).textTheme.labelLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: boxSize.maxHeight * 0.02),
                    Text(
                      '${'6'.tr} ${controller.cPhoneLogin.text}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: boxSize.maxHeight * 0.06),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: OTPTextField(
                        controller: otpCtrl, // 👈 مهم
                        outlineBorderRadius: 12,
                        length: 4,
                        width: MediaQuery.of(context).size.width * 0.85,
                        fieldWidth: 60,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        style: const TextStyle(
                          // color: ColorTheme.headerColor,
                          fontSize: 18, fontWeight: FontWeight.bold,
                        ),
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldStyle: FieldStyle.box,
                        keyboardType: TextInputType.number, // 👈 للتأكيد

                        // 👇 توزيع الكود على الخانات لو اتلصق دفعة واحدة/من SMS
                        onChanged: (text) {
                          // لو المستخدم لزّق الكود كله في أول خانة أو النظام حطّه دفعة واحدة
                          if (text.length > 1) {
                            final clean =
                                text.replaceAll(RegExp(r'[^0-9]'), '');
                            final code = clean.length > 4
                                ? clean.substring(0, 4)
                                : clean;

                            // نوزّع الأرقام على الخانات:
                            otpCtrl.set(code.split(''));

                            // لو اكتمل الطول، نفّذ التحقق مباشرة
                            if (code.length == 4) {
                              controller.inputCodeFUser = code;
                              controller.update();
                              controller.sendCodefromUserNew(code: code);
                            }
                          }

                          // دي كانت عندك، سِبتها زي ما هي
                          print(controller.cPhoneLogin.text);
                          print('$text ===========================');
                        },

                        onCompleted: (code) async {
                          controller.inputCodeFUser = code;
                          controller.update();
                          controller.sendCodefromUserNew(code: code);

                          //   _controller.inputCodeFUser=code;
                          //   _controller.update();
                          //  await _controller.sendCodefromUserNew(code: code,
                          //    onSuccess: (){
                          // ControllerHomeWidget controller_home_widget = Get.find();
                          //     Get.offAllNamed(NamePages.pBottomBar);
                          //     controller_home_widget.onTapBottomBar(2);
                          //     });
                        },
                      ),
                    ),
                    SizedBox(height: boxSize.maxHeight * 0.03),
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
                                    color: controller.startEndTime == false
                                        ? AppColors.primaryColor
                                        : Colors.black45),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     InkWell(
                    //       onTap: (){
                    //         _controller.sendCodetoUser();
                    //         //اعاده ارسال الرمز
                    //       },
                    //       child: Text('7'.tr,style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    //         color: AppColors.blyColor
                    //       ),textAlign: TextAlign.center,),
                    //     ),
                    //     Text('sss')
                    //   ],
                    // ),
                    SizedBox(height: boxSize.maxHeight * 0.04),
                    controller.statusRequestsendCodeFuser ==
                            StatusRequest.loading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : controller.statusRequestsendCodeFuser ==
                                StatusRequest.loading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              )
                            : PrimaryButton(
                                onTap: () async {
                                  controller.sendCodefromUserNew(
                                      code: controller.inputCodeFUser!);
                                  // print(_controller.inputCodeFUser);
                                  // if(_controller.inputCodeFUser!=null){
                                  //      await _controller.sendCodefromUserNew(code: _controller.inputCodeFUser!,
                                  //      onSuccess: (){
                                  //   ControllerHomeWidget controller_home_widget = Get.find();
                                  //       Get.offAllNamed(NamePages.pBottomBar);
                                  //       controller_home_widget.onTapBottomBar(2);
                                  //       });
                                  // }

                                  //     customDialog(body:'10'.tr, title: '9'.tr, dialogType: DialogType.success,context: context);
                                  //  await Future.delayed(const Duration(seconds: 2));
                                  //   Get.back();
                                  //   Get.offAllNamed(NamePages.pBottomBar);
                                },
                                label: '8'.tr)
                  ],
                );
              });
            },
          ),
        ),
      ),
    );
  }
}
