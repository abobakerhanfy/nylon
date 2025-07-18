class GetBalanceModel {
  int balance;
  int customerId;

  GetBalanceModel({required this.balance, required this.customerId});

  factory GetBalanceModel.fromJson(Map<String, dynamic> json) {
    return GetBalanceModel(
      balance: json['balance'] ?? 0,
      customerId: json['customer_id'] ?? 0,
    );
  }
}
