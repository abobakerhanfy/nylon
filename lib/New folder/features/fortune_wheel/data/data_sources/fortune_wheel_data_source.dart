import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/url/url_api.dart';

abstract class FortuneWheelDataSource {
  Future<Either<StatusRequest, Map>> getRewards();
  Future<Either<StatusRequest, Map>> addReward({required String rewardId});
}

class FortuneWheelDataSourceImpl implements FortuneWheelDataSource {
  final Method _method;
  FortuneWheelDataSourceImpl(this._method);
  final MyServices _myServices = Get.find();

  @override
  Future<Either<StatusRequest, Map>> addReward(
      {required String rewardId}) async {
    final token = _myServices.sharedPreferences.getString('token');
    if (token == null) return left(StatusRequest.unauthorized);

    return await _method.postData(
      url: '${AppApi.urlAddReward}$token',
      data: {'reward_id': rewardId},
    );
  }

  @override
  Future<Either<StatusRequest, Map>> getRewards() async {
    final token = _myServices.sharedPreferences.getString('token');
    if (token == null) return left(StatusRequest.unauthorized);

    return await _method.getData(
      url: '${AppApi.urlGetReward}$token',
    );
  }
}
