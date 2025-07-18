import 'package:nylon/features/addresses/data/models/address_model.dart';
import 'package:nylon/features/login/data/models/user.dart';

class UserData {
  String success;
  User customer;
  List<Address>? addressList;

  UserData({
    required this.success,
    required this.customer,
    this.addressList,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    List<Address>? addressList;

    if (json['address'] != null && json['address'] is Map<String, dynamic> && json['address'].isNotEmpty) {
      addressList = json['address'].values.map<Address>((value) => Address.fromJson(value)).toList();
    } else {
      addressList = []; // تعيين قائمة فارغة إذا لم يكن هناك عنوان
    }

    return UserData(
      success: json['success'],
      customer: User.fromJson(json['data']),
      addressList: addressList,
    );
  }
}
