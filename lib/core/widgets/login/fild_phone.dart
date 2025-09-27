import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/theme/colors_app.dart';

// ignore: must_be_immutable
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
      "sk": "Saudská Arábia",
      "se": "Saudi-Arabia",
      "pl": "Arabia Saudyjska",
      "no": "Saudi-Arabia",
      "ja": "サウジアラビア",
      "it": "Arabia Saudita",
      "zh": "沙特阿拉伯",
      "nl": "Saoedi-Arabië",
      "de": "Saudi-Arabien",
      "fr": "Arabie saoudite",
      "es": "Arabia Saudita",
      "en": "Saudi Arabia",
      "pt_BR": "Arábia Saudita",
      "sr-Cyrl": "Саудијска Арабија",
      "sr-Latn": "Saudijska Arabija",
      "zh_TW": "沙烏地阿拉伯",
      "tr": "Suudi Arabistan",
      "ro": "Arabia Saudită",
      "ar": "المملكة العربية السعودية",
      "fa": "عربستان سعودی",
      "yue": "沙特阿拉伯"
    },
    flag: "🇸🇦", // رمز العلم
    code: "SA", // كود الدولة
    dialCode: "966", // كود الاتصال الدولي
    minLength: 9, // طول رقم الهاتف الأدنى
    maxLength: 9, // طول رقم الهاتف الأقصى
  );

  @override
  Widget build(BuildContext context) {
    const initialCountryCode = 'SA';
    var country =
        countries.firstWhere((element) => element.code == initialCountryCode);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: IntlPhoneField(
            invalidNumberMessage: '172'.tr,
            dropdownTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textBlack,
                fontSize: 15,
                fontWeight: FontWeight.w900),
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textBlack,
                fontSize: 16,
                fontWeight: FontWeight.w900),
            pickerDialogStyle: PickerDialogStyle(
              countryNameStyle: Theme.of(context).textTheme.bodySmall,
            ),
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: AppColors.backGFieldPh,
                    width: 2,
                    style: BorderStyle.solid),
              ),
              fillColor: Get.theme.scaffoldBackgroundColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: AppColors.backGFieldPh,
                    width: 2,
                    style: BorderStyle.solid),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: AppColors.backGFieldPh,
                    width: 2,
                    style: BorderStyle.solid),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Colors.red, width: 2, style: BorderStyle.solid),
              ),
              helperText: '',
              hintText: hint,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
              errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.red[700],
                  fontSize: 10,
                  fontWeight: FontWeight.w500),
            ),
//            validator: (PhoneNumber? phone) {
//   return validators!(phone);
// },
            languageCode: '${_myServices.sharedPreferences.getString('Lang')}',
            initialCountryCode: 'SA', // تحديد السعودية كالدولة الافتراضية
            showDropdownIcon: false, // إخفاء أيقونة اختيار الدولة
            countries: [saudiArabia],
            onChanged: (phone) {
              String phoneNumberWithoutDialCode = phone.completeNumber
                  .replaceFirst('+' '966', ''); // إزالة كود الدولة

              if (phoneNumberWithoutDialCode.length >= country.minLength &&
                  phoneNumberWithoutDialCode.length <= country.maxLength) {
                print(phoneNumberWithoutDialCode);
                controller.text = phoneNumberWithoutDialCode;
                print(controller.text);
                print('sssssssssssssssssssssssss');
              }
            },

            onCountryChanged: (saudiArabia) {},
          ),
        )
      ],
    );
  }
}
