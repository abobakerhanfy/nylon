import 'dart:io';
import 'dart:convert'; // Added for jsonDecode
import 'package:nylon/core/url/url_api.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:nylon/features/payment/presentation/screens/payment_webview_screen.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/services/services.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nylon/core/function/snack_bar.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/widgets/login/dialog.dart';
import 'package:nylon/core/widgets/primary_button.dart';
import 'package:nylon/features/orders/presentation/controller/controller_order.dart';
import 'package:nylon/features/payment/data/data_sources/payment_data_source.dart';
import 'package:nylon/features/payment/data/models/address_model.dart';
import 'package:nylon/features/payment/data/models/model_myfatoorah.dart';
import 'package:nylon/features/payment/data/models/test_zone.dart';
import 'package:nylon/features/payment/data/models/model_tamarapay.dart';
import 'package:nylon/features/payment/data/models/payment_model.dart';
import 'package:nylon/features/payment/data/models/select_patment.dart';
import 'package:nylon/features/payment/data/models/balance_payment_model.dart';
import 'package:nylon/features/payment/data/models/zone_id_city.dart';
import 'package:nylon/features/shipping/presentation/controller/controller_shipping.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';
import 'package:nylon/features/profile/data/models/address_list_model.dart';
import 'package:nylon/features/profile/data/data_sources/profile_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:nylon/core/services/services.dart';

abstract class PaymentController extends GetxController {
  final MyServices _myServices = Get.find();

  Future<void> fastCheckout({
    required String customerId,
    required String firstname,
    required String lastname,
    required String address1,
    required String city,
    String zoneId = "23",
    String telephone = "",
  }) async {
    statusRequestFastCheckout = StatusRequest.loading;
    update();

    final token = _myServices.sharedPreferences.getString('token') ?? "";
    final url = "${AppApi.urlSelectIdAddressnOrder}$token";

    print("🚀 FAST CHECKOUT CALLED with customerId=$customerId");
    print("🌍 Full URL: $url");

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          "customer_id": customerId,
          "firstname": firstname,
          "lastname": lastname,
          "address_1": address1,
          "city": city,
          "zone_id": zoneId,
          "telephone": telephone,
        },
      );

      print("📡 POST sent to: $url");
      print("📦 Response status: ${response.statusCode}");
      print("📦 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData.containsKey("success")) {
          statusRequestFastCheckout = StatusRequest.success;
          Get.snackbar("نجاح", jsonData["success"]);
        } else if (jsonData.containsKey("error")) {
          statusRequestFastCheckout = StatusRequest.failure;
          Get.snackbar("خطأ", jsonData["error"]);
        } else {
          statusRequestFastCheckout = StatusRequest.failure;
          print("⚠️ Unexpected response: $jsonData");
        }
      } else {
        statusRequestFastCheckout = handleStatusCode(response.statusCode);
      }
    } catch (e) {
      statusRequestFastCheckout = StatusRequest.failure;
      print("❌ Exception: $e");
    }

    update();
  }

  Future addAddressPayment();
  StatusRequest? statusRequestGetPayment;
  StatusRequest? statusRequestFastCheckout;
  Future getPayment();
  Future selectPayment({required String paymentCode});
  void selectCode({required String code, required String title});
  Future getZoneId();
  Future addIamgeBankTr();
  Future confirmBankTransfer();
  Future paymentMyFatoorah();
  Future paymentTamaraPay();
  Future checkTamaraPaymentStatus();
  Future checkPayment();
  Future<void> fetchUserAddresses();
  Future<void> selectAddress(String addressId);
  Future paymentMyFatoorahBlance();
  Future paymentTabby();
  Future<void> processOrderBalanceWithMyFatoorah();
  Future<void> processMyFatoorah(); // هنا التعريف فقط (لو حاب)
}

class ControllerPayment extends PaymentController {
  final PaymentDataSourceImpl _paymentDataSourceImpl =
      PaymentDataSourceImpl(Get.find());
  final ProfileDataSourceImpl _profileDataSourceImpl =
      ProfileDataSourceImpl(Get.find());
  final ControllerShipping _controllerShipping = Get.put(ControllerShipping());
  @override
  final MyServices _myServices = Get.find();

  String get token => _myServices.sharedPreferences.getString('token') ?? '';
  String get customerId =>
      _myServices.sharedPreferences.getString('UserId') ?? '';

  PaymentModel? paymentModel;
  BalancePaymentModel? balancePaymentModel;
  List<PaymentsData> paymentsDataList = [];
  PaymentsData? selectedBalancePayment;

