// ignore_for_file: unused_field

import 'package:get/get.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/features/fortune_wheel/presentation/controller/controller_fortune.dart';
import 'package:nylon/features/home/data/data_sources/home_data_source.dart';
import 'package:nylon/features/home/data/models/new_model_test.dart';

abstract class HomeController extends GetxController {
  Future getData();
  Future getLogo();
}

class ControllerHome extends HomeController {
  final HomeDataSourceImpl _sourceImpl = HomeDataSourceImpl(Get.put(Method()));
  StatusRequest? statusRequest;
  StatusRequest statusRequestLogo = StatusRequest.loading;
  NewModelHome? dataHome;
  String logo = '';
  @override
  getData() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await _sourceImpl.getData();
    return response.fold((failure) {
      statusRequest = failure;
      print(statusRequest);
      update();
    }, (data) {
      dataHome = data;

      statusRequest = StatusRequest.success;
      update();
    });
  }

  @override
  void onInit() {
    getData();
    getLogo();
    super.onInit();
  }

  @override
  void onReady() async {
    print('sssssssssssssssssssssssssssssssssssssecods 10');
    await Future.delayed(const Duration(seconds: 10));
    ControllerFortune controllerFortune = Get.put(ControllerFortune());
    controllerFortune.checkAndRunForToday();
    print('sssssssssssssssssssssssssssssssssssssecods 10 fainsh');
    super.onReady();
  }

  @override
  Future getLogo() async {
    var response = await _sourceImpl.getLogo();
    return response.fold((failure) {
      statusRequestLogo = failure;
      update();
    }, (data) {
      if (data.containsKey("logo")) {
        logo = data["logo"];
        print(logo);
        print('llllllllllllllllllllllllllllllllllllllllllllllllllllllllllogo');
        statusRequestLogo = StatusRequest.success;
        update();
      } else {
        statusRequestLogo = StatusRequest.failure;
        print('logo error rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
        update();
      }
    });
  }
}
