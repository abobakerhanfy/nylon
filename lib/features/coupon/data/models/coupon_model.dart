class CouponsModel {
  List<Coupon>? coupon;

  CouponsModel({this.coupon});

  CouponsModel.fromJson(Map<String, dynamic> json) {
    if (json['coupon'] != null) {
      coupon = <Coupon>[];
      json['coupon'].forEach((v) {
        coupon!.add(Coupon.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (coupon != null) {
      data['coupon'] = coupon!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coupon {
  String? couponId;
  String? code;
  String? type;
  String? numberOfUsers;
  String? status;
  String? couponEnd;
  String? totalOrder;
  String? logged;
  String? shipping;
  String? discount;

  Coupon(
      {this.couponId,
      this.code,
      this.type,
      this.numberOfUsers,
      this.status,
      this.couponEnd,
      this.totalOrder,
      this.logged,
      this.discount,
      this.shipping});

  Coupon.fromJson(Map<String, dynamic> json) {
    couponId = json['coupon_id'];
    code = json['code'];
    type = json['type'];
    numberOfUsers = json['Number_of_users'];
    status = json['status'];
    couponEnd = json['coupon_end'];
    totalOrder = json['totalOrder'];
    logged = json['logged'];
    shipping = json['shipping'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coupon_id'] = couponId;
    data['code'] = code;
    data['type'] = type;
    data['Number_of_users'] = numberOfUsers;
    data['status'] = status;
    data['coupon_end'] = couponEnd;
    data['totalOrder'] = totalOrder;
    data['logged'] = logged;
    data['shipping'] = shipping;
    data['discount'] = discount;
    return data;
  }
}