  String selectCodePayment = '';
  String titlePayment = '';

  GlobalKey<FormState> formAddAddress = GlobalKey<FormState>();
  GlobalKey<FormState> formMyFatoorahCard = GlobalKey<FormState>();

  @override
  @override
  StatusRequest? statusRequestAddAddress,
      statusRequestGetZone,
      statusRequestsendCode,
      statusRequestsendCodeFuser,
      statusRequestGetPayment,
      statusRequestSelectPayment,
      statusRequestAddCustomer,
      statusRequestpMyFatoorah,
      statusRequestTamaraPay,
      statusRequestCheckTamara,
      statusRequestConfBank,
      statusRequestAddImage,
      statusRequestFastCheckout;

  void selectCodeBalanceSimple({required String code, required String title}) {
    selectCodePayment = code;
    update();
  }

  AddressModel? allAddress;
  ModelMyFatoorah? modelMyFatoorah;
  TamarapayModel? tamarapayModel;
  final TextEditingController cFirstName = TextEditingController();
  final TextEditingController cLastName = TextEditingController();
  final TextEditingController cAddress = TextEditingController();
  final TextEditingController cCitys = TextEditingController();
  final TextEditingController cCountryId = TextEditingController();
  final TextEditingController cZoneId = TextEditingController();
  final TextEditingController cPhone = TextEditingController();
  final TextEditingController cEmail = TextEditingController();
  var cCardName = TextEditingController();
  var cCardnumber = TextEditingController();
  var cExpirationDate = TextEditingController();
  var cSecurityCode = TextEditingController();
  bool isAddressConfirmed = false;
  List<Zone> zoneId = [];
  File? file;
  final _imagePicker = ImagePicker();
  bool isReturningFromPayment = false;
  bool checkPaymentValue = false;

  List<Address> userAddresses = [];
  String? selectedAddressId;
  StatusRequest? statusRequestGetAddresses;

  @override
  Future<void> processOrderBalanceWithMyFatoorah() async {
    statusRequestpMyFatoorah = StatusRequest.loading;
    update();

    final data = await addOrderBalance();
    if (data != null && data['order_id'] != null) {
      final orderId = data['order_id'].toString();
      print("🎯 order_id after add balance: $orderId");

      selectPaymentModel?.orderId = int.tryParse(orderId);

      await paymentMyFatoorah();
    } else {
      statusRequestpMyFatoorah = StatusRequest.failure;
      showSnackBar("فشل في تجهيز الطلب");
      update();
    }
  }

  @override
  Future<void> fastCheckout({
    required String customerId,
    required String firstname,
    required String lastname,
    required String address1,
    required String city,
    String zoneId = "23",
    String telephone = "",
  }) async {
    statusRequestFastCheckout = StatusRequest.loading;
    update();
    try {
      final response = await http.post(
        Uri.parse(
            "${AppApi.urlSelectIdAddressnOrder}${_myServices.sharedPreferences.getString("token") ?? ""}"),
        body: {
          'customer_id': customerId,
          'firstname': firstname,
          'lastname': lastname,
          'address_1': address1,
          'city': city,
          'zone_id': '198',
        },
      );
      print("🔵 fastCheckout response: ${response.body}");
      final data = json.decode(response.body);
      if (data["success"] != null) {
        statusRequestFastCheckout = StatusRequest.success;
      } else {
        statusRequestFastCheckout = StatusRequest.failure;
      }
    } catch (e) {
      print("🔴 fastCheckout error: $e");
      statusRequestFastCheckout = StatusRequest.failure;
    }
    update();
  }

  @override
  Future<void> processMyFatoorah() async {
    statusRequestpMyFatoorah = StatusRequest.loading;
    update();

    final data = await addOrderBalance();

    if (data != null && data['order_id'] != null) {
      final orderId = data['order_id'].toString();
      print("🎯 Order ID after adding balance: $orderId");

      // خزنه في selectPaymentModel نفس اللي عندك
      selectPaymentModel?.orderId = int.tryParse(orderId);

      // استدعاء دالة الدفع الأصلية بدون تغيير
      await paymentMyFatoorah();
    } else {
      statusRequestpMyFatoorah = StatusRequest.failure;
      showSnackBar("22فشل في تجهيز الطلب");
      update();
    }
  }

