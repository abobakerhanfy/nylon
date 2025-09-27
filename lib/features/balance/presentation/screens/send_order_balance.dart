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
import 'package:nylon/core/services/services.dart';

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
    final MyServices myServices = Get.find();
    myServices.sharedPreferences.setString('UserId', '');
    final customerId = myServices.sharedPreferences.getString("UserId") ?? "";

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _controller.getPayment(); // ✅ هذا هو السطر الأساسي المطلوب
      print(_controller.paymentsDataList.map((e) => e.code));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fullAppBackgroundColor,
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
                              if ((_controller.selectCodePayment ?? "")
                                  .isEmpty) {
                                Get.snackbar(
                                    "تنبيه", "الرجاء اختيار وسيلة دفع أولاً");
                                return;
                              }

                              // ✅ املأ الحقول إذا كانت فارغة
                              if (_controller.cFirstName.text.trim().isEmpty) {
                                _controller.cFirstName.text = "شحن";
                              }
                              if (_controller.cLastName.text.trim().isEmpty) {
                                _controller.cLastName.text = "رصيد";
                              }

                              if (controller.statusRequestSendOrderB ==
                                  StatusRequest.loading) {
                                return;
                              }

                              try {
                                await controller
                                    .sendDataUser(); // ✅ إرسال البيانات

                                if (controller.statusRequestSendDUser !=
                                    StatusRequest.success) {
                                  newCustomDialog(
                                    body: PrimaryButton(
                                      label: 'موافق',
                                      onTap: () => Get.back(),
                                    ),
                                    title:
                                        'الرجاء اضافة البيانات حتي يتم اضافة الرصيد',
                                    dialogType: DialogType.error,
                                  );
                                  return;
                                }

                                if (_controller.selectCodePayment ==
                                    "myfatoorah_pg") {
                                  await _controller
                                      .processBalanceWithMyFatoorah();
                                }
                              } catch (e) {
                                Get.snackbar(
                                    "خطأ", "حدث خطأ أثناء تنفيذ العملية");
                              }
                            }),
                  ],
                );
        }),
      ),
      appBar: customAppBarTow(title: '123'.tr),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const SizedBox(
            height: 10,
          ),
          Text('86'.tr,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black)),
          const SizedBox(
            height: 10,
          ),
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
                const SizedBox(
                  width: 15,
                ),
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
          SizedBox(
            height: 20,
          ),
          GetBuilder<ControllerBalance>(builder: (controllerPayment) {
            print("🟢 selectCodePayment => ${_controller.selectCodePayment}");
            print("🟢 paymentsDataList => ${_controller.paymentsDataList}");
            print(
                "🟢 balancePaymentModel => ${_controller.balancePaymentModel}");
            print(
                "🟢 balancePaymentModel.orderId => ${_controller.balancePaymentModel?.orderId}");

            return HandlingDataView(
              statusRequest: controllerPayment.statusRequestGetPayment ??
                  StatusRequest.loading,
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
                      itemCount: controllerPayment.paymentsDataList.length ?? 0,
                      itemBuilder: (context, i) {
                        return controllerPayment.paymentsDataList[i].code ==
                                "myfatoorah_pg"
                            ? ContainerPaymentDataBalance(
                                codePayment:
                                    controllerPayment.selectCodePayment,
                                paymentsData:
                                    controllerPayment.paymentsDataList[i],
                                balanceController: _controller,
                              )
                            : SizedBox.shrink();
                      },
                    ),
                  )
                ],
              ),
              onRefresh: () {
                controllerPayment.getPayment();
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
  final ControllerBalance balanceController;

  const ContainerPaymentDataBalance({
    super.key,
    required this.paymentsData,
    this.codePayment,
    required this.balanceController,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerBalance>(
      builder: (controller) {
        print(
            "🚀 ContainerPaymentDataBalance => code: ${paymentsData.code}, selected: ${controller.selectCodePayment}");

        return InkWell(
          onTap: () {
            print(paymentsData.images?.length ?? 0);
            // استخدام ControllerBalance بدلاً من ControllerPayment لتحديد الكود المحدد
            balanceController.selectCodeBalance(
                code: paymentsData.code ?? '',
                title: paymentsData.separatedText ?? '');
            // أو يمكن تحديث الكود المحدد مباشرة في balanceController
            balanceController.selectCodePayment = paymentsData.code;
            balanceController.update();
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
                          child: SizedBox(
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
