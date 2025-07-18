import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:intl/intl.dart';
import 'package:nylon/features/shipping/presentation/controller/controller_shipping.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackTheShipmentDetails extends StatelessWidget {
  const TrackTheShipmentDetails({super.key});
  String formatDate(String? dateString) {
    try {
      MyServices myServices = Get.find();
      var lang = myServices.sharedPreferences.getString('Lang');
      dateString = dateString?.replaceAll('/', '-');

      DateTime dateTime = DateTime.parse(dateString!);
      return DateFormat('EEEE, d MMMM', lang).format(dateTime);
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  // هنا أضفناها
  void openLink(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: customAppBarTow(title: ' ${'115'.tr} #8728'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GetBuilder<ControllerShipping>(
            init: ControllerShipping(),
            builder: (controller) {
              return ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatDate(controller
                                .trackingShippingData!.data!.dateAdded!),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text(
                                '${'100'.tr} :',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '#${controller.trackingShippingData!.data!.orderId!}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              InkWell(
                                  onTap: () async {
                                    try {
                                      Clipboard.setData(ClipboardData(
                                          text: controller.trackingShippingData!
                                              .data!.orderId!));
                                      ClipboardData? clipboardContent =
                                          await Clipboard.getData('text/plain');
                                      print('${clipboardContent!.text}');
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  },
                                  child: const Icon(
                                    Icons.copy,
                                    size: 16,
                                    color: Colors.black87,
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${'194'.tr} :',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '#${controller.trackingShippingData!.data!.orderTrackId ?? ''}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(width: 5),
                              InkWell(
                                onTap: () async {
                                  await Clipboard.setData(ClipboardData(
                                      text: controller.trackingShippingData!
                                              .data!.orderTrackId ??
                                          ''));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('تم نسخ رقم التتبع'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: const Icon(Icons.copy,
                                    size: 16, color: Colors.black87),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () {
                              final link = controller
                                  .trackingShippingData!.data!.linkSmsa;
                              if (link != null && link.isNotEmpty) {
                                openLink(link);
                              }
                            },
                            child: Text(
                              'تتبع على سمسا 🔗',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.primaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      if (controller.trackingShippingData!.data?.totals !=
                              null &&
                          controller
                              .trackingShippingData!.data!.totals!.isNotEmpty)
                        Text(
                          '${'45'.tr} : ${controller.trackingShippingData!.data?.totals!.firstWhere((total) => total.title == 'الاجمالي').text ?? ''}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                        ),
                    ],
                  ),
                  // const DateANumberATotalOrder(),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          '132'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          '145'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, i) => const SizedBox(
                            height: 8,
                          ),
                      itemCount: controller
                              .trackingShippingData!.data!.histories!.length ??
                          0,
                      itemBuilder: (context, i) {
                        return RowDetailsTrack(
                          title: controller.trackingShippingData!.data!
                                  .histories![i].status ??
                              '',
                          leding: controller.trackingShippingData!.data!
                                  .histories![i].dateAdded ??
                              '',
                          supTitle: controller.trackingShippingData!.data!
                                  .histories![i].comment ??
                              '',
                        );
                      }),

                  //      const SizedBox(height: 20,),
                  //      Row(children: [
                  //      Icon(Icons.check_circle,color: Colors.green[600],),
                  //       const  SizedBox(width: 8,),
                  //       Expanded(
                  // flex: 3,
                  // child: Column(
                  //  crossAxisAlignment: CrossAxisAlignment.start,
                  //  children: [
                  //    Text('141'.tr,style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  //  color: Colors.black,fontSize: 14,fontWeight: FontWeight.w700
                  //      ),),
                  //      const  SizedBox(height: 4,),
                  //  Text('${'115'.tr} #8728',style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  //  color: Colors.black,fontSize: 11,fontWeight: FontWeight.w600
                  //      ),),

                  //  ],
                  // ),
                  //       ),

                  //        Expanded(
                  // flex: 1,
                  //  child: Text('1ss42'.tr,style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  //  color: Colors.green[800],fontSize: 14,fontWeight: FontWeight.w600
                  //       ),),
                  //        ),

                  //     ],),
                  // const SizedBox(height: 20,),
                  //     Container(
                  //       padding: const EdgeInsets.all(20),
                  //       width: MediaQuery.of(context).size.width*0.90,
                  //       decoration: BoxDecoration(
                  // boxShadow: [BoxShadow(color: AppColors.background,spreadRadius: 0.5,blurRadius: 7)],
                  // borderRadius: BorderRadius.circular(12),
                  //       color: Colors.white
                  //       ),
                  //       child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // children: [
                  // Text('89'.tr,style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  //  color: const Color.fromARGB(255, 92, 90, 90),fontSize: 12,fontWeight: FontWeight.w600
                  //       ) ,),
                  //       Padding(
                  //         padding: const EdgeInsets.all(10.0),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //            Text('فيصل بن حمد',style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  //  color: Colors.black,fontSize: 13,fontWeight: FontWeight.w600
                  //       ) ,),
                  //       const SizedBox(height: 10,),
                  //              Text('الرياض : شارع أبوبكر الصديق ',style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  //  color: Colors.black,fontSize: 13,fontWeight: FontWeight.w400
                  //       ) ,),
                  //        const SizedBox(height:16,),
                  //               Text('(+096) 973-757-096',style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  //  color: Colors.black,fontSize: 13,fontWeight: FontWeight.w400
                  //       ) ,),

                  //           ],

                  //         ),
                  //       )

                  //       ],),
                  //     ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 0.90,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.background,
                              spreadRadius: 0.5,
                              blurRadius: 7)
                        ],
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '143'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '144'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.star_border_sharp,
                              size: 30,
                              color: Colors.black54,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Icon(
                              Icons.star_border_sharp,
                              size: 30,
                              color: Colors.black54,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Icon(
                              Icons.star_border_sharp,
                              size: 30,
                              color: Colors.black54,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Icon(
                              Icons.star_border_sharp,
                              size: 30,
                              color: Colors.black54,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Icon(
                              Icons.star_border_sharp,
                              size: 30,
                              color: Colors.black54,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            }),
      ),
    );
  }
}

class RowDetailsTrack extends StatelessWidget {
  final String title;
  String? supTitle;
  final String leding;
  RowDetailsTrack({
    super.key,
    required this.title,
    this.supTitle,
    required this.leding,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle,
          color: Colors.green[600],
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 4,
              ),
              if (supTitle != null && supTitle!.isNotEmpty)
                Text(
                  supTitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w400),
                ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            leding,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }
}

class DateANumberATotalOrder extends StatelessWidget {
  const DateANumberATotalOrder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الخميس, 20 يونيو',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  '${'100'.tr} :',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                const SizedBox(width: 5),
                Text(
                  '#8728',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${'45'.tr} : 102.70',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
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
    );
  }
}
