import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/address/container_my_address.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/features/addresses/presentation/controller/adreess_controller.dart';

class MyAddresses extends StatefulWidget {
  const MyAddresses({super.key});

  @override
  State<MyAddresses> createState() => _MyAddressesState();
}

class _MyAddressesState extends State<MyAddresses> {
  final ControllerAddress _controller = Get.put(ControllerAddress());
  @override
  void initState() {
    _controller.getAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // floatingActionButton:

        // GetBuilder<ControllerAddress>(
        //   builder: (_controller) {
        //     return
        //     _controller.statusRequestgetAddress== StatusRequest.success ||
        //      _controller.statusRequestgetAddress==StatusRequest.empty ?
        //      InkWell(
        //       onTap: (){
        //         MyServices _myServices = Get.find();
        //     _myServices.sharedPreferences.clear();
        //     Get.offAllNamed(NamePages.pFirst);
        //       print('ss');
        //       },
        //       child: Container(
        //          padding: const EdgeInsets.all(16),
        //             decoration: BoxDecoration(

        //               borderRadius: BorderRadius.circular(100)
        //             ),
        //             child: SvgPicture.asset('images/locationIcon.svg',width: 70,),
        //             ),
        //     ):const SizedBox.shrink();
        //   }
        // ),
        appBar: customAppBarTow(title: '84'.tr),
        body: GetBuilder<ControllerAddress>(builder: (controller) {
          return controller.statusRequestgetAddress == StatusRequest.empty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('لم تقم با اضافة عنوان حتي الان ',
                          style: Theme.of(context).textTheme.bodySmall),
                      // ignore: prefer_const_constructors
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(NamePages.pAddAddress);
                        },
                        child: Text(
                          'اضافه الان ',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.primaryColor),
                        ),
                      )
                    ],
                  ),
                )
              : HandlingDataView(
                  statusRequest: controller.statusRequestgetAddress!,
                  widget: ListView(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(NamePages.pAddAddress, arguments: null);
                          controller.argumentsUpdateAddress();
                        },
                        child: Container(
                          height: 70,
                          width: double.infinity,
                          color: AppColors.primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add,
                                  size: 24,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text('85'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ListView.separated(
                          padding: const EdgeInsets.all(12),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, i) => SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                          itemCount:
                              controller.addressModel?.data!.address!.length ??
                                  0,
                          itemBuilder: (context, i) {
                            return ContainerMyAddresses(
                              address:
                                  controller.addressModel!.data!.address![i],
                            );
                          }),
                    ],
                  ),
                  onRefresh: () {
                    controller.getAddress();
                  },
                );
        }));
  }
}
