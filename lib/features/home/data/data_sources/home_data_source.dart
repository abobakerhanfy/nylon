import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/url/url_api.dart';
import 'package:nylon/features/home/data/models/new_model_test.dart';

import '../../../../core/services/services.dart';

/// HomeDataSource is an abstract class defining the contract for fetching
/// data from various sources.
/// This abstract class outlines the methods that concrete data source
/// implementations should implement, such as fetching data from a remote API, local database, or any other data source.
abstract class HomeDataSource {
  Future<Either<StatusRequest, NewModelHome>> getData();
  Future<Either<StatusRequest, Map>> getLogo();
}

class HomeDataSourceImpl implements HomeDataSource {
  final Method _method;
  HomeDataSourceImpl(this._method);
  final MyServices _myServices = Get.find();
  @override
  Future<Either<StatusRequest, NewModelHome>> getData() async {
    var response = await _method.getData(
        url: '${AppApi.urlFullHome}${_myServices.getLanguageCode()}');
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      NewModelHome fullHomeModel = NewModelHome.fromJson(data);
      return right(fullHomeModel);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> getLogo() async {
    var response = await _method.getData(url: AppApi.getLogo);
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }
}