  /// ✅ NEW METHOD - Calls addOrderBalace API and returns order_id
  Future<Map?> addOrderBalance() async {
    final token = _myServices.sharedPreferences.getString('token') ?? "";
    final url = "${AppApi.selectPaymentUrl}$token";

    try {
      final response = await http
          .post(Uri.parse(url), body: {"payment_method": "myfatoorah_pg"});
      final jsonData = jsonDecode(response.body);
      print("✅ addOrderBalance response: $jsonData");

      if (jsonData['success'] == true) {
        return jsonData;
      } else {
        showSnackBar("فشل في إضافة الرصيد");
        return null;
      }
    } catch (e) {
      print("❌ Exception in addOrderBalance: $e");
      showSnackBar("خطأ في الإتصال بالسيرفر");
      return null;
    }
  }

  @override
  void onInit() {
    getPayment();
    fetchUserAddresses();
    getZoneId();

    super.onInit();
  }

  @override
  Future addAddressPayment() async {
    var validator = formAddAddress.currentState;
    if (validator!.validate()) {
      statusRequestAddAddress = StatusRequest.loading;
      update();
      Map<String, dynamic> data = {
        'firstname': cFirstName.text,
        'lastname': cLastName.text,
        'address_1': cAddress.text,
        'city': cCitys.text,
        'country_id': cCountryId.text.isNotEmpty ? cCountryId.text : '0',
        'zone_id': cZoneId.text.isNotEmpty ? cZoneId.text : '0',
      };

      var response = await _paymentDataSourceImpl.addAddressPayment(data: data);
      await _controllerShipping.addAddressShipping(data: data);
      return response.fold((failure) {
        statusRequestAddAddress = failure;
        print("Error adding payment address: $failure");
        showSnackBar("187".tr);
        update();
      }, (data) {
        if (data.containsKey("error")) {
          var errorData = data["error"];
          if (errorData is Map && errorData.isNotEmpty) {
            showSnackBar('${errorData.values.first}');
            statusRequestAddAddress = StatusRequest.failure;
          } else {
            showSnackBar(data["error"].toString());
            statusRequestAddAddress = StatusRequest.failure;
          }
          update();
        } else if (data.containsKey("success")) {
          statusRequestAddAddress = StatusRequest.success;
          getPayment();
          _controllerShipping.getShippingMethods();
          fetchUserAddresses();
          print("Successfully added address: $data");
          cFirstName.clear();
          cLastName.clear();
          cAddress.clear();
          cCitys.clear();
          cCountryId.clear();
          cZoneId.clear();
          update();
          // Corrected showSnackBar call: removed getXSnackBar argument
          showSnackBar("188".tr);
        }
      });
    }
  }

  @override
  Future getPayment() async {
    statusRequestGetPayment = StatusRequest.loading;
    update();

    var response = await _paymentDataSourceImpl.getPayment();

    return response.fold((failure) {
      statusRequestGetPayment = failure;
      print('Error getting payment methods: $failure');
      update();
    }, (data) async {
      if (data.containsKey("error")) {
        statusRequestGetPayment = StatusRequest.badRequest;
        print('Error response getting payment methods: ${data["error"]}');
        update();
      } else {
        try {
          paymentModel = PaymentModel.fromJson(data as Map<String, dynamic>);
          paymentsDataList = paymentModel!.paymentMethods!.toPaymentsDataList();

          print('✅ Fetched ${paymentsDataList.length} payment methods.');
          await checkLocalImageAssets(paymentsDataList);

          statusRequestGetPayment = StatusRequest.success;
        } catch (e) {
          print('❌ Error parsing payment methods: $e');
          statusRequestGetPayment = StatusRequest.serverFailure;
        }
        update();
      }
    });
  }

