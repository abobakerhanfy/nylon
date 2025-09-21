import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/widgets/login/dialog.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';
import 'package:nylon/features/orders/data/data_sources/orders_data_source.dart';
import 'package:nylon/features/orders/data/models/get_all_order.dart';
import 'package:nylon/features/orders/data/models/one_order_model.dart';
import 'package:nylon/features/orders/data/models/one_order_return.dart';
import 'package:nylon/features/orders/data/models/return_order.dart';
import 'package:nylon/core/url/url_api.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/features/cart/presentation/screens/cart_screens/order_successfully.dart';

abstract class OrdersController extends GetxController {
  sendOrder();
  getAllOrders();
  getOneOrder({required String idOrder});
  getReturnOrders();
  getOneOrderReturn({required String idOrder});
  addReturnOrder();
  sendIdAddress({required String idAddress});
  StatusRequest? statusRequestSenIdAddress;
  StatusRequest? statusRequestSelectPayment;
}

class ControllerOrder extends OrdersController {
  bool isUpdatingInvoice = false;

  final MyServices _myServices = Get.find();
  ReturnOrdersResponse? ordersReturn;
  ReturnOneOrder? oneOrderReturn;
  StatusRequest? statusRequestSendOrder,
      statusRequestAddCustomer,
      statusRequestOneOrderRet;
  StatusRequest? statusRequestAllOrders,
      statusRequestOneOrder,
      statusRequestGetReturn,
      statusRequestAddReOrd;
  final OrdersDataSourceImpl _ordersDataSourceImpl =
      OrdersDataSourceImpl(Get.find());
  GlobalKey<FormState> formAddReOrd = GlobalKey<FormState>();
  // final ControllerPayment _controllerPayment = Get.put(ControllerPayment());
  ModelAllOrder? allOrder;
  OneOrderModel? oneOrderModel;
  List<String>? namesPro;
  List<String>? modelsPro;
  dynamic orderIdSuccess = ' ';
  String? selectName, selectStatuesP, selectModel, selectReason;
  var controllerCount = TextEditingController();
  var controllerComment = TextEditingController();

  getNameAndModelList() {
    namesPro = oneOrderModel!.getProductNames(oneOrderModel!.data!.products!);
    modelsPro = oneOrderModel!.getProductModel(oneOrderModel!.data!.products!);
    update();
  }

  void clearTemporaryOrderData() {
    orderIdSuccess = null;
    // احذف أي بيانات مؤقتة ثانية زي الملاحظات أو العناوين المؤقتة لو موجودة
    update();
  }

  @override
  sendOrder() async {
    statusRequestSendOrder = StatusRequest.loading;
    update();
    var response = await _ordersDataSourceImpl.sendOrder();
    return response.fold((failure) {
      statusRequestSendOrder = failure;
      newHandleStatusRequestInput(statusRequestSendOrder!);
      update();
      print('erorrrrrrrrrrrrr Send Order');
      print(statusRequestSendOrder);
    }, (data) {
      if (data.isNotEmpty && data.containsKey('success')) {
        orderIdSuccess = data['order_id'];
        print(data);
        statusRequestSendOrder = StatusRequest.success;
        ControllerCart controllerCart = Get.find();
        controllerCart.plusIndexScreensCart();
        print("ssssssssssssssssssssssssssssssssuccess Send Order ");
        update();
      } else {
        print(data);
        statusRequestSendOrder = StatusRequest.failure;
        newHandleStatusRequestInput(statusRequestSendOrder!);
        print("errorrrrrrrrrrrrrrrrrrrrrrrrrrrr Send Order ");
        update();
      }
    });

    update();
  }

  Future<void> verifyOrderAndRedirect(String orderId) async {
    final token = _myServices.sharedPreferences.getString('token');

    if (token == null || orderId.isEmpty) {
      Get.snackbar('خطأ', 'تعذر استكمال الطلب');
      return;
    }

    final method = Method();
    final response = await method.getData(
      url: '${AppApi.checkOrderBuyOrNo}$orderId&api_token=$token',
    );

    response.fold((failure) {
      Get.snackbar('خطأ', 'تعذر التحقق من حالة الطلب');
    }, (data) async {
      if (data['success'] == true && data['status'] == 'allowed') {
        orderIdSuccess = orderId;
        Get.offAll(() => const OrderSuccessfully());
        await Get.find<ControllerLogin>().resetSession();
      }
    });
  }

