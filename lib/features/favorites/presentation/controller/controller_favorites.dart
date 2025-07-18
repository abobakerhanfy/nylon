// ignore_for_file: unnecessary_null_comparison

import 'package:get/get.dart';
import 'package:nylon/core/function/snack_bar.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/features/favorites/data/data_sources/favorite_data_source.dart';
import 'package:nylon/features/favorites/data/models/favorites_model.dart';

abstract class FavoritesController extends GetxController {
  Future getFavorites();
  Future removeFavorites({required String idProduct});
  Future addFavorites({required String idProduct});
   addOrRemoveFavorites({required String idProduct});
  
}
class ControllerFavorites extends FavoritesController{
  final FavoriteDataSourceImpl _favoriteDataSourceImpl = FavoriteDataSourceImpl(Get.find());
  StatusRequest? statusRequestGetFav,statusRequestRemove, statusRequestAdd;
  final MyServices _myServices = Get.find();
  FavoritesModel? favorites ;
   Map<String,bool>favoritesMap = {};
  @override
  Future getFavorites()async {
    // if(_myServices.userIsLogin()){
      statusRequestGetFav = StatusRequest.loading;
      update();
      var response = await _favoriteDataSourceImpl.getFavorites();
      return response.fold(
        (failure){
         statusRequestGetFav=StatusRequest.empty;
         update();
      },(data){
        if(data!=null && data.isNotEmpty&&data.containsKey("products")){
         favorites = FavoritesModel.fromJson(data as Map<String,dynamic>);
           if ( favorites != null &&  favorites!.products != null &&  favorites!.products!.isNotEmpty) {
        for (var element in  favorites!.products!) {
          if (element.productId != null && element.productId != null) {
            favoritesMap.addAll({
              element.productId!: true,
            });
          } else {
            print('Invalid product or cart ID');
          }
        }
        print(favoritesMap);
        print(favorites!.products!.length);
        print('Success');
      } else {

        print('No products found');
      }
         print("sssssssssssssssssssssssssssssuses get Vafo");
    
         statusRequestGetFav = StatusRequest.success;
         update();
        }else{
          statusRequestGetFav = StatusRequest.empty;
          update();
        }
      });
      //962
    // }else{
    //   statusRequestGetFav=StatusRequest.unauthorized;
    //   update();
    // }
  }
@override
  void onInit() {
    print('on init Favooooooooooooooooooooooooooooooo');
getFavorites();
super.onInit();
  }
  
  @override
  Future removeFavorites({required String idProduct}) async{
      var response = await _favoriteDataSourceImpl.removeFavorites(idProduct: idProduct);
   return response.fold(
    (failure){
      statusRequestRemove = failure;
      // update();
   }, (data){
    print(data);
     showSnackBar('196'.tr);
     update();
    
   });
  }
  
  @override
  Future addFavorites({required String idProduct})async {
    if(_myServices.userIsLogin()){
      var response = await _favoriteDataSourceImpl.addFavorites(idProduct: idProduct);
   return response.fold(
    (failure){
      statusRequestAdd = failure;
      handleStatusRequestInput(statusRequestAdd!);
      // update();
   }, (data){
    print(data);
     showSnackBar('197'.tr);
     update();
    
   });
   }else{
     showSnackBar('157'.tr);
   }
  }
  
  @override
  addOrRemoveFavorites({required String idProduct})async {
   if(favoritesMap.containsKey(idProduct)){
     await removeFavorites(idProduct:idProduct);
    favoritesMap.remove(idProduct);
    update();
   }else{
await addFavorites(idProduct: idProduct,);
   update();
   }
  await getFavorites();
  }
}
