// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/address/fild_addess.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/core/widgets/primary_button.dart';
import 'package:nylon/features/profile/presentation/controller/controller_user.dart';

class Myprofile extends StatefulWidget {
  const Myprofile({super.key});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  final ControllerUser _controllerUser = Get.put(ControllerUser());
  var x = TextEditingController();
  @override
  void initState() {
    _controllerUser.getUserById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fullAppBackgroundColor,
      appBar: customAppBarTow(title: 'title'),
      body: GetBuilder<ControllerUser>(
          init: ControllerUser(),
          builder: (controller) {
            return HandlingDataView(
              statusRequest: controller.statusRequestGetUser!,
              widget: GetBuilder<ControllerUser>(builder: (controller) {
                return ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text('86'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.black)),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: TextFildAddess(
                              label: '87'.tr,
                              valid: (value) => null,
                              textInputType: TextInputType.name,
                              controller: controller.cFirstName),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: TextFildAddess(
                              label: '88'.tr,
                              valid: (value) => null,
                              textInputType: TextInputType.name,
                              controller: controller.cLastName),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Center(
                      child: controller.statusRequest == StatusRequest.loading
                          ? CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            )
                          : PrimaryButton(
                              height: 48,
                              onTap: () {
                                controller.updataUserData();
                              },
                              label: 'حفظ التعديلات'.tr),
                    ),
                  ],
                );
              }),
              onRefresh: () {
                controller.getUserById();
              },
            );
          }),
    );
  }
}
