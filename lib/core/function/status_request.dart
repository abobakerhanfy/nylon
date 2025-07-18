// ignore_for_file: unused_local_variable

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/snack_bar.dart';
import 'package:nylon/core/widgets/login/dialog.dart';
import 'package:nylon/core/widgets/primary_button.dart';

enum StatusRequest {
  loading,
  success,
  failure,
  serverFailure,
  offLienFailure,
  internetFailure,
  unauthorized,
  badRequest,
  forbidden,
  notFound,
  empty,
}

StatusRequest handleStatusCode(
  int statusCode,
) {
  switch (statusCode) {
    case 200:
    case 201:
      return StatusRequest.success;
    case 400:
      return StatusRequest.badRequest;

    case 401:
      return StatusRequest.unauthorized;

    case 403:
      return StatusRequest.forbidden;

    case 404:
      return StatusRequest.notFound;

    case 500:
    default:
      return StatusRequest.serverFailure;
  }
}

void handleStatusRequestInput(StatusRequest statusRequest) {
  String errorMessage;

  switch (statusRequest) {
    case StatusRequest.serverFailure:
      errorMessage = '151'.tr;
      break;
    case StatusRequest.internetFailure:
      errorMessage = '152'.tr;
      break;
    case StatusRequest.offLienFailure:
      errorMessage = '153'.tr;
      break;
    case StatusRequest.unauthorized:
      errorMessage = '156'.tr;
      break;
    case StatusRequest.notFound:
      errorMessage = '156'.tr;
      break;

    case StatusRequest.badRequest:
      errorMessage = '154'.tr;
      break;

    case StatusRequest.failure:
      errorMessage = '154'.tr;
      break;
    default:
      errorMessage = '158'.tr;
  }

  if (statusRequest != StatusRequest.success) {
    showSnackBar(errorMessage);
  }
}

void newHandleStatusRequestInput(StatusRequest statusRequest) {
  String errorMessage;

  switch (statusRequest) {
    case StatusRequest.serverFailure:
      errorMessage = 'فشل الاتصال بالخادم';
      break;
    case StatusRequest.internetFailure:
      errorMessage = 'لا يوجد اتصال بالإنترنت!';
      break;
    case StatusRequest.offLienFailure:
      errorMessage = 'حدث خطأ ما. أعد المحاولة من فضلك!';
      break;
    case StatusRequest.unauthorized:
      errorMessage = '! غير مصرح لك ';
      break;
    case StatusRequest.notFound:
      errorMessage = ' notFound ! غير مصرح لك ';
      break;

    case StatusRequest.failure:
      errorMessage = 'حدث خطأ ما. أعد المحاولة من فضلك!';
      break;
    case StatusRequest.badRequest:
      errorMessage = 'فشل الاتصال بالخادم';
      break;
    default:
      errorMessage = 'حدث خطأ غير معروف';
  }

  if (statusRequest != StatusRequest.success) {
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
        title: errorMessage,
        dialogType: DialogType.error);
  }
}
