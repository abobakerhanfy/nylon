class TamarapayCheckOrdersuccess {
  bool? success;
  String? message;
  String? orderId;

  TamarapayCheckOrdersuccess({this.success, this.message, this.orderId});

  TamarapayCheckOrdersuccess.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['order_id'] = orderId;
    return data;
  }
}

class TamarapayCheckOrdErerror {
  bool? success;
  String? error;

  TamarapayCheckOrdErerror({this.success, this.error});

  TamarapayCheckOrdErerror.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    return data;
  }
}
