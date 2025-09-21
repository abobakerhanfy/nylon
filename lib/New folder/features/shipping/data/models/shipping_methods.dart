class ShippingMethodsModel {
  Map<String, ShippingMethod>? methods;

  ShippingMethodsModel({this.methods});

  ShippingMethodsModel.fromJson(Map<String, dynamic> json) {
    if (json['shipping_methods'] != null) {
      methods = (json['shipping_methods'] as Map<String, dynamic>).map((key, value) {
        return MapEntry(key, ShippingMethod.fromJson(value));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (methods != null) {
      data['shipping_methods'] = methods!.map((key, value) => MapEntry(key, value.toJson()));
    }
    return data;
  }

  List<ShippingMethod> toShippingDataList() {
    return methods?.values.toList() ?? [];
  }
}

class ShippingMethod {
  String? title;
  Map<String, Quote>? quotes; 
  String? sortOrder;
  bool? error;

  ShippingMethod({this.title, this.quotes, this.sortOrder, this.error});

  ShippingMethod.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    print('Quotes JSON: ${json['quote']}');  // تحقق من محتوى quote
    if (json['quote'] != null) {
      quotes = (json['quote'] as Map<String, dynamic>).map((key, value) => MapEntry(key, Quote.fromJson(value)));
    }
    sortOrder = json['sort_order'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['title'] = title;
    if (quotes != null) {
      data['quote'] = quotes!.map((key, value) => MapEntry(key, value.toJson()));
    }
    data['sort_order'] = sortOrder;
    data['error'] = error;
    return data;
  }
}

class Quote {
  String? code;
  String? title;
  dynamic cost;  
  dynamic taxClassId;
  String? text;

  Quote({this.code, this.title, this.cost, this.taxClassId, this.text});

  Quote.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    title = json['title'];
    cost = json['cost'];
    taxClassId = json['tax_class_id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['code'] = code;
    data['title'] = title;
    data['cost'] = cost;
    data['tax_class_id'] = taxClassId;
    data['text'] = text;
    return data;
  }
}
