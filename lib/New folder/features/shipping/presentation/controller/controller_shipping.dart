import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/login/dialog.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';
import 'package:nylon/features/payment/data/models/address_model.dart';
import 'package:nylon/features/payment/presentation/controller/controller_payment.dart';
import 'package:nylon/features/shipping/data/data_sources/shipping_data_source.dart';
import 'package:nylon/features/shipping/data/models/shipping_methods.dart';
import 'package:nylon/features/shipping/data/models/tracking_shipping.dart';

abstract class ShippingController extends GetxController {
  Future addAddressShipping({required Map data});
  Future getShippingMethods();
  Future selectShipping({required String shippingCode});
  slectCode({required String code, required String title});
  Future getTrackingshipping({required String idOrder});
}

class ControllerShipping extends ShippingController {
  final MyServices _myServices = Get.find();
  final ShippingDataSourceImpl _shippingDataSourceImpl =
      ShippingDataSourceImpl(Get.find());
  ShippingMethodsModel? shippingMethods;
  List<ShippingMethod> shippingDataMethods = [];
  TrackingShipping? trackingShippingData;
  String shippingCode = '';
  String Shippingtitle = '';
  GlobalKey<FormState> formAddAddressShipping = GlobalKey<FormState>();
  GlobalKey<FormState> formTrackingSendCode = GlobalKey<FormState>();
  StatusRequest? statusRequestaddAddress,
      statusRequestgetShipping,
      statusRequestSelectShipping,
      statusRequestgetTracking;
  final TextEditingController cFirstName = TextEditingController();
  final TextEditingController cLastName = TextEditingController();
  final TextEditingController cAddress = TextEditingController();
  final TextEditingController cPhone = TextEditingController();
  final TextEditingController cIdOrder = TextEditingController();
  Future addAddressOnShippping() async {
    final ControllerPayment controllerPayment = Get.find();
    var validator = formAddAddressShipping.currentState;
    if (validator!.validate()) {
      await addAddressShipping(data: {
        'firstname': cFirstName.text,
        'lastname': cFirstName.text,
        'address_1': cAddress.text,
        'city': controllerPayment.cCitys.text,
        'country_id': controllerPayment.cCountryId.text ?? '0',
        'zone_id': controllerPayment.cZoneId.text ?? '0',
      });
      controllerPayment.allAddress = AddressModel(
          address: cAddress.text,
          phone: cPhone.text,
          city: controllerPayment.cCitys.text,
          type: 'Shipping');
      controllerPayment.update();
      if (statusRequestaddAddress == StatusRequest.success) {
        getShippingMethods();
        Get.back();
      } else {
        handleStatusRequestInput(statusRequestaddAddress!);
      }
      update();
    }
  }

  @override
  Future addAddressShipping({required Map data}) async {
    statusRequestaddAddress = StatusRequest.loading;
    update();
    var respnse = await _shippingDataSourceImpl.addAddressShipping(data: data);
    return respnse.fold((failure) {
      statusRequestaddAddress = failure;
      print(statusRequestaddAddress);
      print('errrror  ========================= add Address Shiping');
      update();
    }, (data) {
      statusRequestaddAddress = StatusRequest.success;
      update();
      print(data);
      print('success ================================= add Address Shiping');
    });
  }

  @override
  Future getShippingMethods() async {
    statusRequestgetShipping = StatusRequest.loading;
    update();

    var response = await _shippingDataSourceImpl.getShippingMethods();

    return response.fold((failure) {
      statusRequestgetShipping = failure;
      print(statusRequestgetShipping);
      print("error get shipping");
      update();
    }, (data) {
      shippingMethods =
          ShippingMethodsModel.fromJson(data as Map<String, dynamic>);
      shippingDataMethods = shippingMethods!.toShippingDataList();
      print(shippingDataMethods[0].quotes?[0]?.code ?? 'null');
      statusRequestgetShipping = StatusRequest.success;
      update();
    });
  }

  @override
  Future selectShipping({required String shippingCode}) async {
    statusRequestSelectShipping = StatusRequest.loading;
    update();
    var response = await _shippingDataSourceImpl.selectShipping(
        shippingCode: shippingCode);
    return response.fold((failure) {
      statusRequestSelectShipping = failure;
      update();
      handleStatusRequestInput(statusRequestSelectShipping!);
      print(statusRequestSelectShipping);
      print('error select ================================= shiping code');
    }, (data) {
      if (data.containsKey("error")) {
        //  showSnackBar('${data["error"]}');
        statusRequestSelectShipping = StatusRequest.failure;
        print(
            'errrrrrrrrrrrrrrrrrrrrrrrrrrrrror on respnse  ==================================');
        update();
      } else if (data.containsKey("success")) {
        statusRequestSelectShipping = StatusRequest.success;
        print(data["success"]);
        print(
            'success select  Payment data  ==================================');
        update();
      }
      update();
    });
  }

  @override
  slectCode({required String code, required String title}) {
    ControllerCart controller = Get.find();
    shippingCode = controller.hasReachedTarget == false ? code : 'free.free';
    Shippingtitle = controller.hasReachedTarget == false ? title : 'شحن مجاني';
    print(shippingCode);
    update();
    // Reload cart data when shipping method changes
    Get.find<ControllerCart>().getCart();
  }

  @override
  Future getTrackingshipping({required String idOrder}) async {
    statusRequestgetTracking = StatusRequest.loading;
    update();
    var respnse = await _shippingDataSourceImpl.getTrackingshipping(
        idOrder: idOrder //'13626',// '1691869284',//cIdOrder.text
        );
    return respnse.fold((failure) {
      statusRequestgetShipping = failure;
      print('erorrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
      print(statusRequestgetTracking);
      newHandleStatusRequestInput(statusRequestgetTracking!);
      update();
    }, (data) {
      if (data.isNotEmpty && data.containsKey("success")) {
        trackingShippingData =
            TrackingShipping.fromJson(data as Map<String, dynamic>);
        print(trackingShippingData!.data!.orderShippingId!);
        Get.toNamed(NamePages.pTrackDetails);
        print('ssssssssssssssssssssssssssssus');
        statusRequestgetTracking = StatusRequest.success;
        update();
      } else if (data.containsKey("error")) {
        newCustomDialog(
          title: data["error"],
          dialogType: DialogType.info,
          body: InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primaryColor
                  // border: Border.all(color:colorBorder,width: 1)
                  ),
              child: Text(
                'موافق',
                style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        );
        // showSnackBar(data["error"]);
        statusRequestgetTracking = StatusRequest.failure;
        print('erorrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
        update();
      }
      update();
    });
    //
  }
}
