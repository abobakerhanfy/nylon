// class Address {
//   String? addressId;
//   String? firstname;
//   String? lastname;
//   String? company;
//   String? address1;
//   String? address2;
//   String? postcode;
//   String? city;
//   String? zoneId;
//   String? zone;
//   String? zoneCode;
//   String? countryId;
//   String? country;
//   String? isoCode2;
//   String? isoCode3;
//   String? addressFormat;
//   String? customField;

//   Address({
//     this.addressId,
//     this.firstname,
//     this.lastname,
//     this.company,
//     this.address1,
//     this.address2,
//     this.postcode,
//     this.city,
//     this.zoneId,
//     this.zone,
//     this.zoneCode,
//     this.countryId,
//     this.country,
//     this.isoCode2,
//     this.isoCode3,
//     this.addressFormat,
//     this.customField,
//   });

//   factory Address.fromJson(Map<String, dynamic> json) {
//     return Address(
//       addressId: json['address_id'],
//       firstname: json['firstname'],
//       lastname: json['lastname'],
//       company: json['company'],
//       address1: json['address_1'],
//       address2: json['address_2'],
//       postcode: json['postcode'],
//       city: json['city'],
//       zoneId: json['zone_id'],
//       zone: json['zone'],
//       zoneCode: json['zone_code'],
//       countryId: json['country_id'],
//       country: json['country'],
//       isoCode2: json['iso_code_2'],
//       isoCode3: json['iso_code_3'],
//       addressFormat: json['address_format'],
//       customField: json['custom_field'],
//     );
//   }
// }
class AddressModel {
  String? success;
  Data? data;

  AddressModel({this.success, this.data});

  AddressModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  CustomerData? customerData;
  List<Address>? address;

  Data({this.customerData, this.address});

  Data.fromJson(Map<String, dynamic> json) {
    customerData = json['customer_data'] != null
        ? CustomerData.fromJson(json['customer_data'])
        : null;
    if (json['address'] != null) {
      address = <Address>[];
      json['address'].forEach((v) {
        address!.add(Address.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (customerData != null) {
      data['customer_data'] = customerData!.toJson();
    }
    if (address != null) {
      data['address'] = address!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerData {
  String? customerId;
  String? customerGroupId;
  String? storeId;
  String? languageId;
  String? firstname;
  String? lastname;
  String? email;
  String? telephone;
  String? fax;
  String? password;
  String? salt;
  dynamic cart;
  dynamic wishlist;
  String? newsletter;
  String? addressId;
  String? customField;
  String? ip;
  String? status;
  String? safe;
  String? token;
  String? code;
  String? dateAdded;
  dynamic telephoneStatus;
  String? activation;
  String? activeCode;
  dynamic typelogin;
  String? dateModified;
  String? image;

  CustomerData(
      {this.customerId,
      this.customerGroupId,
      this.storeId,
      this.languageId,
      this.firstname,
      this.lastname,
      this.email,
      this.telephone,
      this.fax,
      this.password,
      this.salt,
      this.cart,
      this.wishlist,
      this.newsletter,
      this.addressId,
      this.customField,
      this.ip,
      this.status,
      this.safe,
      this.token,
      this.code,
      this.dateAdded,
      this.telephoneStatus,
      this.activation,
      this.activeCode,
      this.typelogin,
      this.dateModified,
      this.image});

  CustomerData.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerGroupId = json['customer_group_id'];
    storeId = json['store_id'];
    languageId = json['language_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    telephone = json['telephone'];
    fax = json['fax'];
    password = json['password'];
    salt = json['salt'];
    cart = json['cart'];
    wishlist = json['wishlist'];
    newsletter = json['newsletter'];
    addressId = json['address_id'];
    customField = json['custom_field'];
    ip = json['ip'];
    status = json['status'];
    safe = json['safe'];
    token = json['token'];
    code = json['code'];
    dateAdded = json['date_added'];
    telephoneStatus = json['telephone_status'];
    activation = json['activation'];
    activeCode = json['active_code'];
    typelogin = json['typelogin'];
    dateModified = json['date_modified'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['customer_group_id'] = customerGroupId;
    data['store_id'] = storeId;
    data['language_id'] = languageId;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['telephone'] = telephone;
    data['fax'] = fax;
    data['password'] = password;
    data['salt'] = salt;
    data['cart'] = cart;
    data['wishlist'] = wishlist;
    data['newsletter'] = newsletter;
    data['address_id'] = addressId;
    data['custom_field'] = customField;
    data['ip'] = ip;
    data['status'] = status;
    data['safe'] = safe;
    data['token'] = token;
    data['code'] = code;
    data['date_added'] = dateAdded;
    data['telephone_status'] = telephoneStatus;
    data['activation'] = activation;
    data['active_code'] = activeCode;
    data['typelogin'] = typelogin;
    data['date_modified'] = dateModified;
    data['image'] = image;
    return data;
  }
}

class Address {
  String? addressId;
  String? customerId;
  String? firstname;
  String? lastname;
  String? company;
  String? address1;
  String? address2;
  String? city;
  String? postcode;
  String? countryId;
  String? zoneId;
  String? customField;
  String? phone;
  String? phoneStatus;
  String? countryShortName;
  String? province;
  String? neighborhood;
  String? street;
  String? streetNumber;
  String? postalCodeSuffix;
  String? country;
  String? addressDefault;

  Address(
      {this.addressId,
      this.customerId,
      this.firstname,
      this.lastname,
      this.company,
      this.address1,
      this.address2,
      this.city,
      this.postcode,
      this.countryId,
      this.zoneId,
      this.customField,
      this.phone,
      this.phoneStatus,
      this.countryShortName,
      this.province,
      this.neighborhood,
      this.street,
      this.streetNumber,
      this.postalCodeSuffix,
      this.country,
      this.addressDefault});

  Address.fromJson(Map<String, dynamic> json) {
    addressId = json['address_id'];
    customerId = json['customer_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    company = json['company'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    postcode = json['postcode'];
    countryId = json['country_id'];
    zoneId = json['zone_id'];
    customField = json['custom_field'];
    phone = json['phone'];
    phoneStatus = json['phone_status'];
    countryShortName = json['country_short_name'];
    province = json['province'];
    neighborhood = json['neighborhood'];
    street = json['street'];
    streetNumber = json['street_number'];
    postalCodeSuffix = json['postal_code_suffix'];
    country = json['country'];
    addressDefault = json['address_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address_id'] = addressId;
    data['customer_id'] = customerId;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['company'] = company;
    data['address_1'] = address1;
    data['address_2'] = address2;
    data['city'] = city;
    data['postcode'] = postcode;
    data['country_id'] = countryId;
    data['zone_id'] = zoneId;
    data['custom_field'] = customField;
    data['phone'] = phone;
    data['phone_status'] = phoneStatus;
    data['country_short_name'] = countryShortName;
    data['province'] = province;
    data['neighborhood'] = neighborhood;
    data['street'] = street;
    data['street_number'] = streetNumber;
    data['postal_code_suffix'] = postalCodeSuffix;
    data['country'] = country;
    data['address_default'] = addressDefault;
    return data;
  }
}
