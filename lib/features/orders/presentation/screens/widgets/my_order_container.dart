import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/orders/data/models/get_all_order.dart';
import 'package:nylon/features/orders/presentation/controller/controller_order.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ContainerMyOrder extends StatelessWidget {
  final Order order;
  ContainerMyOrder({
    super.key,
    required this.order,
  });
  final ControllerOrder _controllerOrder = Get.find();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _controllerOrder.getOneOrder(idOrder: order.orderId!);
        Get.toNamed(NamePages.pOrderDetails);
      },
      child: Container(
        width: 384,
        height: 191,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderBlack28, width: 1),
            borderRadius: BorderRadius.circular(20),
            color: Get.theme.scaffoldBackgroundColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                CircularPercentIndicator(
                    radius: 30.0,
                    animation: true,
                    animationDuration: 1200,
                    lineWidth: 4.0,
                    percent: getPercentFromStatus(order.orderStatus),
                    center: SvgPicture.asset(
                      'images/test13.svg',
                      fit: BoxFit.fill,
                      width: 30,
                    ),
                    progressColor: AppColors.primaryColor),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          order.firstname ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: AppColors.colorTextNew,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          order.lastname ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: AppColors.colorTextNew,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    if (order.orderStatus != null &&
                        order.orderStatus!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: AppColors
                              .primaryColor, //getColorFromStatus(order.orderStatus)
                        ),
                        child: Text(
                          order.orderStatus! ?? '',
                          style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                      )
                  ],
                ),
              ],
            ),
            OrderiInformationColumnWidget(
              order: order,
            )
          ],
        ),
      ),
    );
  }

  double getPercentFromStatus(String? status) {
    Map<String, double> statusPercentMap = {
      'إعادة المبلغ': 0.2,
      'إلغاء عكس الطلب': 0.3,
      'انتهاء الوقت': 0.5,
      'بإنتظار التحويل': 0.4,
      'تم التجهيز': 0.6,
      'تم شحن الطلب': 0.8,
      'تم عكس الطلب': 0.7,
      'جاري التجهيز': 0.5,
      'طلبات مفقوده': 0.1,
      'فشل': 0.3,
      'في انتظار التحويل': 0.4,
      'لم يتم الدفع': 0.2,
      'مردود': 0.7,
      'مرفوض': 0.1,
      'معلق': 0.2,
      'مكتمل': 1.0,
      'ملغي': 0.0,
    };

    return statusPercentMap[status] ??
        0.0; // Return 0.0 if status is not found in the map
  }

// Function to return color based on order status
  Color getColorFromStatus(String? status) {
    Map<String, Color> statusColorMap = {
      'إعادة المبلغ': Colors.red,
      'إلغاء عكس الطلب': Colors.orange,
      'انتهاء الوقت': Colors.grey,
      'بإنتظار التحويل': Colors.blue,
      'تم التجهيز': Colors.orange,
      'تم شحن الطلب': Colors.blue,
      'تم عكس الطلب': Colors.green,
      'جاري التجهيز': Colors.yellow,
      'طلبات مفقوده': Colors.purple,
      'فشل': Colors.black,
      'في انتظار التحويل': Colors.blueGrey,
      'لم يتم الدفع': Colors.red,
      'مردود': Colors.green,
      'مرفوض': Colors.grey,
      'معلق': Colors.yellow,
      'مكتمل': Colors.green,
      'ملغي': Colors.red,
    };

    return statusColorMap[status] ?? Colors.grey; // Default color
  }
}

class OrderiInformationColumnWidget extends StatelessWidget {
  final Order order;
  const OrderiInformationColumnWidget({
    super.key,
    required this.order,
  });
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
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // رقم الطلب
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '100'.tr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.colorTexthint,
                    ),
              ),
              Text(
                '#${order.orderId ?? ''}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.colorTextNew,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),

          // التاريخ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '101'.tr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.colorTexthint,
                    ),
              ),
              if (order.dateAdded != null && order.dateAdded!.isNotEmpty)
                Text(
                  formatDate(order.dateAdded!),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.colorTextNew,
                        fontWeight: FontWeight.w500,
                      ),
                ),
            ],
          ),

          // إجمالي الطلب مع رمز الريال كصورة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '45'.tr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.colorTexthint,
                    ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    double.parse(order.total!).toStringAsFixed(2),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.colorTextNew,
                          fontWeight: FontWeight.w500,
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
        ],
      ),
    );
  }
}
