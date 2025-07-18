
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/url/url_api.dart';

abstract class ShippingDataSource {
Future<Either<StatusRequest,Map>> addAddressShipping({required Map data});
Future<Either<StatusRequest,Map>> getShippingMethods();
Future<Either<StatusRequest,Map>>selectShipping({required String shippingCode});
Future<Either<StatusRequest,Map>> getTrackingshipping({required String idOrder});

}


class ShippingDataSourceImpl implements ShippingDataSource {
  final Method _method;
  ShippingDataSourceImpl(this._method);
    final MyServices _myServices = Get.find();
  @override
  Future<Either<StatusRequest, Map>> addAddressShipping({required Map data})async {
    var response = await _method.postData(
      url:'${AppApi.addAddressShippingUrl}${_myServices.sharedPreferences.getString('token')}',
     data: data);
     print(data);
     return response.fold((failure){
      return left(failure);
     },
     (data){
       return right(data);
     }
     );
  }

  @override
  Future<Either<StatusRequest, Map>> getShippingMethods()async {
   var response = await _method.postData(
   url:'${AppApi.getShippingMethodsUrl}${_myServices.sharedPreferences.getString('token')}',
     data:{});
     return response.fold(
      (failure){
      return left(failure);
     }, (data){
      return right(data);
     });
  }

  @override
  Future<Either<StatusRequest, Map>> selectShipping({required String shippingCode})async {
   var respnse = await _method.postData(
    url:'${AppApi.selectShipping}${_myServices.sharedPreferences.getString('token')}',  
    data: {
      'shipping_method':shippingCode
    });
    print(shippingCode);
    print(respnse);
    return respnse.fold((failure){
      return left(failure);
    },(data){
      return right(data);
    });
  }
  
  @override
  Future<Either<StatusRequest, Map>> getTrackingshipping({required String idOrder})async {
   var response = await _method.postData(
    url: '${AppApi.urlgetTrackingShipping}${_myServices.sharedPreferences.getString('token')}',
     data: {
      // 'order_phone':'966531685654',
      'order_id':idOrder
     });
         return response.fold((failure){
      return left(failure);
    },(data){
      return right(data);
    });
  }



}