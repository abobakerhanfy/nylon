import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/widgets/login/dialog.dart';
import 'package:nylon/core/widgets/primary_button.dart';
import 'package:nylon/features/addresses/data/models/address_model.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';
import 'package:nylon/features/login/data/data_sources/login_data_source.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nylon/core/url/url_api.dart';
import 'package:nylon/core/function/method_GPUD.dart'; // لازم هذا السطر فوق

abstract class LoginController extends GetxController {
  Future createToken();
  Future checkAndCreateToken();
  addCustomer({required Function() onSuccess});
  Future getCustomerBypId();
  Future sendCodetoUser();
  Future sendCodefromUserNew({required String code});
  Future sendCodefromUserOnCart({
    required String code,
  });
  Future sendPhoneOnCart();
//Future addNewCustomer({required Map data});
}

class ControllerLogin extends LoginController {
  final LoginDataSourceImpl _loginDataSourceImpl =
      LoginDataSourceImpl(Get.find());
  final MyServices _myServices = Get.find();
  MyServices get myServices => _myServices;

  StatusRequest? statusRequestToken,
      statusRequestsendCode,
      statusRequestsendCodeFuser,
      statusRequestAddCustomer,
      statusRequestgetUserBP;
  GlobalKey<FormState> formRegister = GlobalKey<FormState>();
  final TextEditingController controllerPhone = TextEditingController();
  final TextEditingController cFirstName = TextEditingController();
  final TextEditingController cLastName = TextEditingController();
  final TextEditingController cEmail = TextEditingController();
  final TextEditingController cAddress = TextEditingController();
  final TextEditingController cCitys = TextEditingController();
  final TextEditingController cCountryId = TextEditingController();
  final TextEditingController cZoneId = TextEditingController();
  final TextEditingController cCompany = TextEditingController();
  DateTime? _lastCodeSentTime;
  bool? isSendC = false;
  String? statuesUser;
  bool isCodeSent = false;
  AddressModel? addressModel;
  String? selectedUserTypeOnCart;
  String? selectedAddressId;
  bool startEndTime = false;
  Timer? _timer;
  int xx = 59;
  String? inputCodeFUser;
  String? inputCodeCart;
  Future<void> resetSession() async {
    final token = _myServices.sharedPreferences.getString('token');

    if (token != null) {
      final method = Method();
      await method.getData(url: '${AppApi.logoutSession}$token');
    }

    // ✅ حذف كل البيانات من SharedPreferences
    await _myServices.sharedPreferences.remove('token');
    await _myServices.sharedPreferences.remove('lastTokenDate');
    await _myServices.sharedPreferences.remove('UserId');
    await _myServices.sharedPreferences.remove('Phone');
    await _myServices.sharedPreferences.remove('Phon_User');
    await _myServices.sharedPreferences.remove('NewCustomer_id');
    await _myServices.sharedPreferences.remove('customer_id'); // احتياطًا
    await _myServices.sharedPreferences.remove('address_id');
    await _myServices.sharedPreferences.remove('payment_method');
    print(
        "🧹 After reset, UserId = ${_myServices.sharedPreferences.getString('UserId')}");

    // ⬇️ توليد توكن جديد بعد الحذف
    var result = await _loginDataSourceImpl.fCreateToken();

    result.fold((failure) {
      print("فشل في إنشاء session جديد: $failure");
    }, (tokenModel) async {
      if (tokenModel.apiToken != null) {
        await _myServices.sharedPreferences
            .setString('token', tokenModel.apiToken!);
        await _myServices.sharedPreferences.setString(
          'lastTokenDate',
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        );
        print("تم إنشاء session جديد: ${tokenModel.apiToken}");

        final ControllerCart cartController = Get.find();
        await cartController.getCart();
      }
    });
    cPhoneOnCart.clear();
    isSendC = false;
    statusRequestSPhoneC = null;
    statusRequestSendCodeOnCart = null;
    update();
  }

  // Future<void> resetSession() async {
  //   final token = _myServices.sharedPreferences.getString('token');

  //   if (token != null) {
  //     final method = Method();
  //     await method.getData(url: '${AppApi.logoutSession}$token');
  //     await _myServices.sharedPreferences.remove('token');
  //     await _myServices.sharedPreferences.remove('lastTokenDate');
  //     await _myServices.sharedPreferences.remove('UserId');
  //     await _myServices.sharedPreferences.remove('Phone');
  //     await _myServices.sharedPreferences.remove('Phon_User');
  //     await _myServices.sharedPreferences.remove('NewCustomer_id');
  //     await _myServices.sharedPreferences.remove('customer_id'); // احتياطًا
  //     await _myServices.sharedPreferences.remove('address_id');
  //     await _myServices.sharedPreferences.remove('payment_method');

