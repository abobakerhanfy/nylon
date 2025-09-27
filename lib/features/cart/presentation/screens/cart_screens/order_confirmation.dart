import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/snack_bar.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/container_cart_product.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';
import 'package:nylon/features/orders/presentation/controller/controller_order.dart';
import 'package:nylon/features/payment/presentation/controller/controller_payment.dart';
import 'package:nylon/features/shipping/presentation/controller/controller_shipping.dart';
import '../../../../../core/theme/colors_app.dart';
import '../widgets/button_on_cart.dart';
import '../widgets/row_invoice.dart';

class OrderConfirmation extends StatelessWidget {
  OrderConfirmation({super.key});

  final ControllerCart cartController = Get.find<ControllerCart>();
  final ControllerPayment paymentController = Get.find();
  final ControllerShipping shippingController = Get.find();
  final ControllerOrder orderController = Get.find();

  @override
  Widget build(BuildContext context) {
    print("📄 OrderConfirmationNew build executed ✅");

    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: LayoutBuilder(
          builder: (context, boxSize) {
            return GetBuilder<ControllerCart>(
              id: "cartProducts",
              builder: (cart) {
                return (cart.cartModel.products?.isNotEmpty ?? false)
                    ? ListView(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 8),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, i) =>
                                  SizedBox(height: boxSize.maxHeight * 0.01),
                              itemCount: cart.cartModel.products!.length,
                              itemBuilder: (context, i) {
                                return ContainerProductCart(
                                  products: cart.cartModel.products![i],
                                  onCart: false,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: boxSize.maxHeight * 0.02),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text("34".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: 18)),
                          ),
                          SizedBox(height: boxSize.maxHeight * 0.02),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              width: boxSize.maxWidth * 0.90,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                paymentController.cAddress.text,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(height: boxSize.maxHeight * 0.04),
                          Row(
                            children: [
                              Text('170'.tr,
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(width: 4),
                              Text(shippingController.Shippingtitle,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                          SizedBox(height: boxSize.maxHeight * 0.04),
                          Row(
                            children: [
                              Text('169'.tr,
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  paymentController.titlePayment,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          if (paymentController.selectCodePayment ==
                              'bank_transfer')
                            Padding(
                              padding: EdgeInsets.only(
                                  top: boxSize.maxHeight * 0.04),
                              child: GetBuilder<ControllerPayment>(
                                builder: (_) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text('177'.tr,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Container(
                                            height: 95,
                                            width: 75,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: paymentController.file !=
                                                    null
                                                ? Image.file(
                                                    paymentController.file!,
                                                    fit: BoxFit.fill)
                                                : Center(
                                                    child: InkWell(
                                                        onTap: () async {
                                                          await paymentController
                                                              .addImagesPicker();
                                                        },
                                                        child: Icon(
                                                            Icons.upload_file,
                                                            size: 26,
                                                            color: Colors
                                                                .grey[800]))),
                                          ),
                                          if (paymentController.file != null)
                                            InkWell(
                                              onTap: () async {
                                                if (await paymentController
                                                    .file!
                                                    .exists()) {
                                                  await paymentController.file!
                                                      .delete();
                                                  paymentController.file = null;
                                                  paymentController.update();
                                                }
                                              },
                                              child: const Icon(Icons.clear,
                                                  size: 16,
                                                  color: Colors.black),
                                            ),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                          SizedBox(height: boxSize.maxHeight * 0.03),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text("42".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: 18)),
                          ),
                          SizedBox(height: boxSize.maxHeight * 0.04),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cart.cartModel.totals?.length ?? 0,
                              separatorBuilder: (context, i) =>
                                  SizedBox(height: boxSize.maxHeight * 0.01),
                              itemBuilder: (context, i) {
                                return invoiceRow(
                                  title: cart.cartModel.totals![i].title!,
                                  price: cart.cartModel.totals![i].text!,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: boxSize.maxHeight * 0.03),
                          GetBuilder<ControllerOrder>(
                            builder: (order) {
                              return order.statusRequestSendOrder ==
                                      StatusRequest.loading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                          color: AppColors.primaryColor))
                                  : ButtonOnCart(
                                      width: boxSize.maxWidth * 0.80,
                                      label: '36'.tr,
                                      onTap: () async {
                                        if (paymentController
                                                    .selectCodePayment ==
                                                'bank_transfer' &&
                                            paymentController.file == null) {
                                          showSnackBar('186'.tr);
                                        } else {
                                          await orderController.sendOrder();
                                          if (orderController
                                                  .statusRequestSendOrder ==
                                              StatusRequest.success) {
                                            cart.plusIndexScreensCart();
                                            await cart.getCart();
                                          } else {
                                            print(
                                                '❌ Error during order submission');
                                          }
                                        }
                                      },
                                    );
                            },
                          ),
                          SizedBox(height: boxSize.maxHeight * 0.03),
                        ],
                      )
                    : Center(
                        child: Text('149'.tr,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center),
                      );
              },
            );
          },
        ),
      ),
    );
  }
}
