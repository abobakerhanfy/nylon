import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/balance/presentation/controller/controller_balance.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/button_on_cart.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/features/orders/presentation/screens/send_complaints.dart';

// ignore: must_be_immutable
class ViewBalance extends StatelessWidget {
  ViewBalance({super.key});
  var x = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: customAppBarTow(title: '123'.tr),
      body: GetBuilder<ControllerBalance>(builder: (controller) {
        return Center(
          child: HandlingDataView(
            statusRequest: controller.statusRequestgetBalance!,
            widget: GetBuilder<ControllerBalance>(builder: (controller) {
              return ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  WidgetViewBalanceUseer(
                      balance: controller.getBalanceModel!.balance),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const WidgetSelectBalance(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Text(
                          '128'.tr,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[400],
                                  ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.borderBlack28, width: 1),
                          ),
                          child: FildSendComplaints(
                              backGroundColor: Colors.white,
                              hint: '129'.tr,
                              enabled: true,
                              maxLines: 6,
                              controller: x),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        controller.statusRequestAddBal == StatusRequest.loading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              )
                            : ButtonOnCart(
                                width: double.infinity,
                                label: '123'.tr,
                                onTap: () {
                                  controller.addBalace();
                                }),
                      ],
                    ),
                  ),
                ],
              );
            }),
            onRefresh: () {
              controller.getBalace();
            },
          ),
        );
      }),
    );
  }
}

class WidgetViewBalanceUseer extends StatelessWidget {
  const WidgetViewBalanceUseer({super.key, required this.balance});
  final int balance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            25,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryColor, AppColors.colorBalanse],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '124'.tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$balance',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                      ),
                ),
                const SizedBox(width: 4),
                Image.asset(
                  "images/riyalsymbol_compressed.png",
                  height: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetSelectBalance extends StatelessWidget {
  const WidgetSelectBalance({
    super.key,
  });

  static List<String> balanceList = List.generate(
      (2000 - 50) ~/ 50 + 1, // عدد العناصر في القائمة
      (index) => (50 + index * 50).toString());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerBalance>(builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.credit != null) ...{
            Text(
              '125'.tr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[400],
                  ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: TextFormField(
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    fillColor: AppColors.primaryColor,
                    filled: true,
                    hintText: controller.credit != null
                        ? '${controller.credit} ${'126'.tr}'
                        : '',
                    hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    border: InputBorder.none,
                  ),
                  cursorHeight: 25,
                ),
              ),
            ),
          },
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Text(
            '127'.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[400],
                ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            alignment: Alignment.center,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, i) => const SizedBox(
                width: 20,
              ),
              itemCount: balanceList.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    controller.selectCredit(value: balanceList[i]);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: AppColors.borderBlack28, width: 1),
                      color: controller.credit == balanceList[i]
                          ? AppColors.primaryColor
                          : Colors.white,
                    ),
                    child: Text(
                      balanceList[i],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: controller.credit == balanceList[i]
                              ? Colors.white
                              : Colors.grey[500],
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
