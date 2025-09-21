
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/url/url_api.dart';

abstract class FavoriteDataSource {
Future<Either<StatusRequest,Map>> getFavorites();
Future<Either<StatusRequest,Map>>addFavorites({required String idProduct});
Future<Either<StatusRequest,Map>>removeFavorites({required String idProduct});


}

class FavoriteDataSourceImpl implements FavoriteDataSource {
  final Method _method;
  FavoriteDataSourceImpl(this._method);
 final MyServices _myServices = Get.find();
  
  @override
  Future<Either<StatusRequest, Map>> addFavorites({required String idProduct})async {
         var respnse = await _method.postData(
    url:'${ AppApi.urlAddFavorites}${_myServices.sharedPreferences.getString('token')}${_myServices.getLanguageCode()}', 
   data: {
    'customer_id':_myServices.sharedPreferences.getString('UserId'),
    'remove':idProduct
    //'6065',
   });
   return respnse.fold((failure){
    return left(failure);
   },(data){
    return right(data);
   });
  }
  
  
  @override
  Future<Either<StatusRequest, Map>> getFavorites()async {
       var respnse = await _method.postData(
    url:'${ AppApi.urlGetFavorites}${_myServices.sharedPreferences.getString('token')}${_myServices.getLanguageCode()}', 
   data: {
    'customer_id':_myServices.sharedPreferences.getString('UserId'),
    //'6065',
   });
   return respnse.fold((failure){
    return left(failure);
   },(data){
    return right(data);
   });
  }
  
  
  @override
  Future<Either<StatusRequest, Map>> removeFavorites({required String idProduct})async {
     var respnse = await _method.postData(
    url:'${ AppApi.urlRemoveFavorites}${_myServices.sharedPreferences.getString('token')}', 
   data: {
    'customer_id':_myServices.sharedPreferences.getString('UserId'),
    'remove':idProduct
   });
   return respnse.fold((failure){
    return left(failure);
   },(data){
    return right(data);
   });
  }
  }