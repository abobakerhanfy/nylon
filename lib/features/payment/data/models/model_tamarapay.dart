class TamarapayModel {
  String? success;
  CheckoutData? checkoutData;
  TamarapayModel({this.success, this.checkoutData});

  TamarapayModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    checkoutData = json['checkout_data'] != null
        ? CheckoutData.fromJson(json['checkout_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (checkoutData != null) {
      data['checkout_data'] = checkoutData!.toJson();
    }
    return data;
  }
}

class CheckoutData {
  String? checkoutSuccessUrl;
  String? checkoutFailureUrl;
  String? checkoutCancelUrl;
  int? opencartOrderId;
  String? tamaraOrderId;
  String? checkoutRedirectUrl;

  CheckoutData(
      {this.checkoutSuccessUrl,
      this.checkoutFailureUrl,
      this.checkoutCancelUrl,
      this.opencartOrderId,
      this.tamaraOrderId,
      this.checkoutRedirectUrl});

  CheckoutData.fromJson(Map<String, dynamic> json) {
    checkoutSuccessUrl = json['checkout_success_url'];
    checkoutFailureUrl = json['checkout_failure_url'];
    checkoutCancelUrl = json['checkout_cancel_url'];
    opencartOrderId = json['opencart_order_id'];
    tamaraOrderId = json['tamara_order_id'];
    checkoutRedirectUrl = json['checkout_redirect_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['checkout_success_url'] = checkoutSuccessUrl;
    data['checkout_failure_url'] = checkoutFailureUrl;
    data['checkout_cancel_url'] = checkoutCancelUrl;
    data['opencart_order_id'] = opencartOrderId;
    data['tamara_order_id'] = tamaraOrderId;
    data['checkout_redirect_url'] = checkoutRedirectUrl;
    return data;
  }
}
