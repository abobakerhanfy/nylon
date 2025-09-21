import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/features/payment/presentation/controller/controller_payment.dart';

class FormExample extends StatefulWidget {
  const FormExample({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FormExampleState createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedZone;

  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();

  static List<String> getSuggestions(String query) {
    ControllerPayment controller = Get.find();
    List<String> matches = <String>[];
    matches.addAll(
      controller.zoneId.map((zone) => zone.nameAr).toList(),
    );
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerPayment>(
        init: ControllerPayment(),
        builder: (controller) {
          return DropDownSearchFormField(
            autoFlipMinHeight: MediaQuery.of(context).size.height * 0.30,
            textFieldConfiguration: TextFieldConfiguration(
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    color: Colors.black,
                  ),
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: '52'.tr,
                filled: true,
                hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                    ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                // borderRadius موجود دائمًا، ولكن بدون عرض الحدود
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none, // إخفاء الحدود
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none, // إخفاء الحدود عند التركيز
                ),

                // إظهار الحدود فقط عند وجود خطأ
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 206, 47, 47), width: 1),
                ),
              ),
              controller: controller.cCitys,
            ),
            suggestionsCallback: (pattern) {
              return getSuggestions(pattern); // تمرير الدالة الخاصة بالبحث
            },
            itemBuilder: (context, String suggestion) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(suggestion,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 15)),
              );
            },
            itemSeparatorBuilder: (context, index) {
              return const Divider();
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox; // تخصيص كيف يتم عرض العناصر في صندوق الاقتراحات
            },
            onSuggestionSelected: (String suggestion) {
              print(suggestion);
              print('onSuggest');
              setState(() {
                controller.cCitys.text = suggestion;
                try {
                  // البحث عن الكائن Zone بناءً على الاسم المدخل
                  var city = controller.zoneId.firstWhere(
                    (zone) => zone.nameAr == controller.cCitys.text,
                    orElse: () => throw Exception('City not found'),
                  );

                  controller.cZoneId.text = city.zoneId;
                  controller.cCountryId.text = city.countryId;
                  print(
                      'Zone ID: ${controller.cCitys.text} ${controller.cCountryId.text} ${controller.cZoneId.text}');
                } catch (e) {
                  print('sssssssssssssssssssssss');
                  print(e
                      .toString()); // التعامل مع الخطأ في حال عدم العثور على المدينة
                }
              });
            },
            suggestionsBoxController: suggestionBoxController,
            // validator: (value) => value!.isEmpty ? '163'.tr : null,
            validator: (value) {
              // التحقق من أن القيمة ليست فارغة
              if (value == null || value.isEmpty) {
                return '163'.tr;
              }

              bool isValid =
                  controller.zoneId.any((zone) => zone.nameAr == value);
              if (!isValid) {
                return 'المحافظة غير موجودة';
              }

              return null; // لا يوجد خطأ
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSaved: (value) {
              _selectedZone = value;
              print('on ssssssss');
              print(value);
            },
            displayAllSuggestionWhenTap: true,
          );
        });
  }
}
