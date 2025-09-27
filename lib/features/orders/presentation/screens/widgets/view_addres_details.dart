import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/orders/data/models/one_order_model.dart';
import 'package:nylon/features/orders/presentation/screens/widgets/container_address_details.dart';
import 'package:nylon/features/shipping/presentation/controller/controller_shipping.dart';

class AddressShippingDetailsOrder extends StatelessWidget {
  final DataOrder orderData;
  const AddressShippingDetailsOrder({
    super.key,
    required this.orderData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Get.theme.scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '105'.tr,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontSize: 14, color: AppColors.colorTextBlckNew),
          ),
          const SizedBox(
            height: 10,
          ),
          AddressDetails(
              address: orderData.shippingAddress1 ??
                  orderData.shippingAddress2 ??
                  '',
              phone: orderData.telephone ?? '',
              city: orderData.shippingCity ?? orderData.paymentCity ?? ''),
          const SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
                color: AppColors.backgroundProduct,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    ControllerShipping controllerShipping =
                        Get.put(ControllerShipping());
                    controllerShipping.getTrackingshipping(
                        idOrder: orderData.orderId!);
                    // Get.toNamed(NamePages.pTrackDetails);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Get.theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.primaryColor, width: 0.5)),
                    child: Text(
                      '82'.tr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '106'.tr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.colorTextBlckNew,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${'107'.tr} (15 يونيو)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
