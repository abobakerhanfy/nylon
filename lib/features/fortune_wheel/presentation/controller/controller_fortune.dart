import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/login/dialog.dart';
import 'package:nylon/core/widgets/primary_button.dart';
import 'package:nylon/features/fortune_wheel/data/data_sources/fortune_wheel_data_source.dart';
import 'package:nylon/features/fortune_wheel/data/models/reward_model.dart';
import 'package:nylon/features/fortune_wheel/presentation/screens/fortune_wheel_screen.dart';
import 'dart:math';

import 'package:intl/intl.dart';

abstract class FortuneController extends GetxController {
  getRewards();
  addReward({required String rewardId});
}

class ControllerFortune extends FortuneController {
  final FortuneWheelDataSourceImpl _dataSourceImpl =
      FortuneWheelDataSourceImpl(Get.find());
  StatusRequest? statusRequestAddF, statusRequestGet;
  RewardModel? rewardModel;
  final MyServices _myServices = Get.find();

  Future<void> checkAndRunForToday() async {
    String lastRunDate =
        _myServices.sharedPreferences.getString('lastRunDate') ?? '';
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // if (lastRunDate != currentDate) {
    await getRewards();
    await _myServices.sharedPreferences.setString('lastRunDate', currentDate);
    // }
  }

  @override
  addReward({required String rewardId}) async {
    print(rewardId);
    statusRequestAddF = StatusRequest.loading;
    update();
    var response = await _dataSourceImpl.addReward(rewardId: rewardId);
    return response.fold(
      (failure) {
        statusRequestAddF = failure;
        update();
        newHandleStatusRequestInput(statusRequestAddF!);
      },
      (data) {
        print(data);
        print('9999999999999999999999999999999999999999999');
        if (data.isNotEmpty && data.containsKey("success")) {
          statusRequestAddF = StatusRequest.success;
          update();
          newCustomDialog(
              body: SizedBox(
                height: 40,
                child: PrimaryButton(
                  label: 'موافق',
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
              title: "تم اضافة المكافاء بنجاح ",
              dialogType: DialogType.success);
        } else {
          newCustomDialog(
              body: SizedBox(
                height: 40,
                child: PrimaryButton(
                  label: 'موافق',
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
              title: data["error"],
              dialogType: DialogType.error);
          statusRequestAddF = StatusRequest.failure;
          update();
        }
      },
    );
  }

  @override
  getRewards() async {
    try {
      print("🚀 Calling getRewards...");
      statusRequestGet = StatusRequest.loading;
      update();

      var response = await _dataSourceImpl.getRewards();

      return response.fold(
        (failure) {
          print("❌ Failed to load rewards: $failure");
          statusRequestGet = failure;
          update();
        },
        (data) {
          print("✅ API Response: $data");

          if (data.isNotEmpty && data.containsKey("data")) {
            rewardModel = RewardModel.fromJson(Map<String, dynamic>.from(data));
            print("🎁 Rewards loaded: ${rewardModel?.data?.length ?? 0}");

            if (rewardModel?.data != null && rewardModel!.data!.isNotEmpty) {
              // اختار هدية عشوائية
              var randomReward = rewardModel!
                  .data![Random().nextInt(rewardModel!.data!.length)];
              print(
                  "🎯 Randomly selected reward: ${randomReward.name} (${randomReward.value})");

              // هنا ممكن مثلا تخزنها في متغير تعرضه في ال UI
              // selectedReward = randomReward;

              // بعدها اظهر شاشة العجلة
              showDialogFortune();
            }
            statusRequestGet = StatusRequest.success;
          } else {
            print("⚠️ No rewards data found");
            statusRequestGet = StatusRequest.empty;
          }
          update();
        },
      );
    } catch (e) {
      statusRequestGet = StatusRequest.failure;
      update();
      print("❌ Exception in getRewards: $e");
    }
  }

  void showDialogFortune() {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.7),
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.90,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: GetBuilder<ControllerFortune>(
                      builder: (_) => const FortuneWheelPage(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
