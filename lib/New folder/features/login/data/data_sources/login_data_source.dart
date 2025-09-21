import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/url/url_api.dart';
import 'package:nylon/features/login/data/models/create_token.dart';

abstract class LoginDataSource {
  Future<Either<StatusRequest, CreateTokenModel>> fCreateToken();
  Future<Either<StatusRequest, Map>> addCustomer({required Map data});
  Future<Either<StatusRequest, Map>> sendCodeBySms({required String phone});
  Future<Either<StatusRequest, Map>> sendCodefromUser(
      {required String code, required String phone, required String auth});
  Future<Either<StatusRequest, Map>> getCustomerById();
}

class LoginDataSourceImpl implements LoginDataSource {
  final Method _method;
  LoginDataSourceImpl(this._method);
  final MyServices _myServices = Get.find();

  @override
  Future<Either<StatusRequest, CreateTokenModel>> fCreateToken() async {
    var response = await _method.postData(url: AppApi.createToken, data: {
      'username': 'Default',
      // 'key':
      //     '5jTUlN4Ah0hXhqQLILXAauTgnxqhTT2EvVrWm3IAet1StffKeXnfAgmbTwUwEHJqYDrrNB3AI65F8NtD53bVXzjiOTpKzOaY8PDHMF1swJWuBGDkc8qw1TU8m4k23mOXRzI2wxAgzQrS180AqgrDQSCwKfdrawkT7Q18v6kz1iRoOMEL4UvKaBs00Pz3Sv0VSDFlM6ac4rFP4y8cT5jPE0kWaeviDnK67M0Jta7RganFK2zVKokIfGyutZlssLGN',
      'key':
          'RbIFAaZHCiImetBnev1vLbQn8pzrHGwrGaI9eFIQz0yPOoQsM5XOuI8zsmc9Sfol6ug19m3BpQCEnob4AutfbavgibQtCu6uwtA6n6CfXNZAvZtFvSZevXnTG5tpfvdp88HhRj5uvSQ4zrM1HdmWumfTxs6KKkaOeVQ6H2B3w9bJxzFkywq1hvNoAsKXiteVGwCmvODlgsqzYiZSjFFlWE3sVjqhfKFNyFxdI8L0YH9VVRvPDaBQXSsVRc7yYE7W',
    });
    print(response);
    print('2222');
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      print(data);
      CreateTokenModel? token = CreateTokenModel();
      if (data.containsKey('api_token')) {
        token = CreateTokenModel.fromJson(data as Map<String, dynamic>);
        return right(token);
      } else {
        return right(token);
        //b39f01055617a043a2a17afc24
      }
    });
  }

  @override
  Future<Either<StatusRequest, Map>> addCustomer({required Map data}) async {
    var respnse = await _method.postData(
        url:
            '${AppApi.createNewCustomerUrl}${_myServices.sharedPreferences.getString('token')}',
        data: data);
    print(data);
    return respnse.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> sendCodeBySms(
      {required String phone}) async {
    print(phone);
    print('ppppppppppppppppppppppppppppppppppppppppppppppppppppphone');
    var respnse = await _method.postData(
        url:
            '${AppApi.sendCodeBySms}${_myServices.sharedPreferences.getString('token')}${_myServices.getLanguageCode()}',
        data: {'telephone': phone});
    return respnse.fold((failure) {
      print('ffffffffffffffffffffffffffffffffffffffffffffffffffffff');
      return left(failure);
    }, (data) {
      print('ssssssssssssssssssssssssssssssssssssssssssssssssend code');
      print(data);
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> sendCodefromUser(
      {required String code,
      required String auth,
      required String phone}) async {
    print(code);
    print(phone);
    print(auth);
    var respnse = await _method.postData(
        url:
            '${AppApi.sendCodefromUser}${_myServices.sharedPreferences.getString('token')}${_myServices.getLanguageCode()}',
        data: {'code_active': code, 'telephone': phone, 'auth': auth});
    return respnse.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> getCustomerById() async {
    var respnse = await _method.postData(
        url:
            '${AppApi.urlgetCustomerById}${_myServices.sharedPreferences.getString('token')}${_myServices.getLanguageCode()}',
        data: {
          'customer_id': _myServices.sharedPreferences.getString('UserId')
          // '966507817778'
          // '966508599770'
          //'966507817778',//phone
        });
    return respnse.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }
}
