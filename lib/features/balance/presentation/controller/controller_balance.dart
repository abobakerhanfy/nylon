import 'package:flutter/services.dart';
// ignore_for_file: unnecessary_null_comparison

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/snack_bar.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/widgets/login/dialog.dart';
import 'package:nylon/core/widgets/primary_button.dart';
import 'package:nylon/features/balance/data/data_sources/balance_data_source.dart';
import 'package:nylon/features/balance/data/models/get_balance_model.dart';
import 'package:nylon/features/balance/data/models/get_cart_balance.dart';
import 'package:nylon/core/url/url_api.dart';
import 'package:dartz/dartz.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nylon/features/payment/data/models/balance_payment_model.dart';
import 'package:nylon/features/payment/data/models/payment_model.dart';
import 'package:nylon/features/payment/data/data_sources/payment_data_source.dart';
import 'package:nylon/features/payment/data/models/select_patment.dart';
import 'package:nylon/features/payment/presentation/screens/payment_webview_screen.dart';

// إنشاء كلاس Crud محلي بدلاً من الاستيراد
class Crud {
  Future<Either<StatusRequest, dynamic>> getData({required String url}) async {
    try {
      final response = await http.get(Uri.parse(url));
      print("📡 Crud GET Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(data);
      } else {
        return const Left(StatusRequest.serverFailure);
      }
    } catch (e) {
      print("❌ Crud GET Error: $e");
      return const Left(StatusRequest.serverFailure);
    }
  }

  Future<Either<StatusRequest, dynamic>> postData({
    required String url,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: data,
      );
      print("📡 Crud POST Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Right(responseData);
      } else {
        return const Left(StatusRequest.serverFailure);
      }
    } catch (e) {
      print("❌ Crud POST Error: $e");
      return const Left(StatusRequest.serverFailure);
    }
  }
}

abstract class BalanceController extends GetxController {
  Future getBalace();
  Future addBalace();
  Future getProductsBalace();
  Future addOrderBalace();
  selectCredit({required String value});
  // Future sendDataUser();
  Future<void> processOrderBalanceWithMyFatoorah();
  Future getPayment(); // إضافة مفقودة
  Future selectPayment({required String paymentCode}); // إضافة مفقودة
}

class ControllerBalance extends BalanceController {
  final BalanceDataSourceImpl _balanceDataSourceImpl =
      BalanceDataSourceImpl(Get.find());
  final MyServices _myServices = Get.find();
  BalancePaymentModel? balancePaymentModel;
  StatusRequest? statusRequestGetPayment;
  StatusRequest? statusRequestpMyFatoorah;
  String? titlePayment;
  PaymentsData? selectedBalancePayment;
  PaymentModel? paymentModel;
  String? selectCodePayment;
// الإضافات المطلوبة
  List<PaymentsData> paymentsDataList = [];
  final PaymentDataSourceImpl _paymentDataSourceImpl =
      PaymentDataSourceImpl(Get.find());
  final Crud _method = Crud();
  SelectPaymentModel? selectPaymentModel;
  StatusRequest? statusRequestSelectPayment;

  TextEditingController cFirstName = TextEditingController();
  TextEditingController cLastName = TextEditingController();
  String? credit;

  Future<void> sendCustomerDataToFastCheckout(Map<String, dynamic> data) async {
    final token = _myServices.sharedPreferences.getString("token") ?? "";
    final resp = await _balanceDataSourceImpl.sendDataUser(data: data);
    resp.fold((l) => print("❌ Error sending fastCheckout"),
        (r) => print("✅ fastCheckout done: $r"));
  }

  Future<Map?> getAllPaymentMethods() async {
    final token = _myServices.sharedPreferences.getString("token") ?? "";
    final resp = await _balanceDataSourceImpl.getPaymentMethods(token);

    return resp.fold((l) {
      print("❌ فشل في استدعاء وسائل الدفع: $l");
      return null;
    }, (r) {
      print("✅ وسائل الدفع المتاحة: ${r['payment_methods']}");
      return r['payment_methods'];
    });
  }

  Future<void> sendDataUser() async {
    statusRequestSendDUser = StatusRequest.loading;
    update();

    final data = {
      "firstname": cFirstName.text.trim(),
      "lastname": cLastName.text.trim(),
    };

    final response = await _balanceDataSourceImpl.sendDataUser(data: data);

    response.fold((failure) {
      statusRequestSendDUser = StatusRequest.failure;
    }, (res) {
      statusRequestSendDUser = StatusRequest.success;
    });

    update();
  }

