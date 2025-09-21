import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/url/url_api.dart';

abstract class AddressesDataSource {
  Future<Either<StatusRequest, Map>> addAddress({required Map data});
  Future<Either<StatusRequest, Map>> getAddress();
  Future<Either<StatusRequest, Map>> updateAddress({required Map data});
  Future<Either<StatusRequest, Map>> deleteAddress({required String idAddress});
}

class AddressesDataSourceImpl implements AddressesDataSource {
  final Method _method;
  AddressesDataSourceImpl(this._method);
  final MyServices _myServices = Get.find();

  @override
  Future<Either<StatusRequest, Map>> addAddress({required Map data}) async {
    var respnse = await _method.postData(
        url:
            '${AppApi.urlAddAddress}${_myServices.sharedPreferences.getString('token')}',
        data: data);
    return respnse.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> getAddress() async {
    final token = _myServices.sharedPreferences.getString('token');
    final userId = _myServices.sharedPreferences.getString('UserId');

    if (token == null || userId == null) {
      return left(StatusRequest.failure); // أو custom error
    }

    var response = await _method.postData(
      url: '${AppApi.urlgetCustomerById}$token${_myServices.getLanguageCode()}',
      data: {'customer_id': userId},
    );

    return response.fold((failure) {
      return left(failure);
    }, (data) {
      // فلترة عناوين لو موجودة
      if (data.containsKey("data") &&
          data["data"].containsKey("address") &&
          data["data"]["address"] is List &&
          (data["data"]["address"] as List).isEmpty) {
        print("✅ لا يوجد عناوين حالياً.");
      }

      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> updateAddress({required Map data}) async {
    var response = await _method.postData(
        url:
            '${AppApi.urlUpdataAddress}${_myServices.sharedPreferences.getString('token')}',
        data: data);
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> deleteAddress(
      {required String idAddress}) async {
    var response = await _method.postData(
        url:
            '${AppApi.urlDeleteAddress}${_myServices.sharedPreferences.getString('token')}',
        data: {'address_id': idAddress});
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }
}
