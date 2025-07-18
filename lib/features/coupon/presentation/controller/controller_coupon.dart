import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/widgets/login/dialog.dart';
import 'package:nylon/core/widgets/primary_button.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';
import 'package:nylon/features/coupon/data/data_sources/coupon_data_source.dart';
import 'package:nylon/features/coupon/data/models/coupon_model.dart';

abstract class CouponController extends GetxController {
  Future getAllCoupon();
  Future applyCoupon();
}

class ControllerCoupon extends CouponController {
  final CouponDataSourceImpl _couponDataSourceImpl =
      CouponDataSourceImpl(Get.find());
  StatusRequest? statusRequest, statusRequestApplyCoupon;
  CouponsModel? coupos;
  var codeApplyCoupon = TextEditingController();
  GlobalKey<FormState> formApplyCoupon = GlobalKey<FormState>();

  @override
  Future getAllCoupon() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await _couponDataSourceImpl.getAllCoupon();
    return response.fold((failure) {
      statusRequest = failure;
      print(statusRequest);
      update();
    }, (data) {
      // ignore: unnecessary_null_comparison
      if (data != null && data.containsKey('coupon')) {
        coupos = CouponsModel.fromJson(data as Map<String, dynamic>);
        print(coupos!.coupon!.length);
        print(coupos!.coupon!.first.code);
        statusRequest = StatusRequest.success;
        update();
      } else {
        statusRequest = StatusRequest.empty;
        update();
      }
    });
  }

  @override
  void onInit() {
    getAllCoupon();
    super.onInit();
  }

  @override
  Future applyCoupon() async {
    // var vaild =  formApplyCoupon.currentState;
    // if(vaild!.validate()){
    if (codeApplyCoupon.text.isNotEmpty) {
      statusRequestApplyCoupon = StatusRequest.loading;
      update();
      var response =
          await _couponDataSourceImpl.applyCoupon(code: codeApplyCoupon.text);
      return response.fold((failure) {
        statusRequestApplyCoupon = failure;
        newHandleStatusRequestInput(statusRequestApplyCoupon!);
        update();
      }, (data) {
        // ignore: unnecessary_null_comparison
        if (data != null && data.isNotEmpty && data.containsKey("success")) {
          statusRequestApplyCoupon = StatusRequest.success;
          ControllerCart cartController = Get.find();
          cartController.getCart();
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
              title: 'تم تفعيل كوبون الخصم بنجاح',
              dialogType: DialogType.success);
          codeApplyCoupon.clear();
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
              title: data["error"] ??
                  'حدث خطا ما اثناء المحاولة \n الرجاء المحاولة مجددا',
              dialogType: DialogType.error);
        }
      });
    } else {
      print('empty cuoooon');
    }
  }
}
