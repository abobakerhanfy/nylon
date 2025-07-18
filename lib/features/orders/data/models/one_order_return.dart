class ReturnOneOrder {
  String? success;
  List<ModelDataOrder>? data;

  ReturnOneOrder({this.success, this.data});

  ReturnOneOrder.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ModelDataOrder>[];
      json['data'].forEach((v) {
        data!.add(ModelDataOrder.fromJson(v));
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

class ModelDataOrder {
  Data? orderdata;
  List<History>? history;
  List<Shipping>? shipping;

  ModelDataOrder({this.orderdata, this.history, this.shipping});

  ModelDataOrder.fromJson(Map<String, dynamic> json) {
    orderdata = json['data'] != null ? Data.fromJson(json['data']) : null;
    if (json['history'] != null) {
      history = <History>[];
      json['history'].forEach((v) {
        history!.add(History.fromJson(v));
      });
    }
    if (json['shipping'] != null) {
      shipping = <Shipping>[];
      json['shipping'].forEach((v) {
        shipping!.add(Shipping.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orderdata != null) {
      data['data'] = orderdata!.toJson();
    }
    if (history != null) {
      data['history'] = history!.map((v) => v.toJson()).toList();
    }
    if (shipping != null) {
      data['shipping'] = shipping!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? returnId;
  String? orderId;
  String? firstname;
  String? lastname;
  String? email;
  String? telephone;
  String? product;
  String? model;
  String? quantity;
  String? opened;
  String? reason;
  String? action;
  String? status;
  String? comment;
  String? dateOrdered;
  String? dateAdded;
  String? dateModified;

  Data(
      {this.returnId,
      this.orderId,
      this.firstname,
      this.lastname,
      this.email,
      this.telephone,
      this.product,
      this.model,
      this.quantity,
      this.opened,
      this.reason,
      this.action,
      this.status,
      this.comment,
      this.dateOrdered,
      this.dateAdded,
      this.dateModified});

  Data.fromJson(Map<String, dynamic> json) {
    returnId = json['return_id'];
    orderId = json['order_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    telephone = json['telephone'];
    product = json['product'];
    model = json['model'];
    quantity = json['quantity'];
    opened = json['opened'];
    reason = json['reason'];
    action = json['action'];
    status = json['status'];
    comment = json['comment'];
    dateOrdered = json['date_ordered'];
    dateAdded = json['date_added'];
    dateModified = json['date_modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['return_id'] = returnId;
    data['order_id'] = orderId;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['telephone'] = telephone;
    data['product'] = product;
    data['model'] = model;
    data['quantity'] = quantity;
    data['opened'] = opened;
    data['reason'] = reason;
    data['action'] = action;
    data['status'] = status;
    data['comment'] = comment;
    data['date_ordered'] = dateOrdered;
    data['date_added'] = dateAdded;
    data['date_modified'] = dateModified;
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

class Shipping {
  String? shippingAddress1;

  Shipping({this.shippingAddress1});

  Shipping.fromJson(Map<String, dynamic> json) {
    shippingAddress1 = json['shipping_address_1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shipping_address_1'] = shippingAddress1;
    return data;
  }
}
