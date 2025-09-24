import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/login/fild_phone.dart';
import 'package:nylon/core/widgets/logo_widget.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';

import '../../../../core/widgets/primary_button.dart';

// ignore: must_be_immutable
class SignIn extends StatelessWidget {
  SignIn({super.key});
  var x = TextEditingController();
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
                return ListView(
                  children: [
                    logoWidget(),
                    SizedBox(
                      height: boxSize.maxHeight * 0.02,
                    ),
                    Text(
                      '1'.tr,
                      style: Theme.of(context).textTheme.labelLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: boxSize.maxHeight * 0.15,
                    ),
                    GetBuilder<ControllerLogin>(
                        init: ControllerLogin(),
                        builder: (controller) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('2'.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ],
                              ),
                              SizedBox(
                                height: boxSize.maxHeight * 0.02,
                              ),
                              CustomFieldPhone(
                                validators: (value) => null,
                                controller: controller.cPhoneLogin,
                                hint: '592090000',
                              ),
                              SizedBox(
                                height: boxSize.maxHeight * 0.03,
                              ),
                              controller.statusRequestsendCode ==
                                      StatusRequest.loading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primaryColor,
                                      ),
                                    )
                                  : PrimaryButton(
                                      onTap: () async {
                                        if (controller
                                            .cPhoneLogin.text.isNotEmpty) {
                                          await controller.sendCodetoUser();
                                        } else {
                                          print('phone null');
                                        }
                                      },
                                      label: '3'.tr,
                                    ),
                              // SizedBox(height: boxSize.maxHeight*0.08,),
                              // InkWell(
                              //   onTap: (){
                              //   //  Get.offAllNamed(NamePages.pBottomBar);
                              //   },
                              //   child:  Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         Text('لا امتلك حساب ؟ '.tr,style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              //           color: AppColors.textBorderColor,fontWeight: FontWeight.bold
                              //         ),textAlign: TextAlign.center,),
                              //         Text(' تسجيل '.tr,style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              //           color: AppColors.primaryColor,fontWeight: FontWeight.bold
                              //         ),textAlign: TextAlign.center,),
                              //       ],
                              //     ),
                              //)
                            ],
                          );
                        })
                  ],
                );
              },
            ),
          ),
        ));
  }
}
