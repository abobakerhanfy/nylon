class User {
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
  String? cart;
  String? wishlist;
  String? newsletter;
  String? addressId;
  String? customField;
  String? ip;
  String? status;
  String? safe;
  String? token;
  String? code;
  String? dateAdded;
  String? telephoneStatus;
  String? activation;
  String? activeCode;
  String? typelogin;
  String? dateModified;
  String? image;

  User({
    this.customerId,
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
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      customerId: json['customer_id'],
      customerGroupId: json['customer_group_id'],
      storeId: json['store_id'],
      languageId: json['language_id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      telephone: json['telephone'],
      fax: json['fax'],
      password: json['password'],
      salt: json['salt'],
      cart: json['cart'],
      wishlist: json['wishlist'],
      newsletter: json['newsletter'],
      addressId: json['address_id'],
      customField: json['custom_field'],
      ip: json['ip'],
      status: json['status'],
      safe: json['safe'],
      token: json['token'],
      code: json['code'],
      dateAdded: json['date_added'],
      telephoneStatus: json['telephone_status'],
      activation: json['activation'],
      activeCode: json['active_code'],
      typelogin: json['typelogin'],
      dateModified: json['date_modified'],
      image: json['image'],
    );
  }
}
