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
  Future<Either<StatusRequest, Map<String, dynamic>>> getOneCategory({
    required String idCategory,
    int? page,
    String? order,
    String? sort,
  }) async {
    final token = _myServices.sharedPreferences.getString('token') ?? '';
    final lang = _myServices.getLanguageCode(); // نفس اللي كنت بتستخدمه
    final url = '${AppApi.urlGetOneCategory}$token$lang';

    // ابنِ الـ body بدون حقول null
    final Map<String, dynamic> data = {
      'path': idCategory,
      if (page != null) 'page': page.toString(),
      if (order != null) 'order': order,
      if (sort != null) 'sort': sort,
    };

    final response = await _method.postData(url: url, data: data);

    return response.fold(
      (failure) => left(failure),
      (data) => right(Map<String, dynamic>.from(data)),
    );
  }
}
