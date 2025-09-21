class SelectPaymentModel {
  int? sessionData;
  String? success;
  int? orderId;
  dynamic webUrl;

  SelectPaymentModel(
      {this.sessionData, this.success, this.orderId, this.webUrl});

  SelectPaymentModel.fromJson(Map<String, dynamic> json) {
    sessionData = json['session_data'];
    success = json['success'];
    orderId = json['order_id'];
    webUrl = json['web_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['session_data'] = sessionData;
    data['success'] = success;
    data['order_id'] = orderId;
    data['web_url'] = webUrl;
    return data;
  }
}
