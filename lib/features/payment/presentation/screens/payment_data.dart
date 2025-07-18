import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/function/snack_bar.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';
import 'package:nylon/features/payment/presentation/controller/controller_payment.dart';
import 'package:nylon/features/payment/presentation/screens/widgets/container_payment_data.dart';
import 'package:nylon/features/shipping/presentation/controller/controller_shipping.dart';
import 'package:nylon/features/shipping/presentation/screens/widgets/container_select_shipping.dart';
import '../../../../core/theme/colors_app.dart';
import '../../../cart/presentation/screens/widgets/button_on_cart.dart'; // Added missing import
// Added for Address model

class PaymentDataCart extends StatefulWidget {
  const PaymentDataCart({super.key});

  @override
  State<PaymentDataCart> createState() => _PaymentDataCartState();
}

class _PaymentDataCartState extends State<PaymentDataCart> {
  final TextEditingController _textController = TextEditingController();
  final ControllerCart _controllerCart = Get.put(ControllerCart());
  final ControllerPayment _controllerPayment = Get.put(ControllerPayment());
  final ControllerShipping _controllerShipping = Get.put(ControllerShipping());

  @override
  void initState() {
    _controllerShipping.getShippingMethods();
    _controllerShipping.slectCode(title: '', code: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          GetBuilder<ControllerPayment>(
            builder: (controllerPayment) {
              return HandlingDataView(
                statusRequest: controllerPayment.statusRequestGetPayment!,
                widget: GetBuilder<ControllerPayment>(
                  builder: (paymentController) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '175'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: Colors.black),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Row(
                          children: [
                            Text(
                              "176".tr,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Checkbox(
                              value: paymentController.isAddressConfirmed,
                              activeColor: AppColors.primaryColor,
                              onChanged: paymentController.onChanged,
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                _controllerPayment.cCitys.clear();
                                Get.toNamed(NamePages.pAddAddressShipping);
                              },
                              child: Text(
                                '85'.tr,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            )
                          ],
                        ),
                        // --- Address Selection UI ---
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Text(
                          "178"
                              .tr, // Assuming '178' is 'Select Shipping Address'
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: Colors.black),
                        ),
                        const SizedBox(height: 7),
                        HandlingDataView(
                          statusRequest:
                              paymentController.statusRequestGetAddresses ??
                                  StatusRequest.loading, // Handle null state
                          widget: paymentController.userAddresses.isEmpty
                              ? Center(
                                  child: Text("179"
                                      .tr)) // Assuming '179' is 'No saved addresses found.'
                              : ListView.separated(
                                  padding: const EdgeInsets.all(8),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      paymentController.userAddresses.length,
                                  separatorBuilder: (context, i) =>
                                      const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    final address =
                                        paymentController.userAddresses[index];
                                    return InkWell(
                                      onTap: () {
                                        // paymentController.selectAddress(address.addressId!);
                                        paymentController
                                            .selectAddress(address.addressId!)
                                            .then((_) {
                                          Get.snackbar(
                                            'جاري تنفيذ طلبك',
                                            '',
                                            snackPosition: SnackPosition.BOTTOM,
                                            duration:
                                                const Duration(seconds: 1),
                                            showProgressIndicator: true,
                                          );
                                          Future.delayed(
                                              const Duration(milliseconds: 700),
                                              () {
                                            paymentController.getPayment();
                                          });
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: AppColors
                                              .colorCreditCard, // Or another suitable background
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: paymentController
                                                        .selectedAddressId ==
                                                    address.addressId
                                                ? AppColors.primaryColor
                                                : Colors.grey.shade300,
                                            width: paymentController
                                                        .selectedAddressId ==
                                                    address.addressId
                                                ? 2
                                                : 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                address
                                                    .displayAddress, // Use the display helper
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: Colors.black,
                                                    ),
                                              ),
                                            ),
                                            if (paymentController
                                                    .selectedAddressId ==
                                                address.addressId)
                                              Icon(Icons.check_circle,
                                                  color: AppColors.primaryColor,
                                                  size: 20),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          onRefresh: () async {
                            await paymentController.fetchUserAddresses();
                          },
                        ),
                        // --- End Address Selection UI ---

                        SizedBox(
                            height: MediaQuery.of(context).size.height *
                                0.02), // Existing SizedBox
                        Text(
                          '169'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: Colors.black),
                        ),
                        const SizedBox(height: 7),
                        SizedBox(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(8),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, i) => SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            itemCount:
                                paymentController.paymentsDataList.length ?? 0,
                            itemBuilder: (context, i) {
                              return ContainerPaymentData(
                                codePayment:
                                    paymentController.selectCodePayment,
                                paymentsData:
                                    paymentController.paymentsDataList[i],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                onRefresh: () {},
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          GetBuilder<ControllerShipping>(
            builder: (shippingController) {
              return HandlingDataView(
                statusRequest: shippingController.statusRequestgetShipping!,
                widget: GetBuilder<ControllerShipping>(
                  builder: (shippingController) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Text(
                            '170'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 7),
                        _controllerCart.hasReachedTarget == false
                            ? SizedBox(
                                child: ListView.separated(
                                  padding: const EdgeInsets.all(8),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, i) => SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  itemCount: shippingController
                                          .shippingDataMethods.length ??
                                      0,
                                  itemBuilder: (context, i) {
                                    return ContainerSelectShippingMethod(
                                      codeShipping:
                                          shippingController.shippingCode,
                                      shippingMethod: shippingController
                                          .shippingDataMethods[i],
                                    );
                                  },
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.90,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: AppColors.colorCreditCard,
                                    borderRadius: BorderRadius.circular(0),
                                    border: Border.all(
                                        color: AppColors.primaryColor,
                                        width: 2)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          'شحن مجاني',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                fontSize: 12,
                                                color: const Color.fromARGB(
                                                    255, 31, 27, 27),
                                              ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.check_circle,
                                        color: AppColors.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    );
                  },
                ),
                onRefresh: () {},
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          _controllerPayment.statusRequestSelectPayment == StatusRequest.loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : ButtonOnCart(
                  width: MediaQuery.of(context).size.width * 0.80,
                  label: '54'.tr,
                  onTap: () async {
                    if (_controllerPayment.isAddressConfirmed == true) {
                      if (_controllerPayment.selectCodePayment != '') {
                        await _controllerPayment.selectPayment(
                          paymentCode: _controllerPayment.selectCodePayment,
                        );
                        Get.snackbar(
                          'جاري تنفيذ طلبك ',
                          '',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 1),
                          showProgressIndicator: true,
                        );

                        await Future.delayed(const Duration(milliseconds: 700));
                        await _controllerPayment.getPayment();
                        if (_controllerShipping.shippingCode != '') {
                          await _controllerShipping.selectShipping(
                            shippingCode: _controllerShipping.shippingCode,
                          );
                          if (_controllerShipping.statusRequestSelectShipping ==
                              StatusRequest.success) {
                            _controllerCart.plusIndexScreensCart();
                          }
                        } else {
                          showSnackBar('168'.tr);
                        }
                      } else {
                        showSnackBar('166'.tr);
                      }
                    } else {
                      showSnackBar('174'.tr);
                    }
                  },
                ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        ],
      ),
    );
  }
}
