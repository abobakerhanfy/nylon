import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/widgets/login/dialog.dart';
import 'package:nylon/core/widgets/primary_button.dart';
import 'package:nylon/features/addresses/data/models/address_model.dart';
import 'package:nylon/features/login/data/models/get_customer_Byp_hone.dart';
import 'package:nylon/features/profile/data/data_sources/profile_data_source.dart';

abstract class UserController extends GetxController {
  Future updataUserData();
  Future getUserById();
}

class ControllerUser extends UserController {
  final ProfileDataSourceImpl _profileDataSourceImpl =
      ProfileDataSourceImpl(Get.find());
  final MyServices _myServices = Get.find();
  AddressModel? userData;
  StatusRequest? statusRequest, statusRequestGetUser;
  var cFirstName = TextEditingController();
  var cLastName = TextEditingController();
  var cEmail = TextEditingController();
  var cPhone = TextEditingController();
  @override
  Future updataUserData() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await _profileDataSourceImpl.urlUpdataUserData(data: {
      'customer_id': _myServices.sharedPreferences.getString('UserId'),
      'firstname': cFirstName.text,
      'lastname': cLastName.text,

//cPhone.text.isNotEmpty&&cPhone.text!='966'?cPhone.text:
      //cPhone.text,
    });
    return response.fold((failure) {
      statusRequest = failure;
      update();
      newHandleStatusRequestInput(statusRequest!);
    }, (data) {
      statusRequest = StatusRequest.success;
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
          title: 'تم تعديل الملف الشخصي بنجاح',
          dialogType: DialogType.success);

      update();
    });
  }

  @override
  Future getUserById() async {
    if (_myServices.userIsLogin()) {
      statusRequestGetUser = StatusRequest.loading;
      update();
      var response = await _profileDataSourceImpl.getCustomerById();
      return response.fold((failure) {
        statusRequestGetUser = failure;
        update();
      }, (data) {
        if (data.containsKey('success')) {
          userData = AddressModel.fromJson(data as Map<String, dynamic>);
          print(userData!.data!.customerData!.customerId);
          cFirstName.text = userData!.data!.customerData!.firstname ?? '';
          cLastName.text = userData!.data!.customerData!.lastname ?? '';
          cEmail.text = userData!.data!.customerData!.email ?? '';
          cPhone.text = userData!.data!.customerData!.telephone ?? '';
          print(userData!.data!.customerData!.firstname);
          print('susesssssssssssssssssssssssssssssssssssssssssss get User');
          statusRequestGetUser = StatusRequest.success;
          update();
        } else {
          statusRequestGetUser = StatusRequest.empty;
          update();
        }
      });
    } else {
      statusRequestGetUser = StatusRequest.unauthorized;
      update();
    }
  }
}
