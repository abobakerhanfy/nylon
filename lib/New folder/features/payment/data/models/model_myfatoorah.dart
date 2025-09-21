class ModelMyFatoorah {
  String? status;
  int? invoiceId;
  String? paymentUrl;
  bool? success;

  ModelMyFatoorah({this.status, this.invoiceId, this.paymentUrl, this.success});

  ModelMyFatoorah.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    invoiceId = json['invoiceId'] ?? json['invoice_id'];
    paymentUrl =
        json['invoiceURL'] ?? json['payment_url']; // ✅ دعم المفتاح الجديد
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'invoice_id': invoiceId,
      'payment_url': paymentUrl,
      'success': success,
    };
  }
}
