  import 'package:dartz/dartz.dart';
  import 'package:get/get.dart';
  import 'package:nylon/core/function/method_GPUD.dart';
  import 'package:nylon/core/function/status_request.dart';
  import 'package:nylon/core/services/services.dart';
  import 'package:nylon/core/url/url_api.dart';

  abstract class BalanceDataSource {
    Future<Either<StatusRequest, Map>> getBalace();
    Future<Either<StatusRequest, Map>> addBalace({required String credit});
    Future<Either<StatusRequest, Map>> getProductsBalace();
    Future<Either<StatusRequest, Map>> addOrderBalace();
    Future<Either<StatusRequest, Map>> sendDataUser({required Map data});
  }

  class BalanceDataSourceImpl implements BalanceDataSource {
    final Method _method;
    BalanceDataSourceImpl(this._method);
    final MyServices _myServices = Get.find();
    @override
    Future<Either<StatusRequest, Map>> getBalace() async {
      var respnse = await _method.postData(
          url:
              '${AppApi.urlGetBalance}${_myServices.sharedPreferences.getString('token')}',
          data: {
            'customer_id': _myServices.sharedPreferences.getString('UserId')
          });
      return respnse.fold((failure) {
        return left(failure);
      }, (data) {
        return right(data);
      });
    }

    Future<Either<StatusRequest, Map<String, dynamic>>> getPaymentMethods(
        String token) async {
      final url = "${AppApi.getPaymentUrl}$token";
      return await _method.getData(url: url);
    }


    @override
    Future<Either<StatusRequest, Map<String, dynamic>>> sendSelectedPaymentMethod(
        Map<String, dynamic> data) async {
      final url =
          "${AppApi.selectPaymentUrl}${_myServices.sharedPreferences.getString('token')}";
      return (await _method.postData(url: url, data: data))
          .map((r) => Map<String, dynamic>.from(r));
    }

    @override
    Future<Either<StatusRequest, Map<String, dynamic>>> getInvoiceUrl(
        String confirmUrl) async {
      return await _method.getData(url: confirmUrl);
    }

    //
    @override
    Future<Either<StatusRequest, Map>> addBalace({required String credit}) async {
      var respnse = await _method.postData(
          url:
              '${AppApi.urlAddBalance}${_myServices.sharedPreferences.getString('token')}',
          data: {'add_credit': credit});
      return respnse.fold((failure) {
        return left(failure);
      }, (data) {
        return right(data);
      });
    }

    @override
    Future<Either<StatusRequest, Map>> getProductsBalace() async {
      var respnse = await _method.postData(
          url:
              '${AppApi.urlGetProductsBalace}${_myServices.sharedPreferences.getString('token')}',
          data: {});
      return respnse.fold((failure) {
        return left(failure);
      }, (data) {
        return right(data);
      });
    }

    @override
    Future<Either<StatusRequest, Map>> addOrderBalace() async {
      var respnse = await _method.postData(
          url:
              '${AppApi.urlAddOrderBalace}${_myServices.sharedPreferences.getString('token')}',
          data: {});
      return respnse.fold((failure) {
        return left(failure);
      }, (data) {
        return right(data);
      });
    }

    @override
    Future<Either<StatusRequest, Map>> sendDataUser({required Map data}) async {
      print(data);
      var respnse = await _method.postData(
          url:
              '${AppApi.urlSelectIdAddressnOrder}${_myServices.sharedPreferences.getString('token')}',
          data: data);
      return respnse.fold((failure) {
        return left(failure);
      }, (data) {
        return right(data);
      });
    }

    @override
    Future<Either<StatusRequest, Map>> sendCustomerDataToFastCheckout(
        Map<String, dynamic> data) async {
      var response = await _method.postData(
        url:
            '${AppApi.urlSelectIdAddressnOrder}${_myServices.sharedPreferences.getString("token")}',
        data: data,
      );
      return response.fold((failure) {
        return left(failure);
      }, (data) {
        return right(data);
      });
    }
  }