  @override
  getAllOrders() async {
    if (_myServices.userIsLogin()) {
      statusRequestAllOrders = StatusRequest.loading;
      update();
      var response = await _ordersDataSourceImpl.getAllOrders(
          idUser: '' //_myServices.sharedPreferences.getString('UserId')!
          );
      return response.fold((failure) {
        statusRequestAllOrders = failure;
        print(statusRequestAllOrders);
        print('llllllllllllllleft');
        update();
      }, (data) {
        print(data);
        if (data.isNotEmpty &&
            data.containsKey('data') &&
            data['data'] != null) {
          allOrder = ModelAllOrder.fromJson(data as Map<String, dynamic>);
          print('sssssssssssssssssssssssssssssssssssss');
          statusRequestAllOrders = StatusRequest.success;
          update();
        } else {
          statusRequestAllOrders = StatusRequest.empty;
          print("emptyyyyyyyyyyyyyy oders");
          update();
        }
      });
    } else {
      statusRequestAllOrders = StatusRequest.unauthorized;
      print("uuuuuuuuuuunu nauthorized ");
      update();
    }
  }

  @override
  getOneOrder({required String idOrder}) async {
    print(idOrder);
    statusRequestOneOrder = StatusRequest.loading;
    update();
    var response = await _ordersDataSourceImpl.getOneOrder(idOrder: idOrder);
    return response.fold((failure) {
      statusRequestOneOrder = failure;
      update();
      print(statusRequestOneOrder);
      print('errorrrrrrrrrrrrrrrrrrrrrrrrrrr');
    }, (data) {
      if (data.isNotEmpty) {
        oneOrderModel = OneOrderModel.fromJson(data as Map<String, dynamic>);
        print('ssssssssssssssssssss get OneOrde');
        statusRequestOneOrder = StatusRequest.success;
        update();
      } else {
        statusRequestOneOrder = StatusRequest.empty;
        print("empry data order ===================================");
        update();
      }
    });
  }