  Future<void> verifyOrderAfterPayment(String orderId) async {
    final token = _myServices.sharedPreferences.getString("token") ?? "";
    final checkUrl = "${AppApi.checkOrderBuyOrNo}$orderId";

    final response = await _method.getData(url: checkUrl);
    response.fold((l) {
      print("❌ فشل في التحقق من حالة الطلب بعد الدفع: $l");
    }, (r) {
      print("✅ نتيجة التحقق من الطلب: $r");

      if (r["success"] == true && r["status"] == "allowed") {
        showSnackBar("✅ تم تأكيد العملية بنجاح");
      } else {
        showSnackBar("⚠️ لم يتم تأكيد العملية، تأكد من حالة الطلب");
      }
    });
  }

  @override
  Future<void> processOrderBalanceWithMyFatoorah() async {
    statusRequestpMyFatoorah = StatusRequest.loading;
    update();
    final customerId =
        Get.find<MyServices>().sharedPreferences.getString("UserId") ?? "";

    final data = await addOrderBalace();

    if (data != null && data['order_id'] != null) {
      final orderId = data['order_id'].toString();
      print("🎯 order_id after add balance: $orderId");

      selectPaymentModel?.orderId = int.tryParse(orderId);

      await paymentMyFatoorahForBalance(
          orderId: selectPaymentModel?.orderId?.toString() ?? "");
    } else {
      statusRequestpMyFatoorah = StatusRequest.failure;
      // showSnackBar("فشل في تجهيز الطلب");
      update();
    }
  }

  GetBalanceModel? getBalanceModel;
  GetBalanceCart? getTotalBalance;
  StatusRequest? statusRequestgetBalance,
      statusRequestAddBal,
      statusRequestSendOrderB,
      statusRequestGetCartB,
      statusRequestSendDUser;
  GlobalKey<FormState> formAddDataUser = GlobalKey<FormState>();

  Future<void> checkLocalImageAssets(List<PaymentsData> list) async {
    print('🔍 Checking image asset files...');
    for (var payment in list) {
      print('--- ${payment.code} ---');

      // ✅ نحدد images المرشحة
      List<String> localImages;
      if (payment.separatedImages != null &&
          payment.separatedImages!.isNotEmpty) {
        localImages = payment.separatedImages!
            .map((img) => Uri.decodeFull(img.split('/').last))
            .toList();
      } else {
        localImages = [
          '${payment.code}.png',
          '${payment.code}.svg',
          '${payment.code}.jpg',
        ];
      }

      for (var fileName in localImages) {
        final localPath = 'images/$fileName';
        try {
          await rootBundle.load(localPath);
          print('✅ Found: $localPath');
        } catch (e) {
          print('⚠️ Missing: $localPath');
        }
      }
    }
  }

  Future<void> selectCode({required String code}) async {
    titlePayment = paymentsDataList
        .firstWhere((e) => e.code == code, orElse: () => PaymentsData())
        .separatedText;

    selectedBalancePayment = paymentsDataList.firstWhere((e) => e.code == code,
        orElse: () => PaymentsData());

    selectCodePayment = code;
    update();
  }

  void openPaymentWebView({required String gateway, required String url}) {
    Get.toNamed(NamePages.pPaymentWebViewScreen, arguments: {
      "gateway": gateway,
      "url": url,
      "success_url_keywords": ["success", "approved"],
      "failure_url_keywords": ["fail", "cancel"],
    });
  }

  // إضافة الدالة المفقودة
  Future<void> selectIdAddressOnOrder({required String customerId}) async {
    try {
      final token = _myServices.sharedPreferences.getString("token") ?? "";
      final response = await http.post(
        Uri.parse("${AppApi.urlSelectIdAddressnOrder}$token"),
        body: {"customer_id": customerId},
      );
      print("📡 Response from selectIdAddressOnOrder: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ selectIdAddressOnOrder success: $data");
      } else {
        print(
            "❌ selectIdAddressOnOrder failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error in selectIdAddressOnOrder: $e");
    }
  }

  Future<void> paymentMyFatoorahForBalance({required String orderId}) async {
    print("🚀 Starting paymentMyFatoorahForBalance for order_id: $orderId");

    final token = _myServices.sharedPreferences.getString('token') ?? "";
    final fullUrl = "${AppApi.urlMyfatoorah}$token&order_id=$orderId";

    print("📡 Sending GET to: $fullUrl");

    final crud = Crud(); // استخدام الكلاس المحلي

    final response = await crud.getData(url: fullUrl);

    return response.fold(
      (failure) {
        print("❌ Error in paymentMyFatoorahForBalance: $failure");
        // showSnackBar("فشل في تنفيذ الدفع");
        return;
      },
      (data) {
        print("✅ paymentMyFatoorahForBalance success: $data");
        if (data.containsKey("invoiceURL")) {
          final url = data["invoiceURL"];
          print("🔗 Opening WebView with: $url");
          openPaymentWebView(gateway: "myfatoorah_pg", url: url);
        }
        showSnackBar("تم تنفيذ الدفع بنجاح");
        return;
      },
    );
  }

