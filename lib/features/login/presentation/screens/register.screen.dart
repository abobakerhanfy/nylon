import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/address/fild_addess.dart';
import 'package:nylon/core/widgets/address/select_name_address.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/core/widgets/primary_button.dart';
import 'package:nylon/features/addresses/presentation/screens/add_address.dart';
import 'package:nylon/features/cart/presentation/screens/cart_screens/verification_user.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final SuggestionsBoxController _suggestionsBoxController =
      SuggestionsBoxController();
  var x = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      bottomNavigationBar: GetBuilder<ControllerLogin>(builder: (controller) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.10,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: controller.statusRequestAddCustomer == StatusRequest.loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : PrimaryButton(
                  onTap: () {
                    controller.addCustomer(onSuccess: () {
                      // _controller.sendCodetoUser().then((_){
                      // Get.toNamed(NamePages.pVerifyCode);
                      // });
                    });
                  },
                  label: 'تسجيل '),
        );
      }),
      appBar: customAppBarTow(title: '85'.tr),
      body: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: LayoutBuilder(
          builder: (context, boxSize) {
            return GetBuilder<ControllerLogin>(
                init: ControllerLogin(),
                builder: (controller) {
                  return Form(
                    key: controller.formRegister,
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
                                  valid: (value) =>
                                      value!.isEmpty ? '163'.tr : null,
                                  textInputType: TextInputType.name,
                                  controller: controller.cLastName),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: boxSize.maxHeight * 0.01,
                        ),
                        CustomFieldPhone(
                          controller: controller.controllerPhone,
                          hint: '592090000'.tr,
                          validators: validatePhone,
                        ),
                        SizedBox(
                          height: boxSize.maxHeight * 0.01,
                        ),
                        TextFildAddess(
                            label: '49'.tr,
                            valid: (value) => value!.isEmpty ? '163'.tr : null,
                            textInputType: TextInputType.emailAddress,
                            controller: controller.cEmail),
                        SizedBox(
                          height: boxSize.maxHeight * 0.03,
                        ),
                        Text(
                          '89'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.black),
                        ),
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
                          height: boxSize.maxHeight * 0.03,
                        ),
                        Text(
                          '93'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: AppColors.colorLabel,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                        ),
                        SizedBox(
                          height: boxSize.maxHeight * 0.04,
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
                          height: boxSize.maxHeight * 0.04,
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

class CustomFieldPhone extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(PhoneNumber?)? validators;
  final String hint;
  String? fullPhone;

  CustomFieldPhone(
      {super.key,
      required this.controller,
      this.validators,
      required this.hint});

  final MyServices _myServices = Get.find();

  // تعريف كائن السعودية
  Country saudiArabia = const Country(
    name: "Saudi Arabia",
    nameTranslations: {
      "ar": "المملكة العربية السعودية",
      "en": "Saudi Arabia",
    },
    flag: "🇸🇦",
    code: "SA",
    dialCode: "966",
    minLength: 9,
    maxLength: 9,
  );

  @override
  Widget build(BuildContext context) {
    const initialCountryCode = 'SA';
    var country =
        countries.firstWhere((element) => element.code == initialCountryCode);
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.black,
          fontSize: 16, // هنا تم توحيد الحجم ليكون 16
          fontWeight: FontWeight.w900,
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          '2'.tr,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.colorLabel, fontWeight: FontWeight.normal),
        ),
        Directionality(
          textDirection: TextDirection.ltr, // التحكم باتجاه النص
          child: IntlPhoneField(
            invalidNumberMessage: '172'.tr,
            dropdownTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textBlack,
                fontSize: 16,
                fontWeight: FontWeight.w900),
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textBlack,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
            pickerDialogStyle: PickerDialogStyle(
              countryNameStyle: Theme.of(context).textTheme.bodySmall,
              // نمط اسم الدولة في قائمة الاختيار
            ),
            decoration: InputDecoration(
              counterText: '',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: AppColors.primaryColor), // لون الحدود عند التركيز
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey,
                    width: 0.5), // لون الحدود عند عدم التركيز
              ),

              // النص التوضيحي للحقل
              hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontSize: 16, // توحيد حجم النص للنص التوضيحي
                  ),

              labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.colorLabel,
                    fontSize: 16, // توحيد حجم النص للعنوان
                    fontWeight: FontWeight.normal,
                  ),
            ),
            validator: (PhoneNumber? phone) {
              return validators!(phone);
            },
            languageCode: '${_myServices.sharedPreferences.getString('Lang')}',
            initialCountryCode: 'SA', // تحديد السعودية كالدولة الافتراضية
            showDropdownIcon: false, // إخفاء أيقونة اختيار الدولة
            countries: [saudiArabia],
            onChanged: (phone) {
              if (phone.number.length >= country.minLength &&
                  phone.number.length <= country.maxLength) {
                String phoneNumberWithoutPlus =
                    phone.completeNumber.replaceFirst('+', '');
                controller.text = phoneNumberWithoutPlus;
              }
            },
            onCountryChanged: (saudiArabia) {},
          ),
        ),
      ],
    );
  }
}
