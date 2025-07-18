class ReturnOrdersResponse {
  String? success;
  List<Data>? data;

  ReturnOrdersResponse({this.success, this.data});

  ReturnOrdersResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? returnId;
  String? orderId;
  String? productId;
  String? customerId;
  String? firstname;
  String? lastname;
  String? email;
  String? telephone;
  String? product;
  String? quantity;
  String? returnReasonId;
  String? returnReasonCode;
  String? returnActionId;
  String? returnActionCode;
  String? returnStatusId;
  String? returnStatusCode;
  String? comment;
  String? dateAdded;
  String? name;
  List<History>? history;
  String? address;

  Data(
      {this.returnId,
      this.orderId,
      this.productId,
      this.customerId,
      this.firstname,
      this.lastname,
      this.email,
      this.telephone,
      this.product,
      this.quantity,
      this.returnReasonId,
      this.returnReasonCode,
      this.returnActionId,
      this.returnActionCode,
      this.returnStatusId,
      this.returnStatusCode,
      this.comment,
      this.dateAdded,
      this.name,
      this.history,
      this.address});

  Data.fromJson(Map<String, dynamic> json) {
    returnId = json['return_id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    customerId = json['customer_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    telephone = json['telephone'];
    product = json['product'];
    quantity = json['quantity'];
    returnReasonId = json['return_reason_id'];
    returnReasonCode = json['return_reason_code'];
    returnActionId = json['return_action_id'];
    returnActionCode = json['return_action_code'];
    returnStatusId = json['return_status_id'];
    returnStatusCode = json['return_status_code'];
    comment = json['comment'];
    dateAdded = json['date_added'];
    name = json['name'];
    if (json['History'] != null) {
      history = <History>[];
      json['History'].forEach((v) {
        history!.add(History.fromJson(v));
      });
    }
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['return_id'] = returnId;
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['customer_id'] = customerId;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['telephone'] = telephone;
    data['product'] = product;
    data['quantity'] = quantity;
    data['return_reason_id'] = returnReasonId;
    data['return_reason_code'] = returnReasonCode;
    data['return_action_id'] = returnActionId;
    data['return_action_code'] = returnActionCode;
    data['return_status_id'] = returnStatusId;
    data['return_status_code'] = returnStatusCode;
    data['comment'] = comment;
    data['date_added'] = dateAdded;
    data['name'] = name;
    if (history != null) {
      data['History'] = history!.map((v) => v.toJson()).toList();
    }
    data['address'] = address;
    return data;
  }
}

class History {
  String? returnHistoryId;
  String? returnId;
  String? returnStatusId;
  String? notify;
  String? comment;
  String? dateAdded;

  History(
      {this.returnHistoryId,
      this.returnId,
      this.returnStatusId,
      this.notify,
      this.comment,
      this.dateAdded});

  History.fromJson(Map<String, dynamic> json) {
    returnHistoryId = json['return_history_id'];
    returnId = json['return_id'];
    returnStatusId = json['return_status_id'];
    notify = json['notify'];
    comment = json['comment'];
    dateAdded = json['date_added'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['return_history_id'] = returnHistoryId;
    data['return_id'] = returnId;
    data['return_status_id'] = returnStatusId;
    data['notify'] = notify;
    data['comment'] = comment;
    data['date_added'] = dateAdded;
    return data;
  }
}
