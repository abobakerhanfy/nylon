// ignore_for_file: must_be_immutable

import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/address/fild_addess.dart';
import 'package:nylon/core/widgets/address/select_name_address.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/core/widgets/primary_button.dart';
import 'package:nylon/features/addresses/presentation/controller/adreess_controller.dart';
import 'package:nylon/features/addresses/presentation/screens/add_address.dart';

class UpdataAddress extends StatelessWidget {
  UpdataAddress({super.key});
  final ControllerAddress _controllerAddress = Get.find();
  final SuggestionsBoxController _suggestionsBoxController =
      SuggestionsBoxController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: GetBuilder<ControllerAddress>(
          init: ControllerAddress(),
          builder: (controller) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.10,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: controller.statusRequestUpdata == StatusRequest.loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  : PrimaryButton(
                      onTap: () {
                        controller.updataAddress();
                      },
                      label: 'حفظ التعديلات'.tr),
            );
          }),
      appBar: customAppBarTow(title: '85'.tr),
      body: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: LayoutBuilder(
          builder: (context, boxSize) {
            return GetBuilder<ControllerAddress>(builder: (controller) {
              return Form(
                key: controller.formUpdataAddress,
                child: ListView(
                  children: [
                    SizedBox(
                      height: boxSize.maxHeight * 0.01,
                    ),
                    Text('86'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.black)),
                    SizedBox(
                      height: boxSize.maxHeight * 0.01,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: boxSize.maxWidth * 0.45,
                          child: TextFildAddess(
                              label: '87'.tr,
                              valid: (value) =>
                                  value!.isEmpty ? '163'.tr : null,
                              textInputType: TextInputType.name,
                              controller: controller.cFirstName),
                        ),
                        SizedBox(
                          width: boxSize.maxWidth * 0.05,
                        ),
                        SizedBox(
                          width: boxSize.maxWidth * 0.45,
                          child: TextFildAddess(
                              label: '88'.tr,
                              valid: (value) => null,
                              textInputType: TextInputType.name,
                              controller: controller.cLastName),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: boxSize.maxHeight * 0.03,
                    ),
                    // TextFildAddess(
                    // label: '49'.tr,
                    //  valid:(value) => value!.isEmpty ? '163'.tr : null,
                    //  textInputType:TextInputType.emailAddress,
                    //   controller:_controller.cEmail),
                    //   SizedBox(height: boxSize.maxHeight*0.03,),
                    //  Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //    children: [
                    //     Text('رقم الهاتف',style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    //           color: AppColors.colorLabel,fontWeight: FontWeight.normal
                    //      ),),
                    //      const SizedBox(height: 6,),
                    //      CustomFieldPhone(
                    //               controller:_controller.cPhone,
                    //               hint: '7878'.tr,
                    //               validators:validatePhone,
                    //             ),
                    //    ],
                    //  ),
                    // TextFildAddess(
                    //     label: '2'.tr,
                    //      valid: (value)=>null,
                    //      textInputType:TextInputType.phone,
                    //       controller: _controller.cPhone),
                    //       SizedBox(height: boxSize.maxHeight*0.03,),
                    Text('89'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.black)),
                    SizedBox(
                      height: boxSize.maxHeight * 0.01,
                    ),
                    TextFildAddess(
                        label: '90'.tr,
                        valid: (value) => value!.isEmpty ? '163'.tr : null,
                        textInputType: TextInputType.text,
                        controller: controller.cAddress),
                    SizedBox(
                      height: boxSize.maxHeight * 0.02,
                    ),
                    CityDropDownField(
                      countryIdController: controller.cCountryId,
                      cityController: controller.cCitys,
                      zoneIdController: controller.cZoneId,
                      suggestionsBoxController: _suggestionsBoxController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '163'.tr;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        print('تم حفظ المدينة: $value');
                      },
                    ),

                    SizedBox(
                      height: boxSize.maxHeight * 0.04,
                    ),
                    Text('93'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.black)),
                    SizedBox(
                      height: boxSize.maxHeight * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SelectNameAddressContainer(
                          label: '94'.tr,
                          onTap: () {
                            controller.selectCompany('94'.tr);
                          },
                          index: 1,
                        ),
                        SelectNameAddressContainer(
                          label: '95'.tr,
                          onTap: () {
                            controller.selectCompany('95'.tr);
                          },
                          index: 1,
                        ),
                        SelectNameAddressContainer(
                          label: '96'.tr,
                          onTap: () {
                            controller.selectCompany('96'.tr);
                          },
                          index: 1,
                        )
                      ],
                    ),
                    SizedBox(
                      height: boxSize.maxHeight * 0.02,
                    ),
                    TextFildAddess(
                        label: '97'.tr,
                        valid: (value) {
                          if (value!.isEmpty) {
                            return '163'.tr;
                          } else {
                            return null;
                          }
                        },
                        textInputType: TextInputType.text,
                        controller: controller.cCompany),
                  ],
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
