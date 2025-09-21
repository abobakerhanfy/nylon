// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/field_cart.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';
import 'package:nylon/features/payment/presentation/controller/controller_payment.dart';
import 'package:nylon/features/payment/presentation/screens/widgets/tt.dart';

import '../../../cart/presentation/screens/widgets/button_on_cart.dart';

// ignore: must_be_immutable
class DeliveryOnCart extends StatelessWidget {
  DeliveryOnCart({super.key});

  final ControllerCart _controllerCart = Get.put(ControllerCart());

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxSize) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: SingleChildScrollView(
          child: GetBuilder<ControllerPayment>(
              init: ControllerPayment(),
              builder: (controller) {
                return Form(
                  key: controller.formAddAddress,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.getPayment();
                        },
                        child: Text(
                          '34'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: boxSize.maxHeight * 0.02,
                      ),
                      Center(
                        child: CustomFiledCart(
                          width: boxSize.maxWidth * 0.90,
                          hint: '48'.tr,
                          controller: controller.cFirstName,
                          validator: (value) =>
                              value!.isEmpty ? '163'.tr : null,
                        ),
                      ),
                      SizedBox(
                        height: boxSize.maxHeight * 0.02,
                      ),
                      Center(
                        child: CustomFiledCart(
                          width: boxSize.maxWidth * 0.90,
                          hint: '171'.tr,
                          controller: controller.cEmail,
                          validator: validateEmail,
                        ),
                      ),
                      SizedBox(
                        height: boxSize.maxHeight * 0.02,
                      ),
                      Center(
                        child: CustomFiledCart(
                          width: boxSize.maxWidth * 0.90,
                          hint: '50'.tr,
                          controller: controller.cPhone,
                          // validator: validatePhone
                        ),
                      ),
                      SizedBox(
                        height: boxSize.maxHeight * 0.03,
                      ),
                      Text(
                        '51'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: Colors.black),
                      ),
                      SizedBox(
                        height: boxSize.maxHeight * 0.02,
                      ),
                      Center(
                        child: CustomFiledCart(
                          width: boxSize.maxWidth * 0.90,
                          hint: '187'.tr,
                          controller: controller.cAddress,
                          validator: (value) =>
                              value!.isEmpty ? '163'.tr : null,
                        ),
                      ),
                      SizedBox(
                        height: boxSize.maxHeight * 0.02,
                      ),
                      FormExample(),
                      SizedBox(
                        height: boxSize.maxHeight * 0.05,
                      ),
                      controller.statusRequestAddAddress ==
                              StatusRequest.loading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            )
                          : ButtonOnCart(
                              width: boxSize.maxWidth * 0.80,
                              label: '54'.tr,
                              onTap: () async {
                                _controllerCart.plusIndexScreensCart();
                                await controller.addAddressPayment().then((_) {
                                  if (controller.statusRequestAddAddress ==
                                      StatusRequest.success) {
                                    //  _controller.sendCodeBySms();
                                    _controllerCart.plusIndexScreensCart();
                                  }
                                });
                              }),
                      SizedBox(
                        height: boxSize.maxHeight * 0.02,
                      ),
                    ],
                  ),
                );
              }),
        ),
      );
    });
  }
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return '163'.tr;
  }
  String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return '173'.tr;
  }
  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return '163'.tr; // رسالة الخطأ عند ترك الحقل فارغاً
  }

  // النمط للتحقق من أن الرقم يبدأ بكود السعودية +966 أو 05، ويليه 8 أرقام.
  String pattern = r'^(?:\966|05)[0-9]{8}$';
  RegExp regex = RegExp(pattern);

  if (!regex.hasMatch(value)) {
    return '172'.tr;
    // رسالة الخطأ عند وجود مدخل غير مطابق للرقم السعودي
  }

  return null; // المدخل صحيح
}


// String? validatePhone(String? value) {
//   if (value == null || value.isEmpty) {
//     return '163'.tr; // رسالة الخطأ عند ترك الحقل فارغاً
//   }

