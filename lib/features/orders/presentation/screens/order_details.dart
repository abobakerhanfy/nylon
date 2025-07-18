import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/row_invoice.dart';
import 'package:nylon/features/orders/presentation/controller/controller_order.dart';
import 'package:nylon/features/orders/presentation/screens/widgets/Items_on_orders.dart';
import 'package:nylon/features/orders/presentation/screens/widgets/bottom_on_order.dart';
import 'package:nylon/features/orders/presentation/screens/widgets/view_addres_details.dart';

class OrderDetails extends StatelessWidget {
  OrderDetails({super.key});
  final ControllerOrder _controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        color: Colors.white,
        margin: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BottomOnOrder(
                title: "103".tr,
                onTap: () {},
                textColor: AppColors.colorTextBlckNew,
                colorBorder: AppColors.primaryColor),
            BottomOnOrder(
                title: '104'.tr,
                onTap: () {
                  _controller.getNameAndModelList();
                  Get.toNamed(NamePages.pSendComplaints);
                },
                textColor: AppColors.colorRed,
                colorBorder: AppColors.colorRed),
          ],
        ),
      ),
      appBar: customAppBarTow(title: '102'.tr),
      body: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: LayoutBuilder(
          builder: (context, boxSize) {
            return GetBuilder<ControllerOrder>(builder: (controller) {
              return HandlingDataView(
                statusRequest: controller.statusRequestOneOrder!,
                widget: GetBuilder<ControllerOrder>(builder: (controller) {
                  return ListView(
                    children: [
                      ItemsMyOrdersWidget(
                        products:
                            controller.oneOrderModel!.data!.products ?? [],
                      ),
                      SizedBox(height: boxSize.maxHeight * 0.02),
                      AddressShippingDetailsOrder(
                          orderData: controller.oneOrderModel!.data!),
                      SizedBox(height: boxSize.maxHeight * 0.02),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller
                                  .oneOrderModel!.data!.totalData?.length ??
                              0,
                          separatorBuilder: (context, i) => SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          itemBuilder: (context, i) {
                            final title = controller
                                .oneOrderModel!.data!.totalData![i].title!;
                            final priceText =
                                "${controller.oneOrderModel!.data!.totalData![i].text}";
                            return invoiceRow(
                              title: title,
                              priceWidget: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    priceText, // ✅
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(width: 4),
                                  Image.asset(
                                      "images/riyalsymbol_compressed.png",
                                      height: 14),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: boxSize.maxHeight * 0.02),

                      // ✅ جدول history هنا
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "حالة الطلب",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...?controller.oneOrderModel?.data?.histories
                                ?.map((history) {
                              Color statusColor;
                              String status = history.status ?? '';

                              if (status.contains("مكتمل")) {
                                statusColor = Colors.green;
                              } else if (status.contains("جاري") ||
                                  status.contains("قيد")) {
                                statusColor = Colors.orange;
                              } else {
                                statusColor = Colors.blueGrey;
                              }

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // دائرة الحالة
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: statusColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // التفاصيل
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color:
                                                  statusColor.withOpacity(0.4)),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "🗓 التاريخ: ${history.dateAdded ?? ''}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            const SizedBox(height: 4),
                                            Text("✅ الحالة: $status",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: statusColor)),
                                            if ((history.comment ?? '')
                                                .isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                  "📝 ملاحظة: ${history.comment ?? ''}"),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
                onRefresh: () {
                  // _controller.getOneOrder(idOrder: idOrder);
                },
              );
            });
          },
        ),
      ),
    );
  }
}
