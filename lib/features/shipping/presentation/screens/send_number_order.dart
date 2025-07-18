import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/field_cart.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/button_on_cart.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/features/shipping/presentation/controller/controller_shipping.dart';

// ignore: must_be_immutable
class SendNumerOrderForTracking extends StatelessWidget {
  SendNumerOrderForTracking({super.key});
  var x = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: customAppBarTow(title: '82'.tr),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.30,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'images/delivery.png',
                      ),
                      fit: BoxFit.none)),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.80,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: GetBuilder<ControllerShipping>(
                  init: ControllerShipping(),
                  builder: (controller) {
                    return Form(
                      key: controller.formTrackingSendCode,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('82'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: CustomFiledCart(
                              width: MediaQuery.of(context).size.width * 0.80,
                              hint: '83'.tr,
                              controller: controller.cIdOrder,
                              validator: (value) =>
                                  value!.isEmpty ? '163'.tr : null,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: controller.statusRequestgetTracking ==
                                    StatusRequest.loading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    ),
                                  )
                                : ButtonOnCart(
                                    width: MediaQuery.of(context).size.width *
                                        0.80,
                                    label: "82".tr,
                                    onTap: () {
                                      var validator = controller
                                          .formTrackingSendCode.currentState;
                                      if (validator!.validate()) {
                                        controller.getTrackingshipping(
                                            idOrder: controller.cIdOrder.text);
                                        // Get.toNamed(NamePages.pTrackDetails);
                                      }
                                    }),
                          )
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
