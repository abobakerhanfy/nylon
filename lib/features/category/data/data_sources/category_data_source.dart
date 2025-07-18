import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/url/url_api.dart';
import 'package:nylon/features/category/data/models/full_category_model.dart';

abstract class CategoryDataSource {
  Future<Either<StatusRequest, FullCategory>> getAllCategory();
  Future<Either<StatusRequest, Map>> getOneCategory(
      {required String idCategory});
}

class CategoryDataSourceImpl implements CategoryDataSource {
  final Method _method;
  CategoryDataSourceImpl(this._method);
  final MyServices _myServices = Get.find();
  @override
  Future<Either<StatusRequest, FullCategory>> getAllCategory() async {
    var response = await _method.getData(
        url: '${AppApi.urlFullCategory}${_myServices.getLanguageCode()}');
    return response.fold((failure) {
      print(failure);
      return left(failure);
    }, (data) {
      FullCategory allCategory = FullCategory.fromJson(data);
      print('sssssssssssssssssssssssssssssssssssssssssssssssssssssss cate');
      return right(allCategory);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> getOneCategory(
      {required String idCategory,
      int? page,
      String? order,
      String? sort}) async {
    var response = await _method.postData(
        url:
            '${AppApi.urlGetOneCategory}${_myServices.sharedPreferences.getString('token')}${_myServices.getLanguageCode()}',
        data: {
          'path': idCategory,
          'page': page.toString(),
          'order': order,
          'sort': sort
        });
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }
}