  void openPaymentWebView(
      {required String gateway, required String url}) async {
    final orderId = selectPaymentModel?.orderId;

    if (orderId != null) {
      print("✅ Order iD Not Heere $orderId");

      await checkAndUpdateOrderStatus(orderId.toString());
    }
    print(
        "✅ Reached openPaymentWebView with gateway: $gateway & Order Id $orderId");
    print("✅ openPaymentWebView called");
    print("🟢 gateway: $gateway");
    print("🔗 url: $url");
    print("📦 Order ID: ${selectPaymentModel?.orderId}");
    switch (gateway) {
      case 'tamarapay':
        print("🔗 Trying to open tamara: $url");

        String modifiedUrl = url.contains("?")
            ? "$url&order_id=${selectPaymentModel?.orderId?.toString() ?? ''}&is_app=1"
            : "$url?order_id=${selectPaymentModel?.orderId?.toString() ?? ''}&is_app=1";

        Get.to(() => PaymentWebViewScreen(
              url: modifiedUrl,
              orderId: selectPaymentModel?.orderId?.toString() ?? '',
              successKeyword: 'tamarapay/success',
              failKeyword: 'tamarapay/failure',
            ));

        break;

      case 'myfatoorah_pg':
        print("🔗 Trying to open myfatoorah_pg: $url");

        String modifiedUrl = url.contains("?")
            ? "$url&order_id=${selectPaymentModel?.orderId?.toString() ?? ''}&is_app=1"
            : "$url?order_id=${selectPaymentModel?.orderId?.toString() ?? ''}&is_app=1";

        Get.to(() => PaymentWebViewScreen(
              url: modifiedUrl,
              orderId: selectPaymentModel?.orderId?.toString() ?? '',

              successKeyword: 'success', // أو حسب ما يظهر في رابط النجاح
              failKeyword: 'fail', // أو 'error' أو 'cancel'
            ));
        break;

      case 'tabby_cc_installments':
        String modifiedUrl =
            url.contains("?") ? "$url&is_app=1" : "$url?is_app=1";

        Get.to(() => PaymentWebViewScreen(
              url: modifiedUrl,
              orderId: selectPaymentModel?.orderId?.toString() ?? '',
              successKeyword: 'extension/payment/tabby/confirm',
              failKeyword: 'checkout/checkout',
            ));
        break;
      default:
        Get.snackbar("خطأ", "بوابة الدفع غير معروفة");
    }
  }

  Future<void> checkAndUpdateOrderStatus(String orderId) async {
    final url = "${AppApi.checkOrderBuyOrNo}$orderId";

    try {
      final response = await http.get(Uri.parse(url));

      // 🔍 تحقق إن الاستجابة فعلاً JSON
      final contentType = response.headers['content-type'] ?? '';
      if (!contentType.contains('application/json')) {
        print("❌ الاستجابة ليست JSON: ${response.body}");
        return; // توقف بدون كراش
      }

      final json = jsonDecode(response.body);

      if (json["success"] == false) {
        print("🚨 الطلب $orderId حالته مفقود، سيتم تحديثه إلى معلق");

        final updateUrl = Uri.parse("${AppApi.checkOrderBuyOrNo}$orderId");
        final updateResponse = await http.post(updateUrl, body: {
          "status": "معلق",
        });

        if (updateResponse.statusCode == 200) {
          print("✅ تم تحديث الطلب إلى معلق بنجاح");
        } else {
          print("❌ فشل في تحديث حالة الطلب: ${updateResponse.body}");
        }
      } else {
        print("✅ الطلب $orderId حالته بالفعل: ${json['status']}");
      }
    } catch (e) {
      print("❌ خطأ أثناء التحقق أو التحديث: $e");
    }
  }

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

  Future<void> processBalancePaymentWithMyFatoorah() async {
    print('go start ');
    statusRequestpMyFatoorah = StatusRequest.loading;
  update();

    final data = await addOrderBalance();
    print('dATA PROCECC: $data');
    if (data != null && data['order_id'] != null) {
      balancePaymentModel =
          BalancePaymentModel.fromJson(Map<String, dynamic>.from(data));
      print(
          "✅ balancePaymentModel created. Order ID: ${balancePaymentModel?.orderId}");
      await paymentMyFatoorahForBalance(
          orderId: balancePaymentModel?.orderId?.toString() ?? "");
      print("✅ بعد حفظ orderId داخل balancePaymentModel: "
          "${balancePaymentModel?.orderId}");
    } else {
      statusRequestpMyFatoorah = StatusRequest.failure;
      showSnackBar("فشل في تجهيز طلب الرصيد");
      update();
    }
  }

  Future<void> paymentMyFatoorahForBalance({required String orderId}) async {
    print("🚀 Starting paymentMyFatoorahForBalance for order_id: $orderId");

    final token = _myServices.sharedPreferences.getString('token') ?? "";
    final fullUrl = "${AppApi.urlMyfatoorah}$token&order_id=$orderId";

    print("📡 Sending GET to: $fullUrl");

    final method = Method();
    final response = await method.getData(url: fullUrl);

    return response.fold(
      (failure) {
        print("❌ Error in paymentMyFatoorahForBalance: $failure");
        showSnackBar("فشل في تنفيذ الدفع");
        return;
      },
      (data) {
        print("✅ paymentMyFatoorahForBalance success: $data");
        if (data.containsKey("invoiceURL")) {
          final url = data["invoiceURL"];
          print("🔗 Original URL: $url");

          // تعديل الرابط لإضافة order_id و is_app=1
          String modifiedUrl = url.contains("?")
              ? "$url&order_id=$orderId&is_app=1"
              : "$url?order_id=$orderId&is_app=1";

          print("🔗 Modified URL: $modifiedUrl");

          Get.to(() => PaymentWebViewScreen(
                url: modifiedUrl,
                orderId: orderId,
                successKeyword: 'success',
                failKeyword: 'fail',
              ));
        }
        showSnackBar("تم تنفيذ الدفع بنجاح");
        return;
      },
    );
  }

