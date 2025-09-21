import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/url/url_api.dart';

abstract class CartDataSource {
  Future<Either<StatusRequest, Map<String, dynamic>>> getCart();
  Future<Either<StatusRequest, Map>> addCart(
      {required String idProduct, required int quantity});
  Future<Either<StatusRequest, Map>> removeCart({required String cartId});
  Future<Either<StatusRequest, Map>> editCartProduct(
      {required String cartId, required int quantity});
}

class CartDataSourceImpl implements CartDataSource {
  final Method _method;
  CartDataSourceImpl(this._method);
  final MyServices _myServices = Get.find();

  @override
  Future<Either<StatusRequest, Map<String, dynamic>>> getCart() async {
    var token = _myServices.sharedPreferences.getString('token');

    if (token == null || token.isEmpty) {
      print('Invalid or missing token');
      return left(StatusRequest.unauthorized);
    }

    print('Token: $token');

    var response = await _method.getData(
      url: '${AppApi.getCartUrl}$token${_myServices.getLanguageCode()}',
    );

    return response.fold(
      (failure) {
        print("Request failed with error: $failure");
        return left(failure);
      },
      (data) {
        if (data.isEmpty) {
          print('Empty or null data received');
          return left(StatusRequest.failure);
        }

        try {
          return right(data);
        } catch (e) {
          print('Error casting data to Map: $e');
          return left(StatusRequest.failure);
        }
      },
    );
  }

  Future<Either<StatusRequest, Map>> clearCart() async {
    var response = await _method.postData(
      url:
          "${AppApi.clearCartUrl}${_myServices.sharedPreferences.getString("token")}",
      data: {},
    );

    return response;
  }

  @override
  Future<Either<StatusRequest, Map>> addCart(
      {required String idProduct, required int quantity}) async {
    print(_myServices.sharedPreferences.getString('token'));
    var response = await _method.postData(
        url:
            '${AppApi.addCartUrl}${_myServices.sharedPreferences.getString('token')}',
        data: {
          'product_id': idProduct,
          'quantity': '$quantity',
        });
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> removeCart(
      {required String cartId}) async {
    var response = await _method.postData(
        url:
            '${AppApi.removeCartUrl}${_myServices.sharedPreferences.getString('token')}',
        data: {'key': cartId});
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> editCartProduct(
      {required String cartId, required int quantity}) async {
    var response = await _method.postData(
        url:
            '${AppApi.editCartUrl}${_myServices.sharedPreferences.getString('token')}${_myServices.getLanguageCode()}',
        data: {'key': cartId, 'quantity': '$quantity'});
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }
}
