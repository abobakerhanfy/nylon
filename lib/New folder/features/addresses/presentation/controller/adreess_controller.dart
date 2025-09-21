import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/features/addresses/data/data_sources/addresses_data_source.dart';
import 'package:nylon/features/addresses/data/models/address_model.dart';
import 'package:nylon/features/login/data/data_sources/login_data_source.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';

abstract class AdreessController extends GetxController {
  Future addAddress();
  Future addNewCustomer();
  Future onTapAddAddress();
  Future getAddress();
  Future updataAddress();
  Future deleteAddress({required String idAddress});
}

class ControllerAddress extends AdreessController {
  final ControllerLogin _controllerLogin = Get.put(ControllerLogin());
  final MyServices _myServices = Get.find();
  final AddressesDataSourceImpl _addressesDataSourceImpl =
      AddressesDataSourceImpl(Get.find());
  final LoginDataSourceImpl _loginDataSourceImpl =
      LoginDataSourceImpl(Get.find());
  StatusRequest? statusRequestOnTap, statusRequestUpdata, statusRequestDelete;
  GlobalKey<FormState> formAddAddress = GlobalKey<FormState>();
  GlobalKey<FormState> formUpdataAddress = GlobalKey<FormState>();
  final TextEditingController cFirstName = TextEditingController();
  final TextEditingController cLastName = TextEditingController();
  final TextEditingController cAddress = TextEditingController();
  final TextEditingController cCitys = TextEditingController();
  final TextEditingController cCountryId = TextEditingController();
  final TextEditingController cZoneId = TextEditingController();
  final TextEditingController cPhone = TextEditingController();
  final TextEditingController cCompany = TextEditingController();
  final TextEditingController cEmail = TextEditingController();
  StatusRequest? statusRequestgetAddress;
  Address? uAddress;
  AddressModel? addressModel;

  selectCompany(String value) {
    cCompany.text = value;
    print(cCompany.text);
    update();
  }

  @override
  Future addAddress() async {
    var vaild = formAddAddress.currentState;
    if (vaild!.validate()) {
      statusRequestOnTap = StatusRequest.loading;
      update();
      var response = await _addressesDataSourceImpl.addAddress(data: {
        "firstname": cFirstName.text,
        "lastname": cLastName.text.isNotEmpty ? cLastName.text : "null",
        "company": cCompany.text,
        "address_1": cAddress.text,
        "city": cCitys.text,
        "country_id": cCountryId.text,
        "zone_id": cZoneId.text,
        "customer_id": '${_myServices.sharedPreferences.getString('UserId')}'
      });
      return response.fold((failure) {
        statusRequestOnTap = failure;
        newHandleStatusRequestInput(statusRequestOnTap!);
        update();
      }, (data) {
        if (data.isNotEmpty && data.containsKey("success")) {
          statusRequestOnTap = StatusRequest.success;
        } else {
          statusRequestOnTap = StatusRequest.failure;
          update();
          newHandleStatusRequestInput(statusRequestOnTap!);
        }
      });
    }
  }

  @override
  Future addNewCustomer() async {
    statusRequestOnTap = StatusRequest.loading;
    update();
    var respnse = await _loginDataSourceImpl.addCustomer(data: {
      "firstname": cFirstName.text,
      "lastname": cLastName.text.isNotEmpty ? cLastName.text : "null",
      "address_1": cAddress.text,
      "city": cCitys.text,
      "country_id": cCountryId.text,
      "zone_id": cZoneId.text,
      'telephone': cPhone.text.isEmpty
          ? _controllerLogin.controllerPhone.text
          : cPhone.text,
      'email': cEmail.text.isNotEmpty ? cEmail.text : 'null',
      'company_address': cCompany.text
    });
    return respnse.fold((failure) {
      statusRequestOnTap = failure;
      handleStatusRequestInput(statusRequestOnTap!);
      update();
    }, (data) {
      if (data.isNotEmpty) {
        if (data.containsKey('customer_id')) {
          _myServices.sharedPreferences
              .setString('UserId', '${data['customer_id']}');
          _myServices.sharedPreferences.setString('Phon_User', cPhone.text);
          statusRequestOnTap = StatusRequest.success;
          update();
          print('تم التسجيل بنجاح ');
          print('${_myServices.sharedPreferences.getString('UserId')}');
          print('${_myServices.sharedPreferences.getString('Phon_User')}');
        }
      }
    });
  }

