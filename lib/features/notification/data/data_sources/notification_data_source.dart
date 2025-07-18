import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/url/url_api.dart';

abstract class NotificationDataSource {
  Future<Either<StatusRequest, Map>> SendTokenNotification(
      {required String token});
}

class NotificationDataSourceImpl implements NotificationDataSource {
  final Method _method;
  NotificationDataSourceImpl(this._method);
  final MyServices _myServices = Get.find();
  @override
  Future<Either<StatusRequest, Map>> SendTokenNotification(
      {required String token}) async {
    var response = await _method.postData(
        url:
            '${AppApi.urladdDeviceToken}${_myServices.sharedPreferences.getString('token')}${_myServices.getLanguageCode()}',
        data: {
          'device_token': token,
        });
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return Right(data);
    });
  }
}
