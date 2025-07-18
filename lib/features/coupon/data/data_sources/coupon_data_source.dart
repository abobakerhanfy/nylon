import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/url/url_api.dart';

abstract class CouponDataSource {
  Future<Either<StatusRequest, Map>> getAllCoupon();
  Future<Either<StatusRequest, Map>> applyCoupon({required String code});
  Future<Either<StatusRequest, Map>> removeCoupon({required String code});
}

class CouponDataSourceImpl implements CouponDataSource {
  final Method _method;
  CouponDataSourceImpl(this._method);
  final MyServices _myServices = Get.find();
  @override
  Future<Either<StatusRequest, Map>> getAllCoupon() async {
    var response = await _method.getData(
        url:
            '${AppApi.urlgetCouponUrl}${_myServices.sharedPreferences.getString('token')}${_myServices.getLanguageCode()}');
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> applyCoupon({required String code}) async {
    var response = await _method.postData(
        url:
            '${AppApi.urlApplyCoupon}${_myServices.sharedPreferences.getString('token')}',
        data: {'coupon': code});
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> removeCoupon(
      {required String code}) async {
    var response = await _method.postData(
        url:
            '${AppApi.urlRemoveCoupon}${_myServices.sharedPreferences.getString('token')}',
        data: {'coupon': code});
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }
}