  @override
  Future onTapAddAddress() async {
    var vaild = formAddAddress.currentState;
    if (vaild!.validate()) {
      if (_myServices.userIsLogin()) {
        await addAddress();
        print('add Adress user is Login=============================');
      } else {
        await addNewCustomer();
        print('add Adress Customer notLogin=============================');
      }
      Get.back();
      await _controllerLogin.getCustomerBypId();
      update();
    }
  }

  @override
  Future getAddress() async {
    if (_myServices.userIsLogin()) {
      statusRequestgetAddress = StatusRequest.loading;
      update();

      var response = await _addressesDataSourceImpl.getAddress();
      return response.fold((failure) {
        statusRequestgetAddress = failure;
        update();
        print('Error getting Address');
      }, (data) {
        if (data.isNotEmpty && data['data']["address"] != null) {
          addressModel = AddressModel.fromJson(data as Map<String, dynamic>);
          statusRequestgetAddress = StatusRequest.success;
          update();
        } else {
          statusRequestgetAddress = StatusRequest.empty;
          print('emptyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy address');
          update();
        }
      });
    } else {
      statusRequestgetAddress = StatusRequest.unauthorized;
      print('User not logged in');
      update();
    }
  }

  void deleteAddressById({required String id}) {
    int index = addressModel!.data!.address!
        .indexWhere((address) => address.addressId == id);
    addressModel!.data!.address!.removeAt(index);
    update();
  }

  final TextEditingController cAddress2 = TextEditingController();
  void argumentsUpdateAddress() {
    uAddress = Get.arguments;
    cFirstName.text = uAddress?.firstname ?? '';
    cLastName.text = uAddress?.lastname ?? '';
    cAddress.text = uAddress?.address1 ?? '';
    cAddress2.text = uAddress?.address2 ?? '';
    cCitys.text = uAddress?.city ?? '';
    cCountryId.text = uAddress?.countryId ?? '';
    cZoneId.text = uAddress?.zoneId ?? '';
    if (uAddress != null &&
        uAddress?.company != null &&
        uAddress!.company!.isNotEmpty) {
      selectCompany(uAddress!.company ?? '');
    } else {
      cCompany.text = uAddress?.company ?? '';
    }
    update();
  }

  @override
  Future deleteAddress({required String idAddress}) async {
    statusRequestDelete = StatusRequest.loading;
    update();
    var response =
        await _addressesDataSourceImpl.deleteAddress(idAddress: idAddress);
    return response.fold((failure) {
      statusRequestDelete = failure;
      update();
      newHandleStatusRequestInput(statusRequestDelete!);
    }, (data) {
      if (data.isNotEmpty && data.containsKey("success")) {
        statusRequestDelete = StatusRequest.success;
        deleteAddressById(id: idAddress);
        update();
      } else {
        statusRequestDelete = StatusRequest.failure;
        update();
        newHandleStatusRequestInput(statusRequestDelete!);
      }
    });
  }

  @override
  Future updataAddress() async {
    var vaild = formUpdataAddress.currentState;
    if (vaild!.validate()) {
      statusRequestUpdata = StatusRequest.loading;
      update();
      var respnse = await _addressesDataSourceImpl.updateAddress(data: {
        'address_id': uAddress!.addressId,
        'firstname': cFirstName.text,
        'lastname': cLastName.text,
        'company': cCompany.text ?? '',
        'address_1': cAddress.text,
        'city': cCitys.text,
        'zone_id': cZoneId.text,
        'country_id': cCountryId.text,
        'customer_id': _myServices.sharedPreferences
            .getString('UserId'), //'5764'عاوز اتاكد
      });
      return respnse.fold((failur) {
        statusRequestUpdata = failur;
        newHandleStatusRequestInput(statusRequestUpdata!);
        update();
      }, (data) {
        if (data.isNotEmpty && data.containsKey("success")) {
          statusRequestUpdata = StatusRequest.success;
          update();
          getAddress();
          Get.back();
        } else {
          statusRequestUpdata = StatusRequest.failure;
          update();
          newHandleStatusRequestInput(statusRequestUpdata!);
        }
      });
    }
  }
}
/*
 data:{
        "firstname": cFirstName.text,
        "lastname":cLastName.text.isNotEmpty&&cLastName.text!=null?cLastName.text: "null",
        "company": cCompany.text,
        "address_1": cAddress.text,
        "city":cCitys.text,
        "country_id":cCountryId.text,
        "zone_id": cZoneId.text,
        "customer_id":_controllerLogin.userData?.customer.customerId!=null?_controllerLogin.userData?.customer.customerId!:"",

     } 
     */
