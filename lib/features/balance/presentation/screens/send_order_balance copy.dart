// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/address/fild_addess.dart';
import 'package:nylon/core/widgets/cached_network_image.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/core/widgets/login/dialog.dart';
import 'package:nylon/core/widgets/primary_button.dart';
import 'package:nylon/features/balance/presentation/controller/controller_balance.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/button_on_cart.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/row_invoice.dart';
import 'package:nylon/features/payment/data/models/payment_model.dart';
import 'package:nylon/features/payment/presentation/screens/widgets/Payment_card_fild.dart';
import 'package:nylon/features/payment/presentation/screens/widgets/payment_Image.dart';
import 'package:nylon/core/url/url_api.dart';

class SendOrderBalance extends StatefulWidget {
  const SendOrderBalance({super.key});

  @override
  State<SendOrderBalance> createState() => _SendOrderBalanceState();
}

class _SendOrderBalanceState extends State<SendOrderBalance> {
  final ControllerBalance _controller = Get.find();
  @override
  void initState() {
    super.initState();
    final customerId = _controller.customerId;
    print("🚀 from SendOrderBalance: customerId = $customerId");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _controller.getPayment(customerId);
      print(_controller.paymentsDataList.map((e) => e.code));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: SizedBox(
        height: 180,
        child: GetBuilder<ControllerBalance>(builder: (controller) {
          return controller.statusRequestGetCartB == StatusRequest.loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              controller.getTotalBalance?.totals?.length ?? 0,
                          separatorBuilder: (context, i) => SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                          itemBuilder: (context, i) {
                            return invoiceRow(
                              title: controller
                                      .getTotalBalance?.totals?[i].title ??
                                  '',
                              priceWidget: textWithRiyal(
                                controller.getTotalBalance?.totals?[i].text ??
                                    '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.greyColor,
                                    ),
                              ),
                            );
                          }),
                    ),
                    controller.statusRequestSendOrderB == StatusRequest.loading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : ButtonOnCart(
                            width: MediaQuery.of(context).size.width * 0.80,
                            label: '36'.tr,
                            onTap: () async {
                              if (_controller.selectCodePayment.isEmpty) {
                                Get.snackbar(
                                    "تنبيه", "الرجاء اختيار وسيلة دفع أولاً",
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 2));
                                return;
                              }

                              await controller.sendDataUser();

                              if (_controller.statusRequestSendDUser !=
                                  StatusRequest.success) {
                                newCustomDialog(
                                  body: SizedBox(
                                    height: 40,
                                    child: PrimaryButton(
                                      label: 'موافق',
                                      onTap: () {
                                        Get.back();
                                      },
                                    ),
                                  ),
                                  title:
                                      'الرجاء اضافة البيانات حتي يتم اضافة الرصيد',
                                  dialogType: DialogType.error,
                                );
                                return;
                              }

                              await _controller.selectPayment(
                                paymentCode: _controller.selectCodePayment,
                              );

                              if (_controller.selectCodePayment ==
                                  "myfatoorah_pg") {
                                await _controller
                                    .processBalancePaymentWithMyFatoorah();
                              }
                            },
                          ),
                  ],
                );
        }),
      ),
      appBar: customAppBarTow(title: '123'.tr),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const SizedBox(height: 10),
          Text('86'.tr,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black)),
          const SizedBox(height: 10),
          Form(
            key: _controller.formAddDataUser,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: TextFildAddess(
                      label: '87'.tr,
                      valid: (value) => value!.isEmpty ? '163'.tr : null,
                      textInputType: TextInputType.name,
                      controller: _controller.cFirstName),
                ),
                const SizedBox(width: 15),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: TextFildAddess(
                      label: '88'.tr,
                      valid: (value) => value!.isEmpty ? '163'.tr : null,
                      textInputType: TextInputType.name,
                      controller: _controller.cLastName),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          GetBuilder<ControllerBalance>(builder: (controller) {
            return HandlingDataView(
              statusRequest:
                  controller.statusRequestGetPayment ?? StatusRequest.loading,
              widget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    '169'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.black),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SizedBox(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, i) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      itemCount: controller.paymentsDataList.length ?? 0,
                      itemBuilder: (context, i) {
                        return controller.paymentsDataList[i].code ==
                                "myfatoorah_pg"
                            ? ContainerPaymentDataBalance(
                                codePayment: controller.selectCodePayment,
                                paymentsData: controller.paymentsDataList[i],
                              )
                            : SizedBox.shrink();
                      },
                    ),
                  )
                ],
              ),
              onRefresh: () {
                controller.getPayment();
              },
            );
          }),
        ],
      ),
    );
  }
}

class ContainerPaymentDataBalance extends StatelessWidget {
  final PaymentsData paymentsData;
  final String? codePayment;

  const ContainerPaymentDataBalance({
    super.key,
    required this.paymentsData,
    this.codePayment,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerBalance>(
      builder: (controller) {
        return InkWell(
          onTap: () {
            controller.selectCodeBalance(
                code: paymentsData.code ?? '',
                title: paymentsData.separatedText ?? '');
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.colorCreditCard,
              borderRadius: BorderRadius.circular(0),
              border: Border.all(
                color: codePayment == paymentsData.code
                    ? AppColors.primaryColor
                    : AppColors.colorCreditCard,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (paymentsData.images != null &&
                          paymentsData.images!.length == 1) ...{
                        SizedBox(
                          height: 50,
                          child: CachedNetworkImageWidget(
                              fit: BoxFit.cover,
                              imageUrl: paymentsData.images?.first ?? ''),
                        ),
                      },
                      if (paymentsData.images != null &&
                          paymentsData.images!.length > 1)
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.90,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    separatorBuilder: (context, i) =>
                                        const SizedBox(width: 7),
                                    itemCount: paymentsData.images?.length ?? 0,
                                    itemBuilder: (context, i) {
                                      return PaymentImageWidget(
                                          imageUrl:
                                              paymentsData.images?[i] ?? '');
                                    },
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  paymentsData.separatedText ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 31, 27, 27),
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                if (codePayment == paymentsData.code)
                                  Icon(Icons.check_circle,
                                      color: AppColors.primaryColor),
                              ],
                            ),
                          ),
                        ),
                      if (paymentsData.images == null ||
                          paymentsData.images!.isEmpty)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: Text(
                            paymentsData.separatedText ?? '',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 31, 27, 27),
                                    ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const Spacer(),
                      if (codePayment == paymentsData.code)
                        Icon(Icons.check_circle, color: AppColors.primaryColor),
                    ],
                  ),
                  if (controller.selectCodePayment == "myfatoorah_pg" &&
                      paymentsData.code == "myfatoorah_pg")
                    PaymentCardField()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
