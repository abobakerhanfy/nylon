import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/features/coupon/data/models/coupon_model.dart';
import 'package:nylon/features/coupon/presentation/controller/controller_coupon.dart';
import 'package:nylon/features/coupon/presentation/screens/widgets/text_with_riyalsymbol.dart';
import 'package:nylon/features/coupon/presentation/screens/widgets/container_copy_past_text.dart';

class MyCoupons extends StatelessWidget {
  const MyCoupons({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: customAppBarTow(title: '130'.tr),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GetBuilder<ControllerCoupon>(
            init: ControllerCoupon(),
            builder: (controller) {
              return controller.statusRequest == StatusRequest.empty
                  ? const Center(
                      child: Text("لاتوجد كوبنات خصم  "),
                    )
                  : HandlingDataView(
                      statusRequest: controller.statusRequest!,
                      widget:
                          GetBuilder<ControllerCoupon>(builder: (controller) {
                        return ListView(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.30,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        'images/caponImage.png',
                                      ),
                                      fit: BoxFit.contain)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, i) => const SizedBox(
                                height: 12,
                              ),
                              itemCount: controller.coupos!.coupon!.length,
                              itemBuilder: (context, i) {
                                return CouponsWidget(
                                  coupon: controller.coupos!.coupon![i],
                                );
                              },
                            )
                          ],
                        );
                      }),
                      onRefresh: () {
                        controller.getAllCoupon();
                      },
                    );
            }),
      ),
    );
  }
}

class CouponsWidget extends StatelessWidget {
  final Coupon coupon;
  CouponsWidget({
    super.key,
    required this.coupon,
  });
  final MyServices _myServices = Get.find();
  String formatDate(String dateString) {
    var languageCode = _myServices.sharedPreferences.getString('Lang');
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('d MMMM yyyy', languageCode).format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (coupon.type == 'Percentage') ...[
            if (_myServices.sharedPreferences.getString('Lang') == 'ar')
              Text(
                'خصم ${double.parse(coupon.discount!).toStringAsFixed(1)}% لأول طلبية',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.textColor1,
                      fontWeight: FontWeight.w600,
                    ),
              )
            else
              Text(
                'Discount of ${double.parse(coupon.discount!).toStringAsFixed(1)}% for the first order',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.textColor1,
                      fontWeight: FontWeight.w600,
                    ),
              ),
          ] else if (coupon.type == "FixedPrice") ...[
            if (_myServices.sharedPreferences.getString('Lang') == 'ar')
              TextWithRiyalIcon(
                textBefore: 'خصم ',
                amount: double.parse(coupon.discount!),
                textAfter: ' لأول طلبية',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.textColor1,
                      fontWeight: FontWeight.w600,
                    ),
              )
            else
              TextWithRiyalIcon(
                textBefore: 'Discount of ',
                amount: double.parse(coupon.discount!),
                textAfter: ' for the first order',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.textColor1,
                      fontWeight: FontWeight.w600,
                    ),
              ),
          ],
          if (coupon.shipping == "Free Shipping") ...[
            const SizedBox(height: 6),
            Text(
              '195'.tr,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.textColor1,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            '${'193'.tr} ${formatDate(coupon.couponEnd!)}  ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.greyColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 20),
          ContainerTextCpoyPast(
            text: '131'.tr,
            textTow: coupon.code ?? '',
          )
        ],
      ),
    );
  }
}
