class ModelAllOrder {
  List<Order>? data;
  String? success;

  ModelAllOrder({this.data, this.success});

  ModelAllOrder.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Order>[];
      json['data'].forEach((v) {
        data!.add(Order.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class Order {
  String? orderId;
  String? invoiceNo;
  String? invoicePrefix;
  String? orderShippingId;
  String? storeId;
  String? storeName;
  String? storeUrl;
  String? customerId;
  String? firstname;
  String? lastname;
  String? telephone;
  String? email;
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
  String? paymentMethod;
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
  String? shippingMethod;
  String? comment;
  String? total;
  String? orderStatusId;
  String? orderStatus;
  String? languageId;
  String? currencyId;
  String? currencyCode;
  String? currencyValue;
  String? dateModified;
  String? dateAdded;
  String? ip;

  Order(
      {this.orderId,
      this.invoiceNo,
      this.invoicePrefix,
      this.orderShippingId,
      this.storeId,
      this.storeName,
      this.storeUrl,
      this.customerId,
      this.firstname,
      this.lastname,
      this.telephone,
      this.email,
      this.orderStatus,
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
      this.paymentMethod,
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
      this.shippingMethod,
      this.comment,
      this.total,
      this.orderStatusId,
      this.languageId,
      this.currencyId,
      this.currencyCode,
      this.currencyValue,
      this.dateModified,
      this.dateAdded,
      this.ip});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    invoiceNo = json['invoice_no'];
    invoicePrefix = json['invoice_prefix'];
    orderShippingId = json['order_shipping_id'];
    storeId = json['store_id'];
    storeName = json['store_name'];
    storeUrl = json['store_url'];
    customerId = json['customer_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    telephone = json['telephone'];
    email = json['email'];
    orderStatus = json['order_status'];
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
    comment = json['comment'];
    total = json['total'];
    orderStatusId = json['order_status_id'];
    languageId = json['language_id'];
    currencyId = json['currency_id'];
    currencyCode = json['currency_code'];
    currencyValue = json['currency_value'];
    dateModified = json['date_modified'];
    dateAdded = json['date_added'];
    ip = json['ip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['invoice_no'] = invoiceNo;
    data['invoice_prefix'] = invoicePrefix;
    data['order_shipping_id'] = orderShippingId;
    data['store_id'] = storeId;
    data['store_name'] = storeName;
    data['store_url'] = storeUrl;
    data['customer_id'] = customerId;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['telephone'] = telephone;
    data['email'] = email;
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
    data['comment'] = comment;
    data['total'] = total;
    data['order_status_id'] = orderStatusId;
    data['language_id'] = languageId;
    data['currency_id'] = currencyId;
    data['currency_code'] = currencyCode;
    data['currency_value'] = currencyValue;
    data['date_modified'] = dateModified;
    data['date_added'] = dateAdded;
    data['ip'] = ip;
    return data;
  }
}
