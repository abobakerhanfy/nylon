import 'package:nylon/features/home/data/models/mobile_featured.dart';

class OneOrderModel {
  DataOrder? data;

  OneOrderModel({this.data});

  OneOrderModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? DataOrder.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }

  List<String> getProductNames(List<Products> productList) {
    return productList.map((product) => product.name ?? '').toList();
  }

  List<String> getProductModel(List<Products> productList) {
    return productList.map((product) => product.model ?? '').toList();
  }
}

class History {
  String? dateAdded;
  String? status;
  String? comment;

  History({this.dateAdded, this.status, this.comment});

  History.fromJson(Map<String, dynamic> json) {
    dateAdded = json['date_added'];
    status = json['status'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date_added'] = dateAdded;
    data['status'] = status;
    data['comment'] = comment;
    return data;
  }
}

class DataOrder {
  List<History>? histories;

  String? orderId;
  String? invoiceNo;
  String? invoicePrefix;
  String? storeId;
  String? storeName;
  String? storeUrl;
  String? customerId;
  String? customer;
  String? customerGroupId;
  String? firstname;
  String? lastname;
  String? email;
  String? telephone;
  String? orderShippingId;
  dynamic customField;
  String? paymentFirstname;
  String? paymentLastname;
  String? paymentCompany;
  String? paymentAddress1;
  String? paymentAddress2;
  String? paymentPostcode;
  String? paymentCity;
  String? paymentZoneId;
  String? paymentZone;
  String? paymentZoneCode;
  String? paymentCountryId;
  String? paymentCountry;
  String? paymentIsoCode2;
  String? paymentIsoCode3;
  String? paymentAddressFormat;
  List<Null>? paymentCustomField;
  String? paymentMethod;
  String? paymentCode;
  String? shippingFirstname;
  String? shippingLastname;
  String? shippingCompany;
  String? shippingAddress1;
  String? shippingAddress2;
  String? shippingPostcode;
  String? shippingCity;
  String? shippingZoneId;
  String? shippingZone;
  String? shippingZoneCode;
  String? shippingCountryId;
  String? shippingCountry;
  String? shippingIsoCode2;
  String? shippingIsoCode3;
  String? shippingAddressFormat;
  List<Null>? shippingCustomField;
  dynamic shippingMethod;
  String? shippingCode;
  String? comment;
  String? image;
  String? total;
  int? reward;
  String? orderStatusId;
  dynamic orderStatus;
  String? affiliateId;
  String? affiliateFirstname;
  String? affiliateLastname;
  String? commission;
  String? languageId;
  String? languageCode;
  String? currencyId;
  String? currencyCode;
  String? currencyValue;
  String? ip;
  String? forwardedIp;
  String? userAgent;
  String? acceptLanguage;
  String? dateAdded;
  String? dateModified;
  String? configTabbyCapture;
  List<CustomerData>? customerData;
  String? customerGroup;
  List<Products>? products;
  List<TotalData>? totalData;

  DataOrder(
      {this.orderId,
      this.invoiceNo,
      this.invoicePrefix,
      this.storeId,
      this.storeName,
      this.storeUrl,
      this.customerId,
      this.customer,
      this.customerGroupId,
      this.firstname,
      this.lastname,
      this.email,
      this.telephone,
      this.orderShippingId,
      this.customField,
      this.paymentFirstname,
      this.paymentLastname,
      this.paymentCompany,
      this.paymentAddress1,
      this.paymentAddress2,
      this.paymentPostcode,
      this.paymentCity,
      this.paymentZoneId,
      this.paymentZone,
      this.paymentZoneCode,
      this.paymentCountryId,
      this.paymentCountry,
      this.paymentIsoCode2,
      this.paymentIsoCode3,
      this.paymentAddressFormat,
      this.paymentCustomField,
      this.paymentMethod,
      this.paymentCode,
      this.shippingFirstname,
      this.shippingLastname,
      this.shippingCompany,
      this.shippingAddress1,
      this.shippingAddress2,
      this.shippingPostcode,
      this.shippingCity,
      this.shippingZoneId,
      this.shippingZone,
      this.shippingZoneCode,
      this.shippingCountryId,
      this.shippingCountry,
      this.shippingIsoCode2,
      this.shippingIsoCode3,
      this.shippingAddressFormat,
      this.shippingCustomField,
      this.shippingMethod,
      this.shippingCode,
      this.comment,
      this.image,
      this.total,
      this.reward,
      this.orderStatusId,
      this.orderStatus,
      this.affiliateId,
      this.affiliateFirstname,
      this.affiliateLastname,
      this.commission,
      this.languageId,
      this.languageCode,
      this.currencyId,
      this.currencyCode,
      this.currencyValue,
      this.ip,
      this.forwardedIp,
      this.userAgent,
      this.acceptLanguage,
      this.dateAdded,
      this.dateModified,
      this.configTabbyCapture,
      this.customerData,
      this.customerGroup,
      this.products,
      this.totalData});