//   // السماح بأي عدد من الأرقام، على أن يكون كل المدخل أرقام فقط
//   String pattern = r'^\d+$'; 
//   RegExp regex = RegExp(pattern);
  
//   if (!regex.hasMatch(value)) {
//     return '172'.tr; // رسالة الخطأ عند وجود مدخل غير رقمي
//   }

//   return null; // المدخل صحيح
// }
                
                    //  SizedBox(height: boxSize.maxHeight*0.02,),
//                            Container(
                        
//                         padding: const EdgeInsets.symmetric(horizontal: 4),
//                                       alignment: Alignment.center,
//                                      margin:const  EdgeInsets.symmetric(vertical: 10),
//                         child:  DropdownSearch<String>(
//                         items: (filter, infiniteScrollProps) =>
//                          _controller.zoneId.map((zone) => zone.nameAr).toList(), 
                         
//                           validator: (value) => value!.isEmpty ? '163'.tr : null,
//                          autoValidateMode:   AutovalidateMode.onUserInteraction,
                         
//                        onChanged: (value) {
//                 setState(() {
//                   _controller.cCitys.text=value!;
//                           try {
//   // البحث عن الكائن Zone بناءً على الاسم المدخل
//   var city = _controller.zoneId.firstWhere(
//     (zone) => zone.nameAr == _controller.cCitys.text,
//     orElse: () => throw Exception('City not found'),
//   );

//   _controller.cZoneId.text = city.zoneId;
//   _controller.cCountryId.text = city.countryId;
//   print('Zone ID: ${_controller.cCitys.text} ${_controller.cCountryId.text } ${_controller.cZoneId.text}'); 
// } catch (e) {
//   print('sssssssssssssssssssssss');
//   print(e.toString()); // التعامل مع الخطأ في حال عدم العثور على المدينة
// }
//                 });

//                           },
//                         decoratorProps:DropDownDecoratorProps(
                                  
//                           decoration:InputDecoration(
                            
//                           hintText:'52'.tr,
                          
//                           isDense: true,
//                             border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide.none,
//           ),
          
//                             // fillColor:  ThemeColors.fildBackGround,
//                             enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide.none,
//           ),
//                           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide.none,
//           ),
//                               errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide(color: const Color.fromARGB(255, 206, 47, 47), width: 1),
//           ),
//                             filled: true,
//                            hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
//                 color: Colors.black,
//                 fontSize: 11,
//                 fontWeight: FontWeight.normal,
//               ),
//                             errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
//                                 color: Colors.red[700],fontSize: 10,fontWeight: FontWeight.w500
//                             ),
//                              errorMaxLines: 1, 
//                           )
//                         ),
//                         popupProps: PopupProps.menu(
//                             fit: FlexFit.loose, constraints: BoxConstraints(
//                               maxHeight: boxSize.maxWidth*0.30,
//                              ),
//                               itemBuilder:(context, item, a,b) {
//                       return  Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                             item,
//                             style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                               color: Colors.black,fontWeight: FontWeight.normal,fontSize: 15
//                             )
//                           ),
//                       );
//                                         },
                            
//                             ),
                            
//                       ),
//                        ),
                      // Center(
                      //   child:CustomFiledCartZone(
                      // width:boxSize.maxWidth*0.90, 
                      //     hint: 'المحازز', 
                      //     controller: _controller.cZoneId,
                      //      zones: _controller.zoneId,)
                      // ),
                    //  Center(
                    //    child: CustomFiledCart(
                    //      width:boxSize.maxWidth*0.90,
                    //      hint: '164'.tr,
                    //      controller: _controller.cCountryId,
                    //     validator: (value) => value!.isEmpty ? '163'.tr : null,
                    //    ),
                    //  ),
                    //   SizedBox(height: boxSize.maxHeight*0.02,),
                    //  Center(
                    //    child: CustomFiledCart(
                    //      width:boxSize.maxWidth*0.90,
                    //      hint: '165'.tr,
                    //      controller: _controller.cZoneId,
                    //     validator: (value) => value!.isEmpty ? '163'.tr : null,
                    //    ),
                    //  ),