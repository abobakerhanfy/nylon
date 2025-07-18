import 'dart:io';
import 'dart:convert'; // Added for jsonDecode
import 'package:http/http.dart' as http;

import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/url/url_api.dart';
import 'package:nylon/features/profile/data/models/address_list_model.dart';
import 'package:nylon/features/payment/data/models/zone_id_city.dart';

abstract class PaymentDataSource {
  Future<Either<StatusRequest, Map>> addAddressPayment(
      {required Map<String, dynamic> data});
  Future<Either<StatusRequest, List<Address>>> getAddresses();
  Future<Either<StatusRequest, Map>> getPayment();
  Future<Either<StatusRequest, Map>> selectPayment(
      {required String paymentCode});
  Future<Either<StatusRequest, List<Zone>>> getZoneId();
  Future<Either<StatusRequest, Map>> addImageBankTrans({required File file});
  Future<Either<StatusRequest, Map>> confirmBankTransfer();
  Future<Either<StatusRequest, Map>> paymentMyFatoorah({required Map data});
  Future<Either<StatusRequest, Map>> paymentTamaraPay({required Map data});
  Future<Either<StatusRequest, Map>> checkTamaraPaymentStatus(
      {required String tamaraOrderId});
  Future<Either<StatusRequest, Map>> checkPayment({required int orderId});
}

class PaymentDataSourceImpl implements PaymentDataSource {
  final Method _method;
  PaymentDataSourceImpl(this._method);
  final MyServices _myServices = Get.find();

  @override
  Future<Either<StatusRequest, Map>> addAddressPayment(
      {required Map<String, dynamic> data}) async {
    var response = await _method.postData(
        url:
            '${AppApi.addAddressPaymentUrl}${_myServices.sharedPreferences.getString('token')}',
        data: data);
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> getPayment() async {
    var response = await _method.postData(
        url:
            '${AppApi.getPaymentUrl}${_myServices.sharedPreferences.getString('token')}${_myServices.getLanguageCode()}',
        data: {});
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  Future<Either<StatusRequest, Map>> initializePaymentMethods() async {
    final response = await _method.getData(
      url:
          '${AppApi.getPaymentUrl}${_myServices.sharedPreferences.getString('token')}&lang=ar',
    );
    return response.fold(
      (failure) => left(failure),
      (data) => right(data),
    );
  }

  @override
  Future<Either<StatusRequest, Map>> selectPayment(
      {required String paymentCode}) async {
    print("🚀 selectPayment function CALLED with $paymentCode");

    var token = _myServices.sharedPreferences.getString('token') ?? '';

    var response = await _method.postData(
      url: '${AppApi.selectPaymentUrl}$token',
      data: {'payment_method': paymentCode},
    );

    print("📡 Sending to: ${AppApi.selectPaymentUrl}$token");
    print("📤 With payment_method: $paymentCode");

    return await response.fold((failure) async {
      print("❌ selectPayment failed, trying to initialize payment methods...");

      final init = await initializePaymentMethods();
      return await init.fold((e) {
        print("❌ Failed to initialize payment methods: $e");
        return left(failure);
      }, (data) async {
        print("✅ Payment methods initialized, retrying selectPayment...");
        final retry = await _method.postData(
          url: '${AppApi.selectPaymentUrl}$token',
          data: {'payment_method': paymentCode},
        );
        return retry.fold((f) => left(f), (d) => right(d));
      });
    }, (data) {
      print("✅ selectPayment success!");
      return right(data);
    });
  }

  // Re-Corrected getZoneId implementation
  @override
  Future<Either<StatusRequest, List<Zone>>> getZoneId() async {
    var response = await _method.getData(url: AppApi.getZoneUrl);
    return response.fold(
      (failure) {
        print("Error fetching zones: $failure");
        return left(failure);
      },
      (data) {
        // Ensure data is a List before mapping
        try {
          List<Zone> zonesList = data.entries.map<Zone>((entry) {
            final zoneData = entry.value;
            if (zoneData is Map<String, dynamic>) {
              return Zone.fromJson(zoneData);
            } else {
              throw FormatException(
                  "Invalid item format: expected Map<String, dynamic>, got ${zoneData.runtimeType}");
            }
          }).toList();
          print("Successfully parsed ${zonesList.length} zones.");
          return right(zonesList);
        } catch (e) {
          print("Error parsing payment methods: $e");
          return left(StatusRequest.serverFailure);
        }
      },
    );
  }

  @override
  Future<Either<StatusRequest, Map>> addImageBankTrans(
      {required File file}) async {
    var response = await _method.postOneImage(
        url:
            '${AppApi.urladdImageBankTr}${_myServices.sharedPreferences.getString('token')}',
        data: {},
        file: file);
    return response.fold((failure) {
      print("filure =================================== $failure");
      return left(failure);
    }, (data) {
      print("data ===================================");
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> confirmBankTransfer() async {
    var response = await _method.postData(
      url:
          '${AppApi.urlConfirmBankTransfer}${_myServices.sharedPreferences.getString('token')}',
      data: {},
    );
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> paymentMyFatoorah({
    required Map data,
  }) async {
    final token = _myServices.sharedPreferences.getString('token');
    final orderId = data['order_id'].toString();

    final fullUrl = '${AppApi.urlMyfatoorah}$token&order_id=$orderId';
    print("📡 Sending to: $fullUrl");

    print("🔗 URL: $fullUrl");

    // ✅ استخدم GET بدل POST
    final response = await _method.getData(url: fullUrl);

    return response.fold(
      (failure) => left(failure),
      (data) => right(data),
    );
  }

  @override
  Future<Either<StatusRequest, Map>> paymentTamaraPay(
      {required Map data}) async {
    try {
      var response = await http.post(
        Uri.parse(
            '${AppApi.urlTamarapay}${_myServices.sharedPreferences.getString('token')}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      print("🚀 Tamara Pay API Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        return right(decoded);
      } else {
        print("❌ Tamara Pay API Error: Status Code ${response.statusCode}");
        return left(StatusRequest.serverFailure);
      }
    } catch (e) {
      print("❌ Exception in paymentTamaraPay: $e");
      return left(StatusRequest.serverFailure);
    }
  }

  @override
  Future<Either<StatusRequest, Map>> checkTamaraPaymentStatus(
      {required String tamaraOrderId}) async {
    print("===================================$tamaraOrderId");
    var response = await _method.postData(
      url:
          '${AppApi.urlTamarapayCheckOrder}${_myServices.sharedPreferences.getString('token')}',
      data: {"tamara_order_id": tamaraOrderId},
    );
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> checkPayment(
      {required int orderId}) async {
    print(" orderId ===================================$orderId");
    var response = await _method.postData(
      url:
          '${AppApi.urlCheckPayment}${_myServices.sharedPreferences.getString('token')}&order_id=$orderId',
      data: {},
    );
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, List<Address>>> getAddresses() async {
    print(
        "Warning: getAddresses called on PaymentDataSourceImpl. This should ideally be handled by ProfileDataSource.");
    return right([]);
  }
}