  @override
  Future selectPayment({required String paymentCode}) async {
    statusRequestSelectPayment = StatusRequest.loading;
    update();

    var response =
        await _paymentDataSourceImpl.selectPayment(paymentCode: paymentCode);

    return response.fold(
      (failure) {
        statusRequestSelectPayment = failure;
        print('Error selecting payment: $failure');
        update();
      },
      (data) async {
        // ✅ خليها async هنا
        if (data.containsKey("error")) {
          showSnackBar('${data["error"]}');
          statusRequestSelectPayment = StatusRequest.failure;
          print('Error response selecting payment: ${data["error"]}');
          update();
        } else if (data.containsKey("success")) {
          try {
            print("🚀 Raw selectPayment response data: $data");

            // 🟢 امسح بيانات الطلب القديمة
            await _myServices.sharedPreferences.remove("order_id");
            await _myServices.sharedPreferences.remove("order_status");

            selectPaymentModel =
                SelectPaymentModel.fromJson(data as Map<String, dynamic>);
            print(
                'Selected payment successfully. Order ID: ${selectPaymentModel!.orderId}');
            statusRequestSelectPayment = StatusRequest.success;

            Get.snackbar(
              '211'.tr, // النص المترجم
              '',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 1),
              showProgressIndicator: true,
            );

            // 🟢 تأخير بعد النجاح
            await Future.delayed(const Duration(milliseconds: 700));
          } catch (e) {
            print('Error parsing select payment response: $e');
            statusRequestSelectPayment = StatusRequest.serverFailure;
          }
          update();
        }
      },
    );
  }

  @override
  Future addBalace() async {
    if (credit != null) {
      statusRequestAddBal = StatusRequest.loading;
      update();

      final customerId =
          _myServices.sharedPreferences.getString("UserId") ?? "";
      final firstName = cFirstName.text.isEmpty ? "منتج رقمي" : cFirstName.text;
      final lastName = cLastName.text.isEmpty ? "منتج رقمي" : cLastName.text;

      // ✅ أرسل بيانات fastCheckout أولًا
      var fastCheckoutResponse =
          await _balanceDataSourceImpl.sendCustomerDataToFastCheckout({
        "customer_id": customerId,
        "firstname": firstName,
        "lastname": lastName,
      });

      // ✅ لو فشل، أوقف الإجراء واظهر رسالة
      if (fastCheckoutResponse.isLeft()) {
        // showSnackBar("فشل في تجهيز بيانات العميل");
        statusRequestAddBal = StatusRequest.failure;
        update();
        return;
      }

      // ✅ بعد نجاح fastCheckout، أرسل طلب الرصيد
      var response = await _balanceDataSourceImpl.addBalace(credit: credit!);
      return response.fold((failure) {
        statusRequestAddBal = failure;
        print(statusRequestAddBal);
        newHandleStatusRequestInput(statusRequestAddBal!);
      }, (data) {
        if (data != null && data.isNotEmpty) {
          statusRequestAddBal = StatusRequest.success;
          getProductsBalace();
          Get.toNamed(NamePages.pSendOrderBalance);
          update();
        }
      });
    } else {
      showSnackBar('رجاء اختار قيمة الرصيد المطلوب');
    }
  }

  @override
  Future addOrderBalace() async {
    statusRequestSendOrderB = StatusRequest.loading;
    update();
    var respnse = await _balanceDataSourceImpl.addOrderBalace();
    return respnse.fold((failure) {
      statusRequestSendOrderB = failure;
      newHandleStatusRequestInput(statusRequestSendOrderB!);
      update();
    }, (data) {
      print(data);
      if (data != null && data.isNotEmpty && data.containsKey('success')) {
        newCustomDialog(
            body: SizedBox(
              height: 40,
              child: PrimaryButton(
                label: 'موافق',
                onTap: () {
                  Get.back();
                  Get.back();
                },
              ),
            ),
            title: 'تم اضافه الرصيد بنجاح ',
            dialogType: DialogType.success);
        statusRequestSendOrderB = StatusRequest.success;
        getBalace();
        update();
        return data; // إرجاع البيانات للاستخدام
      } else {
        print('ffffffff not suess response ');
        statusRequestSendOrderB = StatusRequest.failure;
        newHandleStatusRequestInput(statusRequestSendOrderB!);
        update();
        return null;
      }
    });
  }

  @override
  Future getBalace() async {
    if (_myServices.userIsLogin()) {
      statusRequestgetBalance = StatusRequest.loading;
      update();
      var response = await _balanceDataSourceImpl.getBalace();
      return response.fold((failure) {
        statusRequestgetBalance = failure;
        print(statusRequestgetBalance);
        print('errrrrrrrrrrrrrrrrrrrrr Balance');
        update();
      }, (data) {
        if (data != null && data.isNotEmpty) {
          getBalanceModel =
              GetBalanceModel.fromJson(data as Map<String, dynamic>);
          print('==========================================');
          print(getBalanceModel!.balance);
          statusRequestgetBalance = StatusRequest.success;
          update();
        } else {
          statusRequestgetBalance = StatusRequest.failure;
          update();
        }
      });
    } else {
      statusRequestgetBalance = StatusRequest.unauthorized;
      update();
    }
  }

  @override
  Future getProductsBalace() async {
    statusRequestGetCartB = StatusRequest.loading;
    var response = await _balanceDataSourceImpl.getProductsBalace();
    return response.fold((failure) {
      statusRequestGetCartB = failure;
      print('errrrrrrrrrrrrrrrrrrrrrrrror');
      update();
    }, (data) {
      if (data != null && data.isNotEmpty) {
        getTotalBalance = GetBalanceCart.fromJson(data as Map<String, dynamic>);
        statusRequestGetCartB = StatusRequest.success;
        print('sssssssssssssssuss');
        print(getTotalBalance!.totals!.length);
        print(getTotalBalance!.totals![0].text);
        update();
      } else {
        print('data nullllllllllllllllllll');
        statusRequestGetCartB = StatusRequest.failure;
        update();
      }
    });
  }

  @override
  selectCredit({required String value}) {
    credit = value;
    print('credit ================= $credit');
    update();
  }

  // إضافة الدالة المفقودة في Balance Controller
  Future<void> selectCodeBalance(
      {required String code, required String title}) async {
    if (selectCodePayment == code) return;
    selectCodePayment = code;
    titlePayment = title;
    selectedBalancePayment = paymentsDataList.firstWhere(
      (e) => e.code == code,
      orElse: () => PaymentsData(),
    );
    print('Selected payment code for balance: $selectCodePayment');
    update();
  }

  Future<void> processBalancePaymentWithMyFatoorah() async {
    statusRequestpMyFatoorah = StatusRequest.loading;
    update();

    final data = await addOrderBalace();
    if (data != null && data['order_id'] != null) {
      balancePaymentModel =
          BalancePaymentModel.fromJson(Map<String, dynamic>.from(data));
      print(
          "✅ balancePaymentModel created. Order ID: ${balancePaymentModel?.orderId}");
      await paymentMyFatoorahForBalance(
          orderId: balancePaymentModel?.orderId?.toString() ?? "");
    } else {
      statusRequestpMyFatoorah = StatusRequest.failure;
      // showSnackBar("فشل في تجهيز طلب الرصيد");
      update();
    }
  }

  Future<void> autoSelectAndPayWithMyFatoorah() async {
    print("🚀 بدء تنفيذ autoSelectAndPayWithMyFatoorah");

    final token = _myServices.sharedPreferences.getString("token") ?? "";

    const selectUrl = "${AppApi.selectPaymentUrl}\$token";
    const confirmUrlBase = "${AppApi.urlMyfatoorah}\$token";

    // الخطوة 1: استدعاء API لاختيار myfatoorah_pg
    final selectResponse = await _method.postData(
      url: selectUrl,
      data: {"payment_method": "myfatoorah_pg"},
    );

    final orderId = selectResponse.fold((l) {
      print("❌ فشل في اختيار وسيلة الدفع: \$l");
      // showSnackBar("فشل في تحديد وسيلة الدفع");
      return null;
    }, (r) {
      print("✅ تم تحديد وسيلة الدفع بنجاح: \$r");
      return r["order_id"];
    });

    if (orderId == null) return;

    // الخطوة 2: تأكيد الدفع واسترجاع رابط الفاتورة
    const confirmUrl = "\$confirmUrlBase&order_id=\$orderId&is_app=1";
    print("📡 رابط تأكيد الدفع: \$confirmUrl");

    final invoiceResp = await _method.getData(url: confirmUrl);
    final invoiceUrl = invoiceResp.fold((l) {
      print("❌ فشل في جلب رابط الفاتورة: \$l");
      // showSnackBar("فشل في توليد رابط الفاتورة");
      return null;
    }, (r) {
      print("✅ رابط الفاتورة: \${r['invoiceURL']}");
      return r['invoiceURL'];
    });

    if (invoiceUrl != null) {
      Get.to(() => PaymentWebViewScreen(
            url: invoiceUrl,
            orderId: orderId.toString(),
          ));
      print("🚀 تم فتح صفحة الدفع بنجاح");
      statusRequestAddBal = StatusRequest.success;

      /// ✅ استدعاء API التحقق بعد الدفع
      verifyOrderAfterPayment(orderId.toString());
    }
  }

  Future<void> processBalanceWithMyFatoorah() async {
    print("🔄 بدء عملية تجهيز الطلب عبر ماي فاتورة...");
    statusRequestAddBal = StatusRequest.loading;
    update();

    final methods = await getAllPaymentMethods();
    if (methods == null || !methods.containsKey("myfatoorah_pg")) {
      print("❌ بوابة myfatoorah_pg غير موجودة");
      statusRequestAddBal = StatusRequest.failure;
      showSnackBar("بوابة الدفع غير متوفرة");
      return;
    }

    final token = _myServices.sharedPreferences.getString("token") ?? "";
    final paymentUrl = "${AppApi.selectPaymentUrl}$token";

    final response = await _method.postData(
      url: paymentUrl,
      data: {"payment_method": "myfatoorah_pg"},
    );

    final orderId = response.fold((l) {
      // print("❌ فشل في تحديد وسيلة الدفع: $l");
      return null;
    }, (r) {
      print("✅ رقم الطلب المسترجع: ${r['order_id']}");
      return r['order_id'];
    });

    if (orderId == null) {
      statusRequestAddBal = StatusRequest.failure;
      // showSnackBar("فشل في تجهيز الطلب");
      update();
      return;
    }

    final confirmUrl =
        "${AppApi.urlMyfatoorah}$token&order_id=$orderId&is_app=1";
    print("📡 رابط تأكيد الطلب: $confirmUrl");

    final invoiceResp = await _method.getData(url: confirmUrl);
    final invoiceUrl = invoiceResp.fold((l) {
      print("❌ فشل في جلب رابط الفاتورة: $l");
      return null;
    }, (r) {
      print("✅ رابط الفاتورة: ${r['invoiceURL']}");
      return r['invoiceURL'];
    });

    if (invoiceUrl != null) {
      Get.to(() => PaymentWebViewScreen(
            url: invoiceUrl,
            orderId: orderId.toString(),
          ));
      print("🚀 تم فتح صفحة الدفع بنجاح");
      statusRequestAddBal = StatusRequest.success;
    } else {
      statusRequestAddBal = StatusRequest.failure;
      // showSnackBar("فشل في توليد رابط الفاتورة");
    }

    update();
  }

  // إضافة دالة getPayment المفقودة
  @override
  Future getPayment() async {
    print("🚀 Loading payment methods...");
    statusRequestGetPayment = StatusRequest.loading;
    update();

    var response = await _paymentDataSourceImpl.getPayment();

    return response.fold((failure) {
      statusRequestGetPayment = failure;
      print('خطأ في تحميل وسائل الدفع: $failure');
      update();
    }, (data) {
      if (data.containsKey("error")) {
        statusRequestGetPayment = StatusRequest.badRequest;
        print('استجابة خاطئة: ${data["error"]}');
        update();
      } else {
        try {
          final rawMethods = data["payment_methods"] as Map<String, dynamic>;
          paymentsDataList = rawMethods.entries.map((entry) {
            final methodData = entry.value as Map<String, dynamic>;
            return PaymentsData.fromJson(methodData);
          }).toList();

          print("✅ تم تحويل ${paymentsDataList.length} وسيلة دفع");

          statusRequestGetPayment = StatusRequest.success;
          update();
        } catch (e) {
          print('❌ خطأ أثناء معالجة وسائل الدفع: $e');
          statusRequestGetPayment = StatusRequest.serverFailure;
          update();
        }
      }
    });
  }

  @override
  void onInit() {
    getBalace();

    getPayment().then((_) async {
      if (paymentsDataList.length == 1) {
        final code = paymentsDataList[0].code ?? '';
        await selectCode(code: code);
        await selectPayment(paymentCode: code);

        // ✅ لو الوسيلة الوحيدة هي myfatoorah_pg، افتح صفحة الدفع تلقائيًا
        // if (code == 'myfatoorah_pg') {
        //   await processBalanceWithMyFatoorah();
        // }
      }
    });

    super.onInit();
  }
}
