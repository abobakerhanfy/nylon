// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/static/static_images.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/features/orders/presentation/controller/controller_order.dart';
import 'package:nylon/features/orders/presentation/screens/widgets/bottom_on_order.dart';

class ViewDetailsOrderReturned extends StatelessWidget {
  const ViewDetailsOrderReturned({super.key});
  String formatDate(String? dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString!);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      print(e.toString());
      print('ssssssssserror');
      return 'null';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        color: Colors.white,
        margin: const EdgeInsets.all(10),
        child: BottomOnOrder(
            title: '122'.tr,
            onTap: () {},
            textColor: AppColors.colorTextBlckNew,
            colorBorder: AppColors.primaryColor),
      ),
      appBar: customAppBarTow(title: '102'.tr),
      body: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: LayoutBuilder(
          builder: (context, boxSize) {
            return GetBuilder<ControllerOrder>(builder: (controller) {
              return controller.statusRequestOneOrderRet == StatusRequest.empty
                  ? const Center(child: Text("لاتوجد بيانات لعرضها "))
                  : HandlingDataView(
                      statusRequest: controller.statusRequestOneOrderRet!,
                      widget:
                          GetBuilder<ControllerOrder>(builder: (controller) {
                        return ListView(
                          children: [
                            Text(
                              'تفاصيل الارجاع  :',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppColors.textBlack),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'حاله الطلب'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.colorTexthint),
                                ),
                                Text(
                                  controller.oneOrderReturn!.data!.first
                                          .orderdata!.status! ??
                                      '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppColors.colorTextNew,
                                          fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '100'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.colorTexthint),
                                ),
                                Text(
                                  '#${controller.oneOrderReturn!.data!.first.orderdata!.orderId! ?? ''}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppColors.colorTextNew,
                                          fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '101'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.colorTexthint),
                                ),
                                if (controller.oneOrderReturn!.data!.first
                                            .orderdata!.dateAdded !=
                                        null &&
                                    controller.oneOrderReturn!.data!.first
                                        .orderdata!.dateAdded!.isNotEmpty)
                                  Text(
                                    formatDate(controller.oneOrderReturn!.data!
                                        .first.orderdata!.dateAdded!),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: AppColors.colorTextNew,
                                            fontWeight: FontWeight.w500),
                                  )
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Divider(
                              height: 0.5,
                              thickness: 0.5,
                              color: Colors.black26,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              'معلومات عن المنتج :',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppColors.textBlack),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'اسم المنتج '.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.colorTexthint),
                                ),
                                Text(
                                  controller.oneOrderReturn!.data!.first
                                      .orderdata!.product!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppColors.colorTextNew,
                                          fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            if (controller.oneOrderReturn!.data!.first
                                        .orderdata!.model !=
                                    null &&
                                controller.oneOrderReturn!.data!.first
                                    .orderdata!.model!.isNotEmpty) ...{
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'النوع '.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.colorTexthint),
                                  ),
                                  Text(
                                    controller.oneOrderReturn!.data!.first
                                        .orderdata!.model!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: AppColors.colorTextNew,
                                            fontWeight: FontWeight.w500),
                                  )
                                ],
                              )
                            },
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'الكمية'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.colorTexthint),
                                ),
                                Text(
                                  controller.oneOrderReturn!.data!.first
                                      .orderdata!.quantity!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppColors.colorTextNew,
                                          fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'حاله المنتج '.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.colorTexthint),
                                ),
                                Text(
                                  controller.oneOrderReturn!.data!.first
                                              .orderdata!.opened ==
                                          0
                                      ? 'غير مفتوح '
                                      : 'مفتوح ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppColors.colorTextNew,
                                          fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Divider(
                              height: 0.5,
                              thickness: 0.5,
                              color: Colors.black26,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              'سبب الارجاع  :',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppColors.textBlack),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  ' السبب : '.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.colorTexthint),
                                ),
                                Text(
                                  controller.oneOrderReturn!.data!.first
                                          .orderdata!.reason! ??
                                      '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppColors.colorRed,
                                          fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  ' رد الشركة : '.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.colorTexthint),
                                ),
                                Text(
                                  controller.oneOrderReturn!.data!.first
                                          .orderdata!.action ??
                                      '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppColors.colorTextNew,
                                          fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' ملاحظات : '.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.colorTexthint),
                                ),
                                Expanded(
                                  child: Text(
                                    controller.oneOrderReturn!.data!.first
                                            .orderdata!.comment ??
                                        '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.colorTextNew,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Divider(
                              height: 0.5,
                              thickness: 0.5,
                              color: Colors.black26,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              ' تفاصيل الرد على الطلب  :',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppColors.textBlack),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ListView.separated(
                              //${historyItem.dateAdded}",
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, i) => const SizedBox(
                                height: 10,
                              ),
                              itemCount: controller.oneOrderReturn!.data!.first
                                      .history!.length ??
                                  0,
                              itemBuilder: (context, i) {
                                var historyItem = controller
                                    .oneOrderReturn!.data!.first.history![i];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // عرض صورة المستخدم
                                      CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.white,
                                          child: Image.asset(
                                            StaticAppImages.imageLogo,
                                            fit: BoxFit.fill,
                                          )),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'ماتجر نايلون',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Row(
                                                  children: [
                                                    // تنسيق التاريخ مع الأيقونة
                                                    Text(
                                                      formatDate(historyItem
                                                          .dateAdded),
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    const Icon(
                                                      Icons
                                                          .access_time, // أيقونة الوقت
                                                      color: Colors.grey,
                                                      size: 14,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            // عرض النجوم

                                            const SizedBox(height: 4),
                                            // تعليق المستخدم
                                            Text(
                                              historyItem.comment! ?? '',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )

                            //  Divider(height: 0.5,thickness: 0.5,color: Colors.black26,)
                          ],
                        );
                      }),
                      onRefresh: () {
                        //_controller.getOneOrderReturn(idOrder: idOrder);
                      },
                    );
            });
          },
        ),
      ),
    );
  }
}
/*
      ItemsMyOrdersWidget(products: [],),
                 SizedBox(height: boxSize.maxHeight*0.02,),
                 AddressShippingDetailsOrder(orderData:orderData),
                  SizedBox(height: boxSize.maxHeight*0.02,),
                  const ContaineronOrderInvoice(),
                  //'token'lastTokenDate',
                  Text('Test التاريخ'),
                  Text('${_myServices.sharedPreferences.getString('lastTokenDate')}'),
                  Text('Test'),
                  Text('${_myServices.sharedPreferences.getString('token')}'),
*/