  DataOrder.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    invoiceNo = json['invoice_no'];
    invoicePrefix = json['invoice_prefix'];
    storeId = json['store_id'];
    storeName = json['store_name'];
    storeUrl = json['store_url'];
    customerId = json['customer_id'];
    customer = json['customer'];
    customerGroupId = json['customer_group_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    telephone = json['telephone'];
    orderShippingId = json['order_shipping_id'];
    customField = json['custom_field'];
    paymentFirstname = json['payment_firstname'];
    paymentLastname = json['payment_lastname'];
    paymentCompany = json['payment_company'];
    paymentAddress1 = json['payment_address_1'];
    paymentAddress2 = json['payment_address_2'];
    paymentPostcode = json['payment_postcode'];
    paymentCity = json['payment_city'];
    paymentZoneId = json['payment_zone_id'];
    paymentZone = json['payment_zone'];
    paymentZoneCode = json['payment_zone_code'];
    paymentCountryId = json['payment_country_id'];
    paymentCountry = json['payment_country'];
    paymentIsoCode2 = json['payment_iso_code_2'];
    paymentIsoCode3 = json['payment_iso_code_3'];
    paymentAddressFormat = json['payment_address_format'];

    paymentMethod = json['payment_method'];
    paymentCode = json['payment_code'];
    shippingFirstname = json['shipping_firstname'];
    shippingLastname = json['shipping_lastname'];
    shippingCompany = json['shipping_company'];
    shippingAddress1 = json['shipping_address_1'];
    shippingAddress2 = json['shipping_address_2'];
    shippingPostcode = json['shipping_postcode'];
    shippingCity = json['shipping_city'];
    shippingZoneId = json['shipping_zone_id'];
    shippingZone = json['shipping_zone'];
    shippingZoneCode = json['shipping_zone_code'];
    shippingCountryId = json['shipping_country_id'];
    shippingCountry = json['shipping_country'];
    shippingIsoCode2 = json['shipping_iso_code_2'];
    shippingIsoCode3 = json['shipping_iso_code_3'];
    shippingAddressFormat = json['shipping_address_format'];

    shippingMethod = json['shipping_method'];
    shippingCode = json['shipping_code'];
    comment = json['comment'];
    image = json['image'];
    total = json['total'];
    reward = json['reward'];
    orderStatusId = json['order_status_id'];
    orderStatus = json['order_status'];
    affiliateId = json['affiliate_id'];
    affiliateFirstname = json['affiliate_firstname'];
    affiliateLastname = json['affiliate_lastname'];
    commission = json['commission'];
    languageId = json['language_id'];
    languageCode = json['language_code'];
    currencyId = json['currency_id'];
    currencyCode = json['currency_code'];
    currencyValue = json['currency_value'];
    ip = json['ip'];
    forwardedIp = json['forwarded_ip'];
    userAgent = json['user_agent'];
    acceptLanguage = json['accept_language'];
    dateAdded = json['date_added'];
    dateModified = json['date_modified'];
    configTabbyCapture = json['config_tabby_capture'];
    // if (json['customer_data'] != null) {
    //   customerData = <CustomerData>[];
    //   json['customer_data'].forEach((v) {
    //     customerData!.add(new CustomerData.fromJson(v));
    //   });
    // }
    if (json['histories'] != null) {
      histories = <History>[];
      json['histories'].forEach((v) {
        histories!.add(History.fromJson(v));
      });
    }

    customerGroup = json['customer_group'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    if (json['total_data'] != null) {
      totalData = <TotalData>[];
      json['total_data'].forEach((v) {
        totalData!.add(TotalData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['invoice_no'] = invoiceNo;
    data['invoice_prefix'] = invoicePrefix;
    data['store_id'] = storeId;
    data['store_name'] = storeName;
    data['store_url'] = storeUrl;
    data['customer_id'] = customerId;
    data['customer'] = customer;
    data['customer_group_id'] = customerGroupId;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['telephone'] = telephone;
    data['order_shipping_id'] = orderShippingId;
    data['custom_field'] = customField;
    data['payment_firstname'] = paymentFirstname;
    data['payment_lastname'] = paymentLastname;
    data['payment_company'] = paymentCompany;
    data['payment_address_1'] = paymentAddress1;
    data['payment_address_2'] = paymentAddress2;
    data['payment_postcode'] = paymentPostcode;
    data['payment_city'] = paymentCity;
    data['payment_zone_id'] = paymentZoneId;
    data['payment_zone'] = paymentZone;
    data['payment_zone_code'] = paymentZoneCode;
    data['payment_country_id'] = paymentCountryId;
    data['payment_country'] = paymentCountry;
    data['payment_iso_code_2'] = paymentIsoCode2;
    data['payment_iso_code_3'] = paymentIsoCode3;
    data['payment_address_format'] = paymentAddressFormat;

    data['payment_method'] = paymentMethod;
    data['payment_code'] = paymentCode;
    data['shipping_firstname'] = shippingFirstname;
    data['shipping_lastname'] = shippingLastname;
    data['shipping_company'] = shippingCompany;
    data['shipping_address_1'] = shippingAddress1;
    data['shipping_address_2'] = shippingAddress2;
    data['shipping_postcode'] = shippingPostcode;
    data['shipping_city'] = shippingCity;
    data['shipping_zone_id'] = shippingZoneId;
    data['shipping_zone'] = shippingZone;
    data['shipping_zone_code'] = shippingZoneCode;
    data['shipping_country_id'] = shippingCountryId;
    data['shipping_country'] = shippingCountry;
    data['shipping_iso_code_2'] = shippingIsoCode2;
    data['shipping_iso_code_3'] = shippingIsoCode3;
    data['shipping_address_format'] = shippingAddressFormat;

    data['shipping_method'] = shippingMethod;
    data['shipping_code'] = shippingCode;
    data['comment'] = comment;
    data['image'] = image;
    data['total'] = total;
    data['reward'] = reward;
    data['order_status_id'] = orderStatusId;
    data['order_status'] = orderStatus;
    data['affiliate_id'] = affiliateId;
    data['affiliate_firstname'] = affiliateFirstname;
    data['affiliate_lastname'] = affiliateLastname;
    data['commission'] = commission;
    data['language_id'] = languageId;
    data['language_code'] = languageCode;
    data['currency_id'] = currencyId;
    data['currency_code'] = currencyCode;
    data['currency_value'] = currencyValue;
    data['ip'] = ip;
    data['forwarded_ip'] = forwardedIp;
    data['user_agent'] = userAgent;
    data['accept_language'] = acceptLanguage;
    data['date_added'] = dateAdded;
    data['date_modified'] = dateModified;
    data['config_tabby_capture'] = configTabbyCapture;
    if (customerData != null) {
      data['customer_data'] = customerData!.map((v) => v.toJson()).toList();
    }
    if (histories != null) {
      data['histories'] = histories!.map((v) => v.toJson()).toList();
    }
    data['customer_group'] = customerGroup;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    if (totalData != null) {
      data['total_data'] = totalData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerData {
  String? customerGroupId;
  String? approval;
  String? sortOrder;
  String? languageId;
  String? name;
  String? description;

  CustomerData(
      {this.customerGroupId,
      this.approval,
      this.sortOrder,
      this.languageId,
      this.name,
      this.description});

  CustomerData.fromJson(Map<String, dynamic> json) {
    customerGroupId = json['customer_group_id'];
    approval = json['approval'];
    sortOrder = json['sort_order'];
    languageId = json['language_id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_group_id'] = customerGroupId;
    data['approval'] = approval;
    data['sort_order'] = sortOrder;
    data['language_id'] = languageId;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}

class Products extends Productss {
  String? orderProductId;
  String? productIdP;
  String? nameP;
  String? imageP;
  String? model;
  List<Null>? option;
  @override
  dynamic quantity;
  dynamic productPrice;
  dynamic totalOrderWithoutTax;

  Products({
    this.orderProductId,
    this.productIdP,
    this.nameP,
    this.imageP,
    this.model,
    this.option,
    this.quantity,
    this.productPrice,
    this.totalOrderWithoutTax,
    required super.name,
    required super.productId,
    required super.price,
    required super.description,
    required super.image,
    required productIP,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      name: json['name'],
      productId: json['product_id'],
      price: json['product_price'],
      description: json['model'],
      image: json['image'],
      productIP: json['product_id'],
      orderProductId: json['order_product_id'],
      productIdP: json['product_id'],
      nameP: json['name'],
      imageP: json['image'],
      model: json['model'],
      quantity: json['quantity'],
      productPrice: json['product_price'],
      totalOrderWithoutTax: json['total_order_without_tax'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['order_product_id'] = orderProductId;
    data['product_id'] = productId;
    data['name'] = name;
    data['image'] = image;
    data['model'] = model;

    data['quantity'] = quantity;
    data['product_price'] = productPrice;
    data['total_order_without_tax'] = totalOrderWithoutTax;
    return data;
  }
}

class TotalData {
  String? title;
  dynamic text;

  TotalData({this.title, this.text});

  TotalData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['text'] = text;
    return data;
  }
}
