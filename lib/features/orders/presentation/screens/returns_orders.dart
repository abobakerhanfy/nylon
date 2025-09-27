import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/features/orders/presentation/controller/controller_order.dart';

class ReplacementAndReturn extends StatefulWidget {
  const ReplacementAndReturn({super.key});

  @override
  State<ReplacementAndReturn> createState() => _ReplacementAndReturnState();
}

class _ReplacementAndReturnState extends State<ReplacementAndReturn> {
  final ControllerOrder _controller = Get.put(ControllerOrder());
  @override
  void initState() {
    _controller.getReturnOrders();
    super.initState();
  }

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
      backgroundColor: fullAppBackgroundColor,
      appBar: customAppBarTow(title: '120'.tr),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: GetBuilder<ControllerOrder>(builder: (controller) {
          return controller.statusRequestGetReturn == StatusRequest.empty
              ? const Center(
                  child: Text("لاتوجد طلبات "),
                )
              : HandlingDataView(
                  statusRequest: controller.statusRequestGetReturn!,
                  widget: GetBuilder<ControllerOrder>(builder: (controller) {
                    return ListView.separated(
                        separatorBuilder: (context, i) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                        itemCount: controller.ordersReturn!.data!.length ?? 0,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              print(controller.ordersReturn!.data![i].returnId);
                              controller.getOneOrderReturn(
                                  idOrder: controller
                                      .ordersReturn!.data![i].returnId!);
                              Get.toNamed(NamePages.pViewDetailsOrderReturned);

                              //   _controllerOrder.getOneOrder(idOrder: order.orderId!);
                              //
                            },
                            child: Container(
                              width: 384,
                              height: 191,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.borderBlack28, width: 1),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Get.theme.scaffoldBackgroundColor),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 69,
                                        height: 65,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: SvgPicture.asset(
                                          'images/iconReturn.svg',
                                          fit: BoxFit.none,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                controller.ordersReturn!
                                                        .data![i].firstname ??
                                                    '',
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
                                                controller.ordersReturn!
                                                        .data![i].lastname ??
                                                    '',
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
                                          if (controller.ordersReturn!.data![i]
                                                      .returnStatusCode !=
                                                  null &&
                                              controller.ordersReturn!.data![i]
                                                  .returnStatusCode!.isNotEmpty)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: AppColors.colorRed),
                                              child: Text(
                                                controller
                                                        .ordersReturn!
                                                        .data![i]
                                                        .returnStatusCode! ??
                                                    '',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor),
                                              ),
                                            )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '100'.tr,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .colorTexthint),
                                            ),
                                            Text(
                                              '#${controller.ordersReturn!.data![i].orderId ?? ''}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      color: AppColors
                                                          .colorTextNew,
                                                      fontWeight:
                                                          FontWeight.w500),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '101'.tr,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .colorTexthint),
                                            ),
                                            if (controller.ordersReturn!
                                                        .data![i].dateAdded !=
                                                    null &&
                                                controller
                                                    .ordersReturn!
                                                    .data![i]
                                                    .dateAdded!
                                                    .isNotEmpty)
                                              Text(
                                                formatDate(controller
                                                    .ordersReturn!
                                                    .data![i]
                                                    .dateAdded),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                        color: AppColors
                                                            .colorTextNew,
                                                        fontWeight:
                                                            FontWeight.w500),
                                              )
                                          ],
                                        ),
                                        //      Row(
                                        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //  children: [
                                        //  Text('45'.tr,style:Theme.of(context).textTheme.bodySmall?.copyWith(
                                        //    fontWeight: FontWeight.w500,color: AppColors.colorTexthint
                                        //  ),),
                                        //       Text('${double.parse(order.total!).toStringAsFixed(2)} ${'11'.tr}',style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        //  color: AppColors.colorTextNew,fontWeight: FontWeight.w500
                                        //    ),)
                                        // ],),
                                      ],
                                    ),
                                  ),
                                  //  OrderiInformationColumnWidget(order: order,)
                                ],
                              ),
                            ),
                          );
                        });
                  }),
                  onRefresh: () {
                    controller.getReturnOrders();
                  },
                );
        }),
      ),
    );
  }
}