  //     await _myServices.sharedPreferences.remove('customer_id');
  //   }

  //   var result = await _loginDataSourceImpl.fCreateToken();

  //   result.fold((failure) {
  //     print("فشل في إنشاء session جديد: $failure");
  //   }, (tokenModel) async {
  //     if (tokenModel.apiToken != null) {
  //       await _myServices.sharedPreferences
  //           .setString('token', tokenModel.apiToken!);
  //       await _myServices.sharedPreferences.setString(
  //         'lastTokenDate',
  //         DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
  //       );
  //       print("تم إنشاء session جديد: ${tokenModel.apiToken}");

  //       /// ✅ إعادة تحميل السلة بعد إنشاء session
  //       final ControllerCart cartController = Get.find();
  //       await cartController.getCart();
  //     }
  //   });
  // }

  startTime() {
    if (startEndTime == false) {
      startEndTime = true;
      xx = 59;
      update();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (xx > 0) {
          xx--;
          update();
        } else {
          startEndTime = false;
          _timer?.cancel();
          update();
        }
      });
    }
  }

  selectCompany(String value) {
    cCompany.text = value;
    print(cCompany.text);
    update();
  }

  void onSelectIdAddress(String addressId, bool value) {
    if (value) {
      selectedAddressId = addressId;
      print(selectedAddressId);
    } else {
      selectedAddressId = null;
    }
    update(); // تحديث الـ UI
  }

  @override
  Future createToken() async {
    statusRequestToken = StatusRequest.loading;
    update();

    var response = await _loginDataSourceImpl.fCreateToken();

    return response.fold(
      (failure) {
        statusRequestToken = failure;
        print('❌ فشل في إنشاء التوكن: $failure');

        update();
      },
      (data) async {
        print('🎯 نتيجة السيرفر: $data');

        if (data.apiToken != null) {
          await _myServices.sharedPreferences
              .setString('token', data.apiToken!);
          await _myServices.sharedPreferences.setString(
            'lastTokenDate',
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          );

          print('✅ Token تم إنشاؤه وتخزينه: ${data.apiToken}');
        } else {
          print('⚠️ لم يتم استلام token من السيرفر');
        }

        statusRequestToken = StatusRequest.success;
        update();
      },
    );
  }

  @override
  @override
  checkAndCreateToken() async {
    String? token = _myServices.sharedPreferences.getString('token');
    String? lastTokenDate =
        _myServices.sharedPreferences.getString('lastTokenDate');

    DateTime now = DateTime.now();
    print('Current time: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)}');
    print('========');
    print('Last token creation time: $lastTokenDate');

    if (token == null || token == 'null') {
      print('No token or token is null. Creating new token...');
      await createToken();
      return;
    }

    if (lastTokenDate != null) {
      DateTime lastTokenDateTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(lastTokenDate);
      Duration difference = now.difference(lastTokenDateTime);

      if (difference.inHours >= 24) {
        print('Token is older than 24 hours. Deleting and recreating token...');
        await _myServices.sharedPreferences.remove('token');
        await _myServices.sharedPreferences.remove('lastTokenDate');
        await createToken();
      } else {
        print('Token is valid (less than 24 hours). Keeping current token.');
      }
    } else {
      print('No lastTokenDate found. Deleting and creating new token...');
      await _myServices.sharedPreferences.remove('token');
      await createToken();
    }
  }

  @override
  addCustomer({required Function() onSuccess}) async {
    var vild = formRegister.currentState;
    if (vild!.validate()) {
      statusRequestAddCustomer = StatusRequest.loading;
      update();
      var respnse = await _loginDataSourceImpl.addCustomer(data: {
        'firstname': cFirstName.text,
        'lastname': cLastName.text,
        'email': cEmail.text,
        'telephone': controllerPhone.text,
        'address_1': cAddress.text,
        'city': cCitys.text,
        'country_id': cCountryId.text,
        'zone_id': cZoneId.text,
        'company_address': cCompany.text,
      });
      return respnse.fold(
        (failure) {
          statusRequestAddCustomer = failure;
          print(statusRequestAddCustomer);
          handleStatusRequestInput(statusRequestAddCustomer!);
          update();
          print('errorrrrrrrrrrrrrrrrrrrrr Add Customer ===================  ');
        },
        (data) {
          statusRequestAddCustomer = StatusRequest.success;
          update();
          if (data.isNotEmpty) {
            if (data.containsKey('customer_id')) {
              final customerId = data['customer_id'].toString(); // ✅ سطر جديد
              _myServices.sharedPreferences
                  .setString('NewCustomer_id', customerId);
              _myServices.sharedPreferences
                  .setString('UserId', customerId); // ✅ أضف هذا السطر
              _myServices.sharedPreferences
                  .setString('Phon_User', controllerPhone.text);
              onSuccess();
              print('تم التسجيل بنجاح ');
              print(
                  'UserId: ${_myServices.sharedPreferences.getString('UserId')}');
            }
          }
        },
      );
    }
  }

  getTokenDev() async {
    String? tokenDev = await FirebaseMessaging.instance.getToken();
    print('=========================================== Token Dev ');
    print(tokenDev);
  }

  @override
  void onInit() {
    //createToken();
    checkAndCreateToken();
    getTokenDev();
    // getCustomerByphone(phone: 'phone');
    super.onInit();
  }

  @override
  Future getCustomerBypId() async {
    statusRequestgetUserBP = StatusRequest.loading;
// update();
    var respnse = await _loginDataSourceImpl.getCustomerById();
    return respnse.fold((filure) {
      if (filure == StatusRequest.unauthorized) {
        statusRequestgetUserBP = StatusRequest.success;
        print(statusRequestgetUserBP);
        print('sssssF');
        print(filure);
        update();
      } else {
        statusRequestgetUserBP = filure;
        print(statusRequestgetUserBP);
        update();
      }
    }, (data) {
      // ignore: unnecessary_null_comparison
      if (data != null && data.isNotEmpty) {
        addressModel = AddressModel.fromJson(data as Map<String, dynamic>);
        if (addressModel!.data!.address != null &&
            addressModel!.data!.address!.isNotEmpty) {
          print(addressModel!.data!.address!.first.address1);
          statusRequestgetUserBP = StatusRequest.success;
          update();
        }
        statusRequestgetUserBP = StatusRequest.success;
        update();
      } else {
        print('nullllllllllllllllllllllllllllllllllllll user');
      }
      update();
    });
  }

  @override
  Future sendCodetoUser() async {
    print(cPhoneLogin.text);
    statusRequestsendCode = StatusRequest.loading;
    update();
    var response =
        await _loginDataSourceImpl.sendCodeBySms(phone: cPhoneLogin.text);
    return response.fold((failure) {
      statusRequestsendCode = failure;
      print(statusRequestsendCode);
      newHandleStatusRequestInput(statusRequestsendCode!);
      update();
    }, (data) {
      if (data.isNotEmpty) {
        statuesUser = data['typeAuth'];
        print(data);
        startTime();
        print(cPhoneLogin.text);
        statusRequestsendCode = StatusRequest.success;
        Get.toNamed(NamePages.pVerifyCode);
        update();
      } else if (data.containsKey('error')) {
        newCustomDialog(
            body: SizedBox(
              height: 40,
              child: PrimaryButton(
                label: 'موافق',
                onTap: () {
                  Get.back();
                },
              ),
            ),
            title: data['error'],
            dialogType: DialogType.error);
        statusRequestsendCode = StatusRequest.failure;
        update();
      } else {
        statusRequestsendCode = StatusRequest.failure;
        update();
        newHandleStatusRequestInput(statusRequestsendCode!);
      }
    });
  }

  @override
  Future sendCodefromUserNew({
    required String code,
  }) async {
    statusRequestsendCodeFuser = StatusRequest.loading;
    update();
    var response = await _loginDataSourceImpl.sendCodefromUser(
        code: code, phone: cPhoneLogin.text, auth: statuesUser ?? '');
    return response.fold((failure) {
      statusRequestsendCodeFuser = failure;
      print(statusRequestsendCodeFuser);
      newHandleStatusRequestInput(statusRequestsendCodeFuser!);
      update();
    }, (data) {
      if (data.isNotEmpty && data.containsKey("customer_id")) {
        _myServices.sharedPreferences
            .setString('UserId', data["customer_id"].toString());
        _myServices.sharedPreferences.setString('Phone', cPhoneLogin.text);
        print(_myServices.sharedPreferences.getString('UserId'));
        Get.offAllNamed(NamePages.pBottomBar);
        statusRequestsendCodeFuser = StatusRequest.success;
        update();
      } else {
        newCustomDialog(
            body: SizedBox(
              height: 40,
              child: PrimaryButton(
                label: 'موافق',
                onTap: () {
                  Get.back();
                },
              ),
            ),
            title: 'حدث خطاء ما الرجاء اعادة المحاولة ',
            dialogType: DialogType.error);
        statusRequestsendCodeFuser = StatusRequest.failure;
        update();
      }
    });
  }

  StatusRequest? statusRequestLogin;
  var cPhoneLogin = TextEditingController();

  var cPhoneOnCart = TextEditingController();

  StatusRequest? statusRequestSPhoneC, statusRequestSendCodeOnCart;

  @override
  sendPhoneOnCart() async {
    if (cPhoneOnCart.text.isNotEmpty) {
      statusRequestSPhoneC = StatusRequest.loading;
      update();
      var response =
          await _loginDataSourceImpl.sendCodeBySms(phone: cPhoneOnCart.text);
      return response.fold((failure) {
        statusRequestSPhoneC = failure;
        newHandleStatusRequestInput(statusRequestSPhoneC!);
        update();
      }, (data) {
        if (data.isNotEmpty) {
          statuesUser = data['typeAuth'];
          startTime();
          statusRequestSPhoneC = StatusRequest.success;
          update();
        } else {
          newCustomDialog(
              body: SizedBox(
                height: 40,
                child: PrimaryButton(
                  label: 'موافق',
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
              title: 'حدث خطاء ما الرجاء اعادة المحاولة',
              dialogType: DialogType.error);
          statusRequestSPhoneC = StatusRequest.success;
          update();
        }
      });
    } else {
      print('empty Phone');
    }
  }

  @override
  Future sendCodefromUserOnCart({
    required String code,
  }) async {
    statusRequestSendCodeOnCart = StatusRequest.loading;
    update();

    var response = await _loginDataSourceImpl.sendCodefromUser(
      code: code,
      phone: cPhoneOnCart.text,
      auth: statuesUser ?? '',
    );

    return response.fold((failure) {
      statusRequestSendCodeOnCart = failure;
      print(statusRequestSendCodeOnCart);
      print("errrrrrrrrrrrrrror");
      newHandleStatusRequestInput(statusRequestSendCodeOnCart!);
      update();
    }, (data) {
      if (data.isNotEmpty && data.containsKey('customer_id')) {
        // ✅ تحديث UserId و Phone دائمًا بدون شرط
        _myServices.sharedPreferences
            .setString('UserId', data["customer_id"].toString());
        _myServices.sharedPreferences.setString('Phone', cPhoneOnCart.text);

        statusRequestSendCodeOnCart = StatusRequest.success;

        ControllerCart controllerCart = Get.find();
        controllerCart.plusIndexScreensCart();

        isSendC = true;
        statusRequestSPhoneC = StatusRequest.empty;
        update();
      } else {
        newCustomDialog(
          body: SizedBox(
            height: 40,
            child: PrimaryButton(
              label: 'موافق',
              onTap: () {
                Get.back();
              },
            ),
          ),
          title: 'حدث خطاء ما الرجاء اعادة المحاولة ',
          dialogType: DialogType.error,
        );
        statusRequestSendCodeOnCart = StatusRequest.failure;
        update();
      }
    });
  }

  vildSendPhoneCode() {
    DateTime currentTime = DateTime.now();

    if (_lastCodeSentTime == null ||
        currentTime.difference(_lastCodeSentTime!).inMinutes > 15) {
      _lastCodeSentTime = currentTime;
      isSendC = false;
      update();
    } else {
      print("لقد تم إرسال الكود منذ فترة قصيرة.");
      isSendC = true;
      update();
    }
  }
}




// Future<String> getUserIP() async {
  
//   final response = await http.get(Uri.parse('https://api.ipify.org?format=json'));
//   if (response.statusCode == 200) {
//     var jsonResponse = jsonDecode(response.body);
//     print(jsonResponse['ip']);
//      print(jsonResponse);
//     return jsonResponse['ip'];
//   } else {
//     throw Exception('Failed to load IP address');
//   }
//   }
  //156.207.7.98