  SelectPaymentModel? selectPaymentModel;
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
            getPayment();
          } catch (e) {
            print('Error parsing select payment response: $e');
            statusRequestSelectPayment = StatusRequest.serverFailure;
          }
          update();
        }
      },
    );
  }

  Function(bool?)? onChanged(value) {
    isAddressConfirmed = value ?? false;
    update();
    return null;
  }

  Future addImagesPicker() async {
    try {
      var imagePath = await _imagePicker.pickImage(
          source: ImageSource.gallery, maxWidth: 250, imageQuality: 50);
      if (imagePath != null) {
        file = File(imagePath.path);
        print('Image picked: ${file!.path}');
        update();
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Future<void> selectCode({required String code, required String title}) async {
    if (selectCodePayment == code) return;
    selectCodePayment = code;
    titlePayment = title;
    print('Selected payment code: $selectCodePayment');
    update();

    await Get.find<ControllerOrder>().sendPaymentMethod(paymentMethod: code);
    print('Skip getCart to stop updating invoice.');
    Get.find<ControllerCart>().update();

    print('✅ Payment method selected => Code: $code | Title: $title');
  }

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

  Future<void> fetchZones() async {
    try {
      final response = await http.get(Uri.parse(AppApi.getZoneUrl));
      if (response.statusCode == 200) {
        List<dynamic> decodedData = jsonDecode(response.body);
        // Ensure correct parsing if Zone.fromJson expects Map<String, dynamic>
        zoneId = decodedData
            .whereType<Map<String, dynamic>>()
            .map((zoneData) => Zone.fromJson(zoneData))
            .toList();
        print('Fetched ${zoneId.length} zones.');
        update();
      } else {
        throw Exception('Failed to load zones: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching zones: $e');
    }
  }

  @override
  Future getZoneId() async {
    print('✅ Loading zones from test_zone.dart...');
    statusRequestGetZone = StatusRequest.loading;
    update();

    try {
      zoneId = test.map((json) => Zone.fromJson(json)).toList();

      print('✅ Loaded ${zoneId.length} zones from local test data.');
      statusRequestGetZone = StatusRequest.success;
      update();
    } catch (e) {
      print('❌ Error loading zones from test_zone.dart: $e');
      statusRequestGetZone = StatusRequest.failure;
      update();
    }
  }

  @override
  Future addIamgeBankTr() async {
    if (selectCodePayment == 'bank_transfer' &&
        file != null &&
        file!.path.isNotEmpty) {
      statusRequestAddImage = StatusRequest.loading;
      update();
      var response =
          await _paymentDataSourceImpl.addImageBankTrans(file: file!);
      return response.fold((failure) {
        statusRequestAddImage = failure;
        print('Error uploading bank transfer image: $failure');
        update();
      }, (data) {
        if (data.containsKey("success")) {
          statusRequestAddImage = StatusRequest.success;
          print("Bank transfer image uploaded successfully: $data");
          update();
        } else {
          statusRequestAddImage = StatusRequest.failure;
          print(
              "Failed to upload bank transfer image: ${data['error'] ?? 'Unknown error'}");
          newCustomDialog(
              body: SizedBox(
                height: 40,
                child: PrimaryButton(
                  label: '100'.tr,
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
              title: "180".tr,
              dialogType: DialogType.error);
          update();
        }
      });
    } else {
      print(
          'Cannot upload image: Payment method is not bank transfer or file is missing.');
      if (selectCodePayment != 'bank_transfer') showSnackBar("181".tr);
      if (file == null || file!.path.isEmpty) showSnackBar("182".tr);
    }
  }

  @override
  Future confirmBankTransfer() async {
    statusRequestConfBank = StatusRequest.loading;
    update();
    var response = await _paymentDataSourceImpl.confirmBankTransfer();
    response.fold((failure) {
      statusRequestConfBank = failure;
      print("Error confirming bank transfer: $failure");
      update();
    }, (data) {
      statusRequestConfBank = StatusRequest.success;
      print("Bank transfer confirmed: $data");
      update();
    });
  }

  @override
  Future paymentTamaraPay() async {
    final orderId = selectPaymentModel?.orderId;

    if (orderId == null) {
      showSnackBar("لا يمكن تنفيذ الدفع بدون رقم الطلب");
      statusRequestTamaraPay = StatusRequest.failure;
      update();
      return;
    }

    statusRequestTamaraPay = StatusRequest.loading;
    update();

    var response = await _paymentDataSourceImpl.paymentTamaraPay(data: {
      'order_id': orderId.toString(), // ✅ الحل
    });

    return response.fold((failure) {
      statusRequestTamaraPay = StatusRequest.failure;
      print('Error initiating Tamara Pay: $failure');
      update();
    }, (data) async {
      if (data.isNotEmpty) {
        try {
          tamarapayModel =
              TamarapayModel.fromJson(data as Map<String, dynamic>);
          final redirectUrl = tamarapayModel?.checkoutData?.checkoutRedirectUrl;

          if (redirectUrl != null) {
            print('Tamara Pay redirect URL: $redirectUrl');
            isReturningFromPayment = true;
            statusRequestTamaraPay = StatusRequest.success;
            update();

            // ✅ فتح WebView داخلي للدفع
            openPaymentWebView(
              gateway: 'tamarapay',
              url: redirectUrl,
            );
          } else {
            statusRequestTamaraPay = StatusRequest.failure;
            print("Tamara Pay error: Missing redirect URL. Response: $data");
            showSnackBar("184".tr); // فشل في إنشاء الطلب
            update();
          }
        } catch (e) {
          statusRequestTamaraPay = StatusRequest.failure;
          print("Error parsing Tamara Pay response: $e");
          showSnackBar("185".tr); // خطأ في البيانات
          update();
        }
      } else {
        statusRequestTamaraPay = StatusRequest.failure;
        print("Tamara Pay error: Empty response data.");
        showSnackBar("184".tr); // البيانات فارغة
        update();
      }
    });
  }

  @override
  Future checkTamaraPaymentStatus() async {
    if (isReturningFromPayment == true &&
        tamarapayModel?.checkoutData?.tamaraOrderId != null) {
      print(
          "Checking Tamara payment status for order ID: ${tamarapayModel!.checkoutData!.tamaraOrderId}");
      statusRequestCheckTamara = StatusRequest.loading;
      update();
      var response = await _paymentDataSourceImpl.checkTamaraPaymentStatus(
          tamaraOrderId: tamarapayModel!.checkoutData!.tamaraOrderId!);
      return response.fold((failure) {
        statusRequestCheckTamara = failure;
        print('Error checking Tamara payment status: $failure');
        update();
      }, (data) async {
        if (data.containsKey("success") && data["success"] == true) {
          statusRequestCheckTamara = StatusRequest.success;
          print("Tamara payment successful: $data");
          update();
          try {
            ControllerOrder controllerOrder = Get.find();
            await controllerOrder.sendOrder();
            print("Order sent after successful Tamara payment.");
          } catch (e) {
            print("Error finding or calling ControllerOrder.sendOrder: $e");
          }
          isReturningFromPayment = false;
          update();
        } else {
          statusRequestCheckTamara = StatusRequest.failure;
          print("Tamara payment check failed or payment not complete: $data");
          newCustomDialog(
              body: SizedBox(
                height: 40,
                child: PrimaryButton(
                  label: '100'.tr,
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
              title: "186".tr,
              dialogType: DialogType.error);
          isReturningFromPayment = false;
          update();
        }
      });
    } else {
      print(
          "Skipping Tamara payment check: Not returning from payment or missing order ID.");
    }
  }

  @override
  Future<String?> paymentMyFatoorah() async {
    final orderId = selectPaymentModel?.orderId;
    if (orderId == null) {
      showSnackBar("لا يمكن تنفيذ الدفع بدون رقم الطلب");
      statusRequestpMyFatoorah = StatusRequest.failure;
      update();
      return null;
    }

    statusRequestpMyFatoorah = StatusRequest.loading;
    update();

    final response = await _paymentDataSourceImpl.paymentMyFatoorah(
      data: {"order_id": orderId},
    );

    return await response.fold(
      (failure) async {
        statusRequestpMyFatoorah = StatusRequest.failure;
        print('❌ Error initiating MyFatoorah payment: $failure');
        update();
        return null;
      },
      (data) async {
        print('📦 MyFatoorah response: $data');
        print("📊 Type of data: ${data.runtimeType}");

        try {
          final Map<String, dynamic> parsedData = data.cast<String, dynamic>();

          if (parsedData['success'] == true &&
              parsedData['invoiceURL'] != null) {
            modelMyFatoorah = ModelMyFatoorah.fromJson(parsedData);
            final paymentUrl = modelMyFatoorah?.paymentUrl;

            if (paymentUrl != null && paymentUrl.startsWith("http")) {
              checkPaymentValue = true;
              update();
              print('🔗 MyFatoorah Payment URL: $paymentUrl');

              openPaymentWebView(
                gateway: 'myfatoorah_pg',
                url: paymentUrl,
              );

              return paymentUrl;
            } else {
              throw Exception("رابط الدفع غير متوفر");
            }
          } else {
            throw Exception("الاستجابة غير مكتملة أو فاشلة");
          }
        } catch (e, stack) {
          statusRequestpMyFatoorah = StatusRequest.failure;
          print("❌ Exception: $e");
          print("📍 StackTrace: $stack");
          showSnackBar("فشل في معالجة الدفع");
          update();
          return null;
        }
      },
    );
  }

  @override
  Future checkPayment() async {
    if (selectPaymentModel?.orderId == null) {
      print("❌ لا يمكن تنفيذ الدفع بدون رقم الطلب");
      showSnackBar("فشل تنفيذ الدفع، لا يوجد رقم طلب.");
      return;
    }

    print(
        "Checking payment status for order ID: ${selectPaymentModel!.orderId}");
    update();
    var response = await _paymentDataSourceImpl.checkPayment(
        orderId: selectPaymentModel!.orderId!);
    response.fold((failure) {
      print("Error checking payment status: $failure");
      update();
    }, (data) {
      print("Payment status check response: $data");
      if (data.containsKey("success") && data["success"] == true) {
        print("Payment confirmed via checkPayment.");
      } else {
        print("Payment not confirmed via checkPayment.");
      }
      update();
    });
  }

  @override
  Future<void> fetchUserAddresses() async {
    statusRequestGetAddresses = StatusRequest.loading;
    update();
    print("Fetching user addresses...");
    var response = await _profileDataSourceImpl.getAddresses();
    response.fold(
      (failure) {
        statusRequestGetAddresses = failure;
        print("Failed to fetch addresses: $failure");
        userAddresses = [];
        update();
      },
      (addresses) {
        userAddresses = addresses;
        selectedAddressId = userAddresses
            .firstWhereOrNull((addr) => addr.defaultAddress == true)
            ?.addressId;
        if (selectedAddressId == null && userAddresses.isNotEmpty) {
          selectedAddressId = userAddresses.first.addressId;
          print(
              "No default address found, selecting first address ID: $selectedAddressId");
          if (selectedAddressId != null) {
            print(
                "Auto-selected address. Reloading cart and shipping methods...");
            Get.find<ControllerCart>().getCart();
            _controllerShipping.getShippingMethods();
          }
        }
        statusRequestGetAddresses = StatusRequest.success;
        print(
            "Fetched ${userAddresses.length} addresses. Selected ID: $selectedAddressId");
        update();
      },
    );
  }

  @override
  Future<void> selectAddress(String addressId) async {
    if (selectedAddressId == addressId) {
      print("Address ID $addressId already selected.");
      return;
    }
    print("Selecting address ID: $addressId");
    selectedAddressId = addressId;
    print("Address selected locally. Reloading cart and shipping methods...");
    Get.find<ControllerCart>().getCart();
    _controllerShipping.getShippingMethods();
    update();
  }

  @override
  Future paymentMyFatoorahBlance() async {
    final orderId = selectPaymentModel?.orderId;
    if (orderId == null) {
      showSnackBar("لا يمكن تنفيذ الدفع بدون رقم الطلب");
      print("❌ paymentMyFatoorahBlance: orderId is null");
      return;
    }

    print("🚀 Starting paymentMyFatoorahBlance for order_id: $orderId");

    final token = _myServices.sharedPreferences.getString('token') ?? "";
    final fullUrl = "${AppApi.urlMyfatoorah}$token&order_id=$orderId";

    print("📡 Sending GET to: $fullUrl");

    final method = Method(); // ✅ دي المهمة
    final response = await method.getData(url: fullUrl);

    return response.fold(
      (failure) {
        print("❌ Error in paymentMyFatoorahBlance: $failure");
        showSnackBar("فشل في تنفيذ الدفع");
        return;
      },
      (data) {
        print("✅ paymentMyFatoorahBlance success: $data");
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
  Future<void> paymentTabby() async {
    final webUrl = selectPaymentModel?.webUrl;

    if (webUrl != null && webUrl.startsWith("http")) {
      print("✅ فتح رابط Tabby: $webUrl");

      openPaymentWebView(
        gateway: 'tabby_cc_installments',
        url: webUrl,
      );
    } else {
      print("❌ رابط الدفع غير موجود أو غير صحيح");
      showSnackBar("رابط الدفع غير متاح حالياً");
    }
  }

  Future<void> selectIdAddressOnOrder({required String customerId}) async {
    final token = _myServices.sharedPreferences.getString('token') ?? "";
    final url = "${AppApi.urlSelectIdAddressnOrder}$token";

    print("🚀 FAST CHECKOUT CALLED with customerId=$customerId");
    print("🌍 Full URL: $url");

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          "customer_id": customerId,
          "firstname": cFirstName.text,
          "lastname": cLastName.text,
          "address_1": cAddress.text,
          "city": cCitys.text,
          "zone_id": cZoneId.text,
          "telephone": cPhone.text,
        },
      );

      print("📡 POST sent to: $url");
      print(
          "📦 Body sent: $customerId - ${cFirstName.text}, ${cLastName.text}, ${cAddress.text}, ${cCitys.text}, ${cZoneId.text}, ${cPhone.text}");

      print("📦 Response status: ${response.statusCode}");
      print("📦 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData.containsKey("success")) {
          print("✅ fastCheckout success: ${jsonData["success"]}");
          Get.snackbar("نجاح", jsonData["success"],
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2));
        } else if (jsonData.containsKey("error")) {
          print("🚨 fastCheckout returned error: ${jsonData["error"]}");
          Get.snackbar("خطأ", jsonData["error"],
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2));
        } else {
          print("⚠️ Unexpected response structure: $jsonData");
        }
      } else {
        print("❌ HTTP error: ${response.statusCode}");
        print("Body: ${response.body}");
      }
    } catch (e) {
      print("❌ Exception while calling fastCheckout: $e");
    }
  }

  Future<void> getBalancePaymentsAndAutoSelectMyFatoorah({
    required String customerId,
  }) async {
    print("🚀 تحميل وسائل دفع الرصيد ثم اختيار ماي فاتورة تلقائياً...");
    print(
        "🧭 getBalancePaymentsAndAutoSelectMyFatoorah: customerId => $customerId");

    statusRequestGetPayment = StatusRequest.loading;
    update();

    var response = await _paymentDataSourceImpl.getPayment();
    print("📦 paymentMyFatoorah RESPONSE: $response");

    return response.fold((failure) {
      statusRequestGetPayment = failure;
      print('خطأ في تحميل وسائل الدفع: $failure');
      update();
    }, (data) async {
      if (data.containsKey("error")) {
        statusRequestGetPayment = StatusRequest.badRequest;
        print('استجابة خاطئة: ${data["error"]}');
        update();
      } else {
        try {
          paymentModel = PaymentModel.fromJson(data as Map<String, dynamic>);
          paymentsDataList = paymentModel!.paymentMethods!.toPaymentsDataList();
          await checkLocalImageAssets(paymentsDataList);
          statusRequestGetPayment = StatusRequest.success;
          update();

          // ✅ لابد من استدعاء fast checkout أو set address قبل
          print(
              "🟢 جاري استدعاء selectIdAddressOnOrder مع customerId: $customerId");
          await selectIdAddressOnOrder(customerId: customerId);

          // ✅ اختار ماي فاتورة تلقائي
          var myFatoorah = paymentsDataList.firstWhere(
            (element) => element.code == "myfatoorah_pg",
            orElse: () => PaymentsData(code: "myfatoorah_pg"),
          );

          await selectCode(
            code: myFatoorah.code!,
            title: myFatoorah.separatedText ?? "",
          );

          // ✅ مخصصة للـ balance فقط
          await processBalancePaymentWithMyFatoorah();
          print(
              "✅ بعد processBalancePaymentWithMyFatoorah order_id = ${balancePaymentModel?.orderId}");

          await paymentMyFatoorah();
        } catch (e) {
          print('❌ خطأ أثناء معالجة وسائل الدفع: $e');
          statusRequestGetPayment = StatusRequest.serverFailure;
        }
        update();
      }
    });
  }
}
