class PaymentModel {
  PaymentMethods? paymentMethods;

  PaymentModel({this.paymentMethods});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    paymentMethods = json['payment_methods'] != null
        ? PaymentMethods.fromJson(json['payment_methods'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (paymentMethods != null) {
      data['payment_methods'] = paymentMethods!.toJson();
    }
    return data;
  }
}

class PaymentMethods {
  // استخدام خريطة لتخزين طرق الدفع
  Map<String, PaymentMethod>? methods;

  PaymentMethods({this.methods});

  List<PaymentsData> toPaymentsDataList() {
    List<PaymentsData> paymentsDataList = [];

    methods?.forEach((key, paymentMethod) {
      paymentsDataList.add(PaymentsData(
        code: paymentMethod.code,
        separatedImages: paymentMethod.separatedImages,
        separatedText: paymentMethod.separatedText,
        title: paymentMethod.title,
        accountNumber: paymentMethod.accountNumber,
        iBAN: paymentMethod.iBAN,
      ));
    });

    return paymentsDataList;
  }

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    methods = {};
    json.forEach((key, value) {
      methods![key] = PaymentMethod.fromJson(value);
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    methods?.forEach((key, value) {
      data[key] = value.toJson();
    });
    return data;
  }
}

class PaymentMethod {
  String? code;
  String? title;
  String? terms;
  String? sortOrder;
  List<String>? separatedImages;
  String? separatedText;
  int? accountNumber;
  String? iBAN;

  PaymentMethod({
    this.code,
    this.title,
    this.terms,
    this.sortOrder,
    this.separatedImages,
    this.separatedText,
    this.accountNumber,
    this.iBAN,
  });

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    code = json['code']?.toString();
    title = json['title']?.toString();
    terms = json['terms']?.toString();
    sortOrder = json['sort_order']?.toString();
    separatedImages = List<String>.from(json['separated_images'] ?? []);
    separatedText = json['separated_text']?.toString();
    accountNumber = int.tryParse(json["accountNumber"]?.toString() ?? '');
    iBAN = json['IBAN']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'title': title,
      'terms': terms,
      'sort_order': sortOrder,
      'separated_images': separatedImages,
      'separated_text': separatedText,
      'accountNumber': accountNumber,
      'IBAN': iBAN,
    };
  }
}

// class PaymentsData {
//   String? title;
//   List<String>? images;
//     String? code;
//   String? separatedText;
//   String?iBAN;
//   int? accountNumber;

//   PaymentsData(this.code, this.images, this.separatedText, this.title,this.accountNumber,this.iBAN);
// }
class PaymentsData {
  final String? code;
  final List<String>? images;
  final List<String>? separatedImages;
  final String? separatedText;
  final String? title;
  final int? accountNumber;
  final String? iBAN;

  PaymentsData({
    this.code,
    this.images,
    this.separatedImages,
    this.separatedText,
    this.title,
    this.accountNumber,
    this.iBAN,
  });

  factory PaymentsData.fromJson(Map<String, dynamic> json) {
    return PaymentsData(
      code: json['code']?.toString(),
      images: List<String>.from(json['images'] ?? []),
      separatedImages: List<String>.from(json['separated_images'] ?? []),
      separatedText: json['separated_text']?.toString() ?? " لاتوجد اي صور ",
      title: json['title']?.toString(),
      accountNumber: int.tryParse(json["accountNumber"]?.toString() ?? ''),
      iBAN: json['IBAN']?.toString(),
    );
  }
}
