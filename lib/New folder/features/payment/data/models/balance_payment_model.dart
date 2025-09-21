class BalancePaymentModel {
  int? orderId;
  String? success;

  BalancePaymentModel({this.orderId, this.success});

  BalancePaymentModel.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'] != null
        ? int.tryParse(json['order_id'].toString())
        : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['success'] = success;
    return data;
  }
}
