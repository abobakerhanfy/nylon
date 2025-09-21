import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/button_on_cart.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/features/orders/presentation/controller/controller_order.dart';
import 'package:nylon/features/orders/presentation/screens/widgets/dropdown_widget.dart';

// ignore: must_be_immutable
class SendComplaints extends StatelessWidget {
  SendComplaints({super.key});
  var x = TextEditingController();
  final ControllerOrder _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: customAppBarTow(title: '113'.tr),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GetBuilder<ControllerOrder>(builder: (controller) {
          return ListView(
            children: [
              Text(
                'تفاصيل المنتج المطلوب استبداله أو إرجاعه',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              Form(
                key: controller.formAddReOrd,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FildSendComplaints(
                            width: MediaQuery.of(context).size.width * 0.40,
                            backGroundColor:
                                const Color.fromRGBO(238, 238, 238, 1),
                            hint:
                                '${controller.oneOrderModel!.data!.firstname ?? ''} ${controller.oneOrderModel!.data!.lastname ?? ''}',
                            enabled: false,
                            maxLines: 1,
                            controller: x),
                        FildSendComplaints(
                          width: MediaQuery.of(context).size.width * 0.40,
                          backGroundColor:
                              const Color.fromRGBO(238, 238, 238, 1),
                          hint:
                              '${'115'.tr} #${controller.oneOrderModel!.data!.orderId ?? ''}',
                          enabled: false,
                          maxLines: 1,
                          controller: x,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomDropdownContainer(
                      hintText: 'اسم المنتج ',
                      items: controller.namesPro!,
                      onChanged: controller.updateSelectedName,
                      // width: MediaQuery.of(context).size.width*0.40,
                      selectedValue: controller.selectName,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomDropdownContainer(
                          hintText: 'نوع المنتج',
                          items: controller.modelsPro!,
                          width: MediaQuery.of(context).size.width * 0.50,
                          onChanged: controller.updateSelectedModel,
                          selectedValue: controller.selectModel,
                        ),
                        FildSendComplaints(
                            validator: (value) =>
                                value!.isEmpty ? '163'.tr : null,
                            width: MediaQuery.of(context).size.width * 0.30,
                            backGroundColor:
                                const Color.fromRGBO(238, 238, 238, 1),
                            hint: 'الكمية',
                            enabled: true,
                            maxLines: 1,
                            controller: controller.controllerCount),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomDropdownContainer(
                        hintText: ' حالة المنتج',
                        items: controller.productStatus.keys.toList(),
                        onChanged: controller.updateSelectedStatuesP,
                        selectedValue: controller.selectStatuesP),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomDropdownContainer(
                        selectedValue: controller.selectReason,
                        items: controller.reasonsMap.keys.toList(),
                        onChanged: controller.updateSelectedReason,
                        hintText: 'سبب الارجاع'),
                    const SizedBox(
                      height: 15,
                    ),
                    FildSendComplaints(
                        backGroundColor: const Color.fromRGBO(220, 53, 69, 1),
                        hint: '116'.tr,
                        enabled: true,
                        maxLines: 6,
                        controller: controller.controllerComment),
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonOnCart(
                        width: double.infinity,
                        label: '117'.tr,
                        onTap: () {
                          controller.addReturnOrder();
                        }),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class FildSendComplaints extends StatelessWidget {
  final String hint;
  final bool enabled;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  double? width;
  final Color backGroundColor;
  FildSendComplaints({
    super.key,
    required this.hint,
    required this.enabled,
    required this.maxLines,
    this.width,
    this.validator,
    required this.controller,
    required this.backGroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: TextFormField(
          maxLines: maxLines,
          validator: validator,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontSize: 18, color: Colors.black),
          textAlign: TextAlign.start,
          controller: controller,
          decoration: InputDecoration(
            enabled: enabled,
            fillColor: backGroundColor,
            filled: true,
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
            border: InputBorder.none,
          ),
          cursorHeight: 25,
          cursorColor: Colors.blue,
          clipBehavior: Clip.antiAlias,
        ),
      ),
    );
  }
}
