// ignore_for_file: prefer_const_constructors
import 'package:nylon/core/url/url_api.dart';

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
import 'package:nylon/features/payment/presentation/controller/controller_payment.dart';
import 'package:nylon/features/payment/presentation/screens/widgets/Payment_card_fild.dart';
import 'package:nylon/features/payment/presentation/screens/widgets/payment_Image.dart';

class SendOrderBalance extends StatefulWidget {
  const SendOrderBalance({super.key});

  @override
  State<SendOrderBalance> createState() => _SendOrderBalanceState();
}

class _SendOrderBalanceState extends State<SendOrderBalance> {
  final ControllerBalance _controller = Get.find();
  final ControllerPayment _controllerPayment = Get.put(ControllerPayment());

  void printMyFatoorahUrl() {
    final token = _controllerPayment.token;
    final orderId = _controllerPayment.balancePaymentModel?.orderId;
    print("aymentWithMyFatoorah .order_id: =$orderId");

    if (orderId == null || orderId == 0) {
      print(
          "⚠️ order_id لم يتم توليده بعد، تأكد أنك ناديت processBalancePaymentWithMyFatoorah قبلها.");
      return;
    }

    final myfatoorahUrl = "${AppApi.urlMyfatoorah}$token&order_id=$orderId";
    print("🔗 Full MyFatoorah URL: $myfatoorahUrl");
  }

  @override
  void initState() {
    super.initState();
    final customerId = _controllerPayment.customerId;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("🚀 Sending fastCheckout with: "
          "firstname=${_controller.cFirstName.text}, "
          "lastname=${_controller.cLastName.text}, "
          "address1=طلب رقمي, city=Makaa");

      await _controllerPayment.fastCheckout(
        customerId: customerId,
        firstname: "منتج",
        lastname: "رقمي",
        address1: "طلب رقمي",
        city: "Makaa",
      );

      await _controllerPayment.getBalancePaymentsAndAutoSelectMyFatoorah(
        customerId: customerId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: customAppBarTow(title: '123'.tr),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          SizedBox(height: 10),
          Text('86'.tr,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black)),
          SizedBox(height: 10),
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
                    controller: _controller.cFirstName,
                  ),
                ),
                SizedBox(width: 15),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: TextFildAddess(
                    label: '88'.tr,
                    valid: (value) => value!.isEmpty ? '163'.tr : null,
                    textInputType: TextInputType.name,
                    controller: _controller.cLastName,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          GetBuilder<ControllerPayment>(builder: (controllerPayment) {
            return HandlingDataView(
              statusRequest: controllerPayment.statusRequestGetPayment ??
                  StatusRequest.loading,
              onRefresh: () => controllerPayment.getPayment(),
              widget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text('169'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.black)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(8),
                    itemCount: controllerPayment.paymentsDataList.length,
                    separatorBuilder: (context, i) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02),
                    itemBuilder: (context, i) {
                      final data = controllerPayment.paymentsDataList[i];
                      return data.code == "myfatoorah_pg"
                          ? ContainerPaymentDataBalance(
                              paymentsData: data,
                              codePayment: controllerPayment.selectCodePayment,
                            )
                          : SizedBox.shrink();
                    },
                  )
                ],
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: GetBuilder<ControllerBalance>(builder: (controller) {
        return SizedBox(
          height: 180,
          child: controller.statusRequestGetCartB == StatusRequest.loading
              ? Center(
                  child:
                      CircularProgressIndicator(color: AppColors.primaryColor))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            controller.getTotalBalance?.totals?.length ?? 0,
                        separatorBuilder: (context, i) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        itemBuilder: (context, i) {
                          return invoiceRow(
                            title:
                                controller.getTotalBalance?.totals?[i].title ??
                                    '',
                            priceWidget: textWithRiyal(
                              controller.getTotalBalance?.totals?[i].text ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.greyColor),
                            ),
                          );
                        },
                      ),
                    ),
                    controller.statusRequestSendOrderB == StatusRequest.loading
                        ? Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primaryColor))
                        : ButtonOnCart(
                            width: MediaQuery.of(context).size.width * 0.80,
                            label: '36'.tr,
                            onTap: () async {
                              print('test');
                              if (_controllerPayment
                                  .selectCodePayment.isEmpty) {
                                Get.snackbar(
                                    "تنبيه", "الرجاء اختيار وسيلة دفع أولاً",
                                    snackPosition: SnackPosition.BOTTOM);
                                return;
                              }
                              // await controller.sendDataUser();
                              // if (controller.statusRequestSendDUser !=
                              //     StatusRequest.success) {
                              //   newCustomDialog(
                              //     title:
                              //         'الرجاء اضافة البيانات حتي يتم اضافة الرصيد',
                              //     body: SizedBox(
                              //       height: 40,
                              //       child: PrimaryButton(
                              //           label: 'موافق',
                              //           onTap: () => Get.back()),
                              //     ),
                              //     dialogType: DialogType.error,
                              //   );
                              //   return;
                              // }
                              // await _controllerPayment.selectPayment(
                              //     paymentCode:
                              //         _controllerPayment.selectCodePayment);
                              // if (_controllerPayment.selectCodePayment ==
                              //     "myfatoorah_pg") {
                              //   await _controllerPayment
                              //       .processBalancePaymentWithMyFatoorah();
                              //   printMyFatoorahUrl(); // 🔥 هنا فقط هيتطبع ومعاه order_id
                              // }
                            },
                          ),
                  ],
                ),
        );
      }),
    );
  }
}

class ContainerPaymentDataBalance extends StatelessWidget {
  final PaymentsData paymentsData;
  final String? codePayment;

  const ContainerPaymentDataBalance(
      {super.key, required this.paymentsData, this.codePayment});

  @override
  Widget build(BuildContext context) {
    final ControllerPayment controllerPayment = Get.find();
    return InkWell(
      onTap: () async {
        await controllerPayment.selectCodeBalance(
            code: paymentsData.code ?? '',
            title: paymentsData.separatedText ?? '');
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.colorCreditCard,
          border: Border.all(
            color: codePayment == paymentsData.code
                ? AppColors.primaryColor
                : AppColors.colorCreditCard,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            if (paymentsData.images != null && paymentsData.images!.isNotEmpty)
              ...paymentsData.images!.length > 1
                  ? [
                      Flexible(
                        child: SizedBox(
                          height: 30,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: paymentsData.images?.length ?? 0,
                            separatorBuilder: (context, i) =>
                                SizedBox(width: 7),
                            itemBuilder: (context, i) => PaymentImageWidget(
                                imageUrl: paymentsData.images?[i] ?? ''),
                          ),
                        ),
                      ),
                    ]
                  : [
                      SizedBox(
                        height: 50,
                        child: CachedNetworkImageWidget(
                            fit: BoxFit.cover,
                            imageUrl: paymentsData.images?.first ?? ''),
                      )
                    ],
            SizedBox(width: 8),
            Expanded(
              child: Text(
                paymentsData.separatedText ?? '',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 12, color: Color(0xFF1F1B1B)),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (codePayment == paymentsData.code)
              Icon(Icons.check_circle, color: AppColors.primaryColor),
          ],
        ),
      ),
    );
  }
}
