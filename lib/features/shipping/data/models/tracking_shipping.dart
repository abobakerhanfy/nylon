class TrackingShipping {
  Data? data;
  bool? success;

  TrackingShipping({this.data, this.success});

  TrackingShipping.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class Data {
  String? orderTrackId;
  String? linkSmsa;
  String? invoiceNo;
  String? orderId;
  String? orderShippingId;
  String? dateAdded;
  String? paymentMethod;
  String? shippingMethod;
  List<Products>? products;
  List<Totals>? totals;
  String? comment;
  List<Histories>? histories;

  Data(
      {this.invoiceNo,
      this.orderId,
      this.orderShippingId,
      this.dateAdded,
      this.paymentMethod,
      this.shippingMethod,
      this.products,
      this.totals,
      this.comment,
      this.histories});

  Data.fromJson(Map<String, dynamic> json) {
    orderTrackId = json['Order_Track_id'];
    linkSmsa = json['link_smsa'];
    invoiceNo = json['invoice_no'];
    orderId = json['order_id'];
    orderShippingId = json['order_shipping_id'];
    dateAdded = json['date_added'];
    paymentMethod = json['payment_method'];
    shippingMethod = json['shipping_method'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }

    if (json['totals'] != null) {
      totals = <Totals>[];
      json['totals'].forEach((v) {
        totals!.add(Totals.fromJson(v));
      });
    }
    comment = json['comment'];
    if (json['histories'] != null) {
      histories = <Histories>[];
      json['histories'].forEach((v) {
        histories!.add(Histories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invoice_no'] = invoiceNo;
    data['order_id'] = orderId;
    data['order_shipping_id'] = orderShippingId;
    data['date_added'] = dateAdded;
    data['payment_method'] = paymentMethod;
    data['shipping_method'] = shippingMethod;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    if (totals != null) {
      data['totals'] = totals!.map((v) => v.toJson()).toList();
    }
    data['comment'] = comment;
    if (histories != null) {
      data['histories'] = histories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? href;
  String? name;
  String? model;
  String? quantity;
  String? price;
  String? total;

  Products(
      {this.href,
      this.name,
      this.model,
      this.quantity,
      this.price,
      this.total});

  Products.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    name = json['name'];
    model = json['model'];
    quantity = json['quantity'];
    price = json['price'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['href'] = href;
    data['name'] = name;
    data['model'] = model;

    data['quantity'] = quantity;
    data['price'] = price;
    data['total'] = total;
    return data;
  }
}

class Totals {
  String? title;
  String? text;

  Totals({this.title, this.text});

  Totals.fromJson(Map<String, dynamic> json) {
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

class Histories {
  String? dateAdded;
  String? status;
  String? comment;

  Histories({this.dateAdded, this.status, this.comment});

  Histories.fromJson(Map<String, dynamic> json) {
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