  @override
  getReturnOrders() async {
    if (_myServices.userIsLogin()) {
      statusRequestGetReturn = StatusRequest.loading;
      update();
      var response = await _ordersDataSourceImpl.getReturnOrders();
      return response.fold((failure) {
        statusRequestGetReturn = failure;
        update();
        print('errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
        print(statusRequestGetReturn);
      }, (data) {
        if (data.isNotEmpty &&
            data['data'] != null &&
            (data['data'] as List).isNotEmpty) {
          try {
            ordersReturn =
                ReturnOrdersResponse.fromJson(data as Map<String, dynamic>);
            print(ordersReturn!.data!.length);
            print('ssssssssssssssssssssssssssssuss');
            statusRequestGetReturn = StatusRequest.success;
            update();
          } catch (e) {
            print(e.toString());
            print('errorrrrrrrrrrrrrrrrrrrrrrrrrr catch');
            statusRequestGetReturn = StatusRequest.failure;
            update();
          }
        } else {
          statusRequestGetReturn = StatusRequest.empty;
          print("empty eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
          update();
        }
      });
    } else {
      statusRequestGetReturn = StatusRequest.unauthorized;
      print("uuuuuuuuuuunu nauthorized ");
      update();
    }
  }

  @override
  getOneOrderReturn({required String idOrder}) async {
    statusRequestOneOrderRet = StatusRequest.loading;
    update();
    var response =
        await _ordersDataSourceImpl.getOneOrderReturn(idOrder: idOrder);
    return response.fold((failure) {
      statusRequestOneOrderRet = failure;
      update();
      print('errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr ');
      print(statusRequestOneOrderRet);
    }, (data) {
      if (data.isNotEmpty && data['data'] != null && data['data'].isNotEmpty) {
        oneOrderReturn = ReturnOneOrder.fromJson(data as Map<String, dynamic>);
        print(oneOrderReturn!.data!.first.orderdata!.firstname);

        print('ssssssssssssssssssssssssssssssssssssss');
        statusRequestOneOrderRet = StatusRequest.success;
        update();
      } else {
        statusRequestOneOrderRet = StatusRequest.empty;
        print('emnnmmmmmmmmmmmmmmmmmmmmmmmmmpry');
        update();
      }
    });
  }

  @override
  addReturnOrder() async {
    print(oneOrderModel!.data!.products!.first.name);
    print(oneOrderModel!.data!.firstname);
    var vild = formAddReOrd.currentState;
    if (vild!.validate()) {
      statusRequestAddReOrd = StatusRequest.loading;
      update();
      var response = await _ordersDataSourceImpl.addReturnOrder(data: {
        'customer_id': _myServices.sharedPreferences.getString('UserId') ?? '',
        'order_id': oneOrderModel!.data!.orderId ?? '',
        'firstname': oneOrderModel!.data!.firstname ?? '',
        'lastname': oneOrderModel!.data!.lastname ?? '',
        'email': oneOrderModel!.data!.email ?? '',
        'telephone': oneOrderModel!.data!.telephone ?? '',
        'product': selectName ?? '',
        'model': selectModel ?? '',
        'quantity': controllerCount.text,
        'opened': productStatus[selectStatuesP] ?? '',
        'return_reason_id': reasonsMap[selectReason] ?? '',
        'comment':
            controllerComment.text.isNotEmpty ? controllerComment.text : '',
        'date_ordered': DateTime.now().toString(),
      });

      return response.fold((failure) {
        statusRequestAddReOrd = failure;
        update();
      }, (data) async {
        statusRequestAddReOrd = StatusRequest.success;
        print(data);
        print('ssssssssssssssssuss');
        customDialog(
            title: '118'.tr,
            body: '119'.tr,
            dialogType: DialogType.success,
            context: Get.context!);
        await Future.delayed(const Duration(seconds: 1));
        Get.back();
        Get.back();
        update();
      });
    }
  }

  void updateSelectedName(String? value) {
    selectName = value;
    update(); // إبلاغ GetX بالتغيير
  }

  void updateSelectedModel(String? value) {
    selectModel = value;
    update(); // إبلاغ GetX بالتغيير
  }

  void updateSelectedStatuesP(String? value) {
    selectStatuesP = value;
    update(); // إبلاغ GetX بالتغيير
  }

  void updateSelectedReason(String? value) {
    selectReason = value;
    update(); // إبلاغ GetX بالتغيير
  }

  Map<String, String> reasonsMap = {
    'أخرى، الرجاء التوضيح': '5',
    'استلمت منتج مختلف عن طلبي': '2',
    'المنتج وصلني تالف': '1',
    'يوجد خطأ في طلبي': '3',
    'يوجد خلل، الرجاء التوضيح': '4'
  };
  final Map<String, String> productStatus = {'مفتوح': '1', 'مغلق': '0'};

  Map<String, String> statusMap = {
    '13': 'إعادة المبلغ',
    '9': 'إلغاء عكس الطلب',
    '14': 'انتهاء الوقت',
    '17': 'بإنتظار التحويل',
    '15': 'تم التجهيز',
    '3': 'تم شحن الطلب',
    '12': 'تم عكس الطلب',
    '2': 'جاري التجهيز (الافتراضي)',
    '19': 'طلبات مفقوده',
    '10': 'فشل',
    '18': 'في انتظار التحويل',
    '16': 'لم يتم الدفع',
    '11': 'مردود',
    '8': 'مرفوض',
    '1': 'معلق',
    '5': 'مكتمل',
    '7': 'ملغي',
  };
  @override
  StatusRequest? statusRequestSenIdAddress;
  @override
  sendIdAddress({required String idAddress}) async {
    isUpdatingInvoice = true;
    statusRequestSenIdAddress = StatusRequest.loading;
    update();

    var respnse = await _ordersDataSourceImpl.selectIdAddressOnOrder(
      idAddress: idAddress,
    );

    return respnse.fold((failure) {
      statusRequestSenIdAddress = failure;
      isUpdatingInvoice = false;
      update();
      newHandleStatusRequestInput(statusRequestSenIdAddress!);
    }, (data) {
      if (data.isNotEmpty) {
        statusRequestSenIdAddress = StatusRequest.success;
      } else {
        statusRequestSenIdAddress = StatusRequest.failure;
      }
      isUpdatingInvoice = false;
      update();
    });
  }

  Future<void> sendPaymentMethod({required String paymentMethod}) async {
    statusRequestSelectPayment = StatusRequest.loading;
    update();

    final token = _myServices.sharedPreferences.getString('token');
    if (token == null) {
      Get.snackbar(
          "خطأ", "الجلسة منتهية أو غير صالحة، الرجاء تسجيل الدخول مجددًا");
      return;
    }

    var response = await _ordersDataSourceImpl.selectPaymentMethodOnOrder(
      paymentMethod: paymentMethod,
    );

    await response.fold(
      (failure) {
        statusRequestSelectPayment = failure;
        newHandleStatusRequestInput(statusRequestSelectPayment!);
      },
      (data) async {
        if (data.isNotEmpty) {
          statusRequestSelectPayment = StatusRequest.success;

          // ✅ استخدم order_id مباشرة
          if (data.containsKey('order_id') && data['order_id'] != null) {
            orderIdSuccess = data['order_id'].toString();
            print(
                '✅ Order ID from selectPaymentMethodOnOrder: $orderIdSuccess');

            final method = Method();
            final checkResponse = await method.getData(
              url:
                  '${AppApi.checkOrderBuyOrNo}$orderIdSuccess&api_token=$token',
            );

            checkResponse.fold(
              (fail) {
                Get.snackbar('خطأ', 'فشل التحقق من حالة الطلب');
              },
              (checkData) async {
                if (checkData['success'] == true &&
                    checkData['status'] == 'allowed') {
                  Get.offAll(() => const OrderSuccessfully());
                  await Get.find<ControllerLogin>().resetSession();
                }
              },
            );
          } else {
            print('⚠️ order_id غير موجود في رد selectPaymentMethodOnOrder');
            // Get.snackbar('خطأ', 'لم يتم استلام رقم الطلب من السيرفر.');
          }
        } else {
          statusRequestSelectPayment = StatusRequest.failure;
          newHandleStatusRequestInput(statusRequestSelectPayment!);
        }
      },
    );

    update();
  }
}
