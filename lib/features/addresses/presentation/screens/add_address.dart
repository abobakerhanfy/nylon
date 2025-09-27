import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/address/fild_addess.dart';
import 'package:nylon/core/widgets/address/select_name_address.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/core/widgets/login/fild_phone.dart';
import 'package:nylon/core/widgets/primary_button.dart';
import 'package:nylon/features/addresses/presentation/controller/adreess_controller.dart';
import 'package:nylon/features/cart/presentation/screens/cart_screens/verification_user.dart';
import 'package:nylon/features/payment/presentation/controller/controller_payment.dart';

// ignore: must_be_immutable
class AddAddress extends StatelessWidget {
  AddAddress({super.key});
  var controller = TextEditingController();
  final ControllerAddress _controllerAddress = Get.put(ControllerAddress());
  final SuggestionsBoxController _suggestionsBoxController =
      SuggestionsBoxController();

  @override
  Widget build(BuildContext context) {
    // if (Get.find<ControllerPayment>().zoneId.isEmpty) {
    //   Get.find<ControllerPayment>().getZoneId();
    // }
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      bottomNavigationBar: GetBuilder<ControllerAddress>(
          init: ControllerAddress(),
          builder: (controller) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.10,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: controller.statusRequestOnTap == StatusRequest.loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  : PrimaryButton(
                      onTap: () {
                        _controllerAddress.onTapAddAddress();
                      },
                      label: '85'.tr),
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
                key: controller.formAddAddress,
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
                    // SizedBox(height: boxSize.maxHeight*0.01,),
                    //     TextFildAddess(
                    //     label: '49'.tr,
                    //      valid:(value) => value!.isEmpty ? '163'.tr : null,
                    //      textInputType:TextInputType.emailAddress,
                    //       controller:_controller.cEmail),
                    SizedBox(
                      height: boxSize.maxHeight * 0.03,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'رقم الهاتف',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: AppColors.colorLabel,
                                  fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        CustomFieldPhone(
                          controller: controller.cPhone,
                          hint: '592090000'.tr,
                          validators: validatePhone,
                        ),
                      ],
                    ),

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
                    // Row(children: [
                    //   SizedBox(
                    //     width: boxSize.maxWidth*0.45,
                    //     child: TextFildAddess(
                    //       label: '91'.tr,
                    //        valid: (value){},
                    //        textInputType:TextInputType.name,
                    //         controller: controller),
                    //   ),
                    //   SizedBox(width: boxSize.maxWidth*0.05,),
                    //   SizedBox(
                    //     width: boxSize.maxWidth*0.45,
                    //     child: TextFildAddess(
                    //       label: '92'.tr,
                    //        valid: (value){},
                    //        textInputType:TextInputType.name,
                    //         controller: controller),
                    //   ),
                    // ],),
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

class CityDropDownField extends StatelessWidget {
  final TextEditingController cityController;
  final TextEditingController zoneIdController;
  final TextEditingController countryIdController;
  final SuggestionsBoxController suggestionsBoxController;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;

  const CityDropDownField(
      {super.key,
      required this.cityController,
      required this.suggestionsBoxController,
      required this.countryIdController,
      required this.validator,
      required this.onSaved,
      required this.zoneIdController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerPayment>(
      init: ControllerPayment(),
      builder: (controller) {
        return DropDownSearchFormField(
          hideSuggestionsOnKeyboardHide: false,
          keepSuggestionsOnSuggestionSelected: true,
          textFieldConfiguration: TextFieldConfiguration(
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.black),
            controller: cityController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_drop_down),
                onPressed: () async {
                  await Future.delayed(const Duration(milliseconds: 100));
                  suggestionsBoxController.open();
                },
              ),
              labelText: 'اختر المدينة',
              labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.colorLabel,
                    fontWeight: FontWeight.normal,
                  ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryColor),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.5),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
          ),
          suggestionsCallback: (pattern) {
            final cities = controller.zoneId;

            print("Loaded cities count: ${cities.length}");
            print("City names: ${cities.map((e) => e.nameAr)}");

            return cities.isNotEmpty
                ? cities
                    .map((zone) => zone.nameAr)
                    .where((name) =>
                        name.toLowerCase().contains(pattern.toLowerCase()))
                    .toList()
                : ['لم يتم تحميل المدن بعد'];
            // return _controller.zoneId
            //     .map((zone) => zone.nameAr)
            //     .where((name) =>
            //         name.toLowerCase().contains(pattern.toLowerCase()))
            //     .toList();
          },
          itemBuilder: (context, String suggestion) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                suggestion,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black,
                      fontSize: 15,
                    ),
              ),
            );
          },
          onSuggestionSelected: (String suggestion) {
            cityController.text = suggestion;
            try {
              var city = controller.zoneId
                  .firstWhere((zone) => zone.nameAr == suggestion);

              zoneIdController.text = city.zoneId;
              countryIdController.text = city.countryId;
              cityController.text = city.nameAr;
              print(cityController.text);
              print(countryIdController.text);
              print(zoneIdController.text);
            } catch (e) {
              print('City not found');
            }
            //suggestionsBoxController.toggle();
          },
          suggestionsBoxController: suggestionsBoxController,
          suggestionsBoxDecoration: const SuggestionsBoxDecoration(
            constraints: BoxConstraints(
              maxHeight: 200, // تحديد أقصى ارتفاع للقائمة
            ),
          ),
          validator: validator,
          onSaved: onSaved,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        );
      },
    );
  }
}
