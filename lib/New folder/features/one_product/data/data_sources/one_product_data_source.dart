
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/url/url_api.dart';

abstract class OneProductDataSource {
Future<Either<StatusRequest,Map>>getOneProduct({required String idProduct});
}



class OneProductDataSourceImpl implements OneProductDataSource {
  final Method _method;
  OneProductDataSourceImpl(this._method);
 final MyServices _myServices = Get.find();
 
  @override
  Future<Either<StatusRequest, Map>> getOneProduct({required String idProduct}) async{
   var response = await _method.postData(
    url: '${AppApi.urlGetOneProduct}${_myServices.sharedPreferences.getString('token')}${_myServices.getLanguageCode()}', 
    data:{
      'product_id':idProduct,
    });
    return response.fold((failure){
      return left(failure);
    },(data){
      return Right(data);
    });
  }




}