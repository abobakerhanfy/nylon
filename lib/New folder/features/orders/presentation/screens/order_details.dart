import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/features/orders/presentation/controller/controller_order.dart';
import 'package:nylon/features/orders/presentation/screens/widgets/Items_on_orders.dart';
import 'package:nylon/features/orders/presentation/screens/widgets/bottom_on_order.dart';
import 'package:nylon/features/orders/presentation/screens/widgets/view_addres_details.dart';

class OrderDetails extends StatelessWidget {
  OrderDetails({super.key});
  final ControllerOrder _controller = Get.find();

  /// نظّف HTML من النص مع تحويل <br> لأسطر جديدة
  String normalizeHtml(String? html) {
    if (html == null || html.isEmpty) return '';
    String s = html;

    // استبدال جميع أشكال الـ <br> بسطر جديد
    s = s.replaceAll(
        RegExp(r'(<br\s*/?>|\r\n|\r|\n)', caseSensitive: false), '\n');

    // إزالة أي وسوم HTML أخرى
    s = s.replaceAll(RegExp(r'<[^>]+>'), '');

    // فك بعض الكيانات الشائعة
    s = s
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");

    // تنظيف المسافات الزائدة على أطراف كل سطر
    s = s.split('\n').map((e) => e.trim()).join('\n');

    // إزالة الأسطر الفارغة المتتابعة
    s = s.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return s.trim();
  }

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
              colorBorder: AppColors.primaryColor,
            ),
            BottomOnOrder(
              title: '104'.tr,
              onTap: () {
                _controller.getNameAndModelList();
                Get.toNamed(NamePages.pSendComplaints);
              },
              textColor: AppColors.colorRed,
              colorBorder: AppColors.colorRed,
            ),
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
                      // المنتجات
                      ItemsMyOrdersWidget(
                        products:
                            controller.oneOrderModel!.data!.products ?? [],
                      ),
                      SizedBox(height: boxSize.maxHeight * 0.02),

                      // العنوان
                      AddressShippingDetailsOrder(
                        orderData: controller.oneOrderModel!.data!,
                      ),
                      SizedBox(height: boxSize.maxHeight * 0.02),

                      // الفاتورة (إجماليات) — بدون استخدام invoiceRow لتفادي تعارض الأنواع
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
                            final item =
                                controller.oneOrderModel!.data!.totalData![i];
                            final String title = item.title?.toString() ?? '';
                            final String priceText =
                                item.text?.toString() ?? '';

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  // العنوان
                                  Expanded(
                                    child: Text(
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.colorTextBlckNew,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // السعر + أيقونة الريال
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        priceText, // نخليه String صراحة
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                                        height: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: boxSize.maxHeight * 0.02),

                      // حالة الطلب + الـ history
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'order_status'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...?controller.oneOrderModel?.data?.histories
                                ?.map((history) {
                              final rawStatus = history.status ?? '';
                              final status = rawStatus.trim();
                              final rawDate = history.dateAdded ?? '';
                              final comment = normalizeHtml(history.comment);

                              Color statusColor;
                              if (status.contains("مكتمل")) {
                                statusColor = Colors.green;
                              } else if (status.contains("جاري") ||
                                  status.contains("قيد")) {
                                statusColor = Colors.orange;
                              } else if (status.contains("Canceled") ||
                                  status.contains("ملغي")) {
                                statusColor = Colors.redAccent;
                              } else {
                                statusColor = Colors.blueGrey;
                              }

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // مؤشر دائري للحالة
                                    Container(
                                      margin: const EdgeInsets.only(top: 6),
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: statusColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // كارت التفاصيل
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color:
                                                statusColor.withOpacity(0.35),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.08),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // التاريخ
                                            Text(
                                              "🗓 التاريخ: $rawDate",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              strutStyle: const StrutStyle(
                                                height: 1.25,
                                                forceStrutHeight: true,
                                              ),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                                height: 1.25,
                                              ),
                                            ),
                                            const SizedBox(height: 4),

                                            // الحالة
                                            Text(
                                              "✅ الحالة: $status",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: statusColor,
                                                fontSize: 13,
                                              ),
                                            ),

                                            // الملاحظة (منظّفة من HTML وتدعم أسطر جديدة)
                                            if (comment.isNotEmpty) ...[
                                              const SizedBox(height: 6),
                                              Text(
                                                "📝 ملاحظة:\n$comment",
                                                textDirection:
                                                    TextDirection.rtl,
                                                softWrap: true,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  height:
                                                      1.4, // تباعد مريح بين السطور
                                                ),
                                              ),
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
