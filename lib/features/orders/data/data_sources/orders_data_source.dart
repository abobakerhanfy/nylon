import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/url/url_api.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';

abstract class OrdersDataSource {
  Future<Either<StatusRequest, Map>> sendOrder();
  Future<Either<StatusRequest, Map>> getAllOrders({required String idUser});
  Future<Either<StatusRequest, Map>> getOneOrder({required String idOrder});
  Future<Either<StatusRequest, Map>> getReturnOrders();
  Future<Either<StatusRequest, Map>> getOneOrderReturn(
      {required String idOrder});

  Future<Either<StatusRequest, Map>> addReturnOrder({required Map data});
  Future<Either<StatusRequest, Map>> selectIdAddressOnOrder({
    required String idAddress,
  });
  Future<Either<StatusRequest, Map>> selectPaymentMethodOnOrder({
    required String paymentMethod,
  });
}

class OrdersDataSourceImpl implements OrdersDataSource {
  final Method _method;
  OrdersDataSourceImpl(this._method);
  final MyServices _myServices = Get.find();

  @override
  Future<Either<StatusRequest, Map>> sendOrder() async {
    var response = await _method.postData(
        url:
            '${AppApi.addOrderUrl}${_myServices.sharedPreferences.getString('token')}',
        data: {});
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> getAllOrders(
      {required String idUser}) async {
    final customerId = _myServices.sharedPreferences.getString('UserId');

    if (customerId == null || customerId.isEmpty) {
      Get.snackbar('تنبيه', '⚠️ لا يوجد عميل مسجل، يرجى تسجيل الدخول أولًا');
      return left(StatusRequest.empty); // أو StatusRequest.failure
    }

    var response = await _method.postData(
      url:
          '${AppApi.urlGetAllOrders}${_myServices.sharedPreferences.getString('token')}${_myServices.getLanguageCode()}',
      data: {
        'customer_id': customerId,
      },
    );

    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> getOneOrder(
      {required String idOrder}) async {
    var response = await _method.postData(
        url:
            '${AppApi.urlGetOneOrder}${_myServices.sharedPreferences.getString('token')}${_myServices.getLanguageCode()}',
        data: {
          'order_id': idOrder //idUser
        });
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> getReturnOrders() async {
    var response = await _method.postData(
        url:
            '${AppApi.urlGetReturnOrder}${_myServices.sharedPreferences.getString('token')}${_myServices.getLanguageCode()}',
        data: {
          'customer_id': _myServices.sharedPreferences.getString('UserId'),
          //idUser
        });
    //'930'
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> getOneOrderReturn(
      {required String idOrder}) async {
    var response = await _method.postData(
        url:
            '${AppApi.urlGetOneOrderReturn}${_myServices.sharedPreferences.getString('token')}${_myServices.getLanguageCode()}',
        data: {'return_id': idOrder});
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> addReturnOrder({required Map data}) async {
    print('=================================');
    print(data);
    print('=================================');
    var response = await _method.postData(
        url:
            '${AppApi.urladdReturnOrder}${_myServices.sharedPreferences.getString('token')}${_myServices.getLanguageCode()}',
        data: data);
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  // @override
  // selectIdAddressOnOrder({required String idAddress}) async {
  //   var respnse = await _method.postData(
  //       url:
  //           '${AppApi.urlSelectIdAddressnOrder}${_myServices.sharedPreferences.getString('token')}',
  //       data: {
  //         'customer_id': _myServices.sharedPreferences.getString('UserId'),
  //         'address_id': idAddress
  //       });
  //   return respnse.fold((failure) {
  //     return left(failure);
  //   }, (data) {
  //     return right(data);
  //   });
  // }
  @override
  Future<Either<StatusRequest, Map>> selectIdAddressOnOrder({
    required String idAddress,
  }) async {
    Get.snackbar('جاري التحديث', 'يتم تحديث الفاتورة...');

    var response = await _method.postData(
      url:
          '${AppApi.urlSelectIdAddressnOrder}${_myServices.sharedPreferences.getString('token')}',
      data: {
        'customer_id': _myServices.sharedPreferences.getString('UserId'),
        'address_id': idAddress,
      },
    );

    if (response.isLeft()) {
      return left(response.swap().getOrElse(() => StatusRequest.failure));
    } else {
      await Get.find<ControllerCart>().getCart();

      return right(response.getOrElse(() => {}));
    }
  }

  @override
  Future<Either<StatusRequest, Map>> selectPaymentMethodOnOrder({
    required String paymentMethod,
  }) async {
    Get.snackbar('جاري التحديث', 'يتم تحديث الفاتورة...');

    var response = await _method.postData(
      url:
          '${AppApi.selectPaymentUrl}${_myServices.sharedPreferences.getString('token')}',
      data: {
        'payment_method': paymentMethod,
      },
    );

    if (response.isLeft()) {
      return left(response.swap().getOrElse(() => StatusRequest.failure));
    } else {
      final data = response.getOrElse(() => {});

      // ✅ اطبع order_id إذا كان موجودًا
      if (data.containsKey('order_id')) {
        print(
            '✅ order_id from selectPaymentMethodOnOrder: ${data['order_id']}');
      } else {
        print('⚠️ order_id غير موجود في رد selectPaymentMethodOnOrder');
      }

      await Get.find<ControllerCart>().getCart();
      return right(data);
    }
  }
}
