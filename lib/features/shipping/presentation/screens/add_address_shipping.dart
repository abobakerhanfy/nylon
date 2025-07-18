import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/core/widgets/primary_button.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/field_cart.dart';
import 'package:nylon/features/payment/presentation/controller/controller_payment.dart';
import 'package:nylon/features/payment/presentation/screens/payment_address.dart';
import 'package:nylon/features/payment/presentation/screens/widgets/tt.dart';
import 'package:nylon/features/shipping/presentation/controller/controller_shipping.dart';

// ignore: must_be_immutable
class AddAddressShipping extends StatefulWidget {
  const AddAddressShipping({super.key});

  @override
  State<AddAddressShipping> createState() => _AddAddressShippingState();
}

class _AddAddressShippingState extends State<AddAddressShipping> {
  final ControllerShipping _controller = Get.put(ControllerShipping());
  final ControllerPayment _controllerPayment = Get.put(ControllerPayment());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.10,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: GetBuilder<ControllerShipping>(builder: (controller) {
          return controller.statusRequestaddAddress == StatusRequest.loading
              ? Container(
                  child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ))
              : PrimaryButton(
                  onTap: () {
                    controller.addAddressOnShippping();
                  },
                  label: '85'.tr);
        }),
      ),
      appBar: customAppBarTow(title: '85'.tr),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: LayoutBuilder(builder: (context, boxSize) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: SingleChildScrollView(
              child: GetBuilder<ControllerShipping>(
                  init: ControllerShipping(),
                  builder: (controller) {
                    return Form(
                      key: controller.formAddAddressShipping,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '34'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.black),
                          ),

                          SizedBox(
                            height: boxSize.maxHeight * 0.03,
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
                            height: boxSize.maxHeight * 0.03,
                          ),
                          Center(
                            child: CustomFiledCart(
                                width: boxSize.maxWidth * 0.90,
                                hint: '50'.tr,
                                controller: controller.cPhone,
                                validator: validatePhone),
                          ),

                          SizedBox(
                            height: boxSize.maxHeight * 0.04,
                          ),
                          Text(
                            '51'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.black),
                          ),
                          SizedBox(
                            height: boxSize.maxHeight * 0.03,
                          ),
                          Center(
                            child: CustomFiledCart(
                              width: boxSize.maxWidth * 0.90,
                              hint: '51'.tr,
                              controller: controller.cAddress,
                              validator: (value) =>
                                  value!.isEmpty ? '163'.tr : null,
                            ),
                          ),
                          SizedBox(
                            height: boxSize.maxHeight * 0.03,
                          ),
                          const FormExample(),

                          //  SizedBox(height: boxSize.maxHeight*0.03,),
                          //  Center(
                          //    child: CustomFiledCart(
                          //      width:boxSize.maxWidth*0.90,
                          //      hint: '52'.tr,
                          //       controller: _controller.cCitys,
                          //      validator: (value) => value!.isEmpty ? '163'.tr : null,
                          //    ),
                          //  ),
                          //  SizedBox(height: boxSize.maxHeight*0.03,),
                          //  Center(
                          //    child: CustomFiledCart(
                          //      width:boxSize.maxWidth*0.90,
                          //      hint: '164'.tr,
                          //      controller: _controller.cCountryId,
                          //     validator: (value) => value!.isEmpty ? '163'.tr : null,
                          //    ),
                          //  ),
                          //   SizedBox(height: boxSize.maxHeight*0.03,),
                          //  Center(
                          //    child: CustomFiledCart(
                          //      width:boxSize.maxWidth*0.90,
                          //      hint: '165'.tr,
                          //      controller: _controller.cZoneId,
                          //     validator: (value) => value!.isEmpty ? '163'.tr : null,
                          //    ),
                          //  ),
                        ],
                      ),
                    );
                  }),
            ),
          );
        }),
      ),
    );
  }
}
