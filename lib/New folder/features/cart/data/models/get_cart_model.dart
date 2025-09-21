import 'package:nylon/features/home/data/models/mobile_featured.dart';

class GetCartModel {
  List<Products>? products;
  List<Totals>? totals;

  GetCartModel({this.products, this.totals});

  factory GetCartModel.fromJson(Map<String, dynamic> json) {
    return GetCartModel(
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Products.fromJson(e as Map<String, dynamic>))
          .toList(),
      totals: (json['totals'] as List<dynamic>?)
          ?.map((e) => Totals.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    if (totals != null) {
      data['totals'] = totals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products extends Productss {
  String? cartId;
  String? productIdC;
  String? nameC;
  String? model;
  List<Null>? option;
  String? quantityC;
  bool? stock;
  String? imageC;
  String? shipping;
  String? priceC;
  String? total;
  int? reward;

  Products({
    this.cartId,
    this.productIdC,
    this.nameC,
    this.model,
    this.option,
    this.quantityC,
    this.stock,
    this.shipping,
    this.priceC,
    this.total,
    this.imageC,
    this.reward,
    required super.name,
    required super.productId,
    required super.price,
    required super.description,
    required super.quantity,
    required super.image,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
        cartId: json['cart_id'],
        productIdC: json['product_id'],
        nameC: json['name'],
        model: json['model'],
        imageC: json["image"],
        quantityC: json['quantity'],
        stock: json['stock'],
        shipping: json['shipping'],
        priceC: json['price'],
        total: json['total'],
        reward: json['reward'],
        name: json['name'],
        productId: json['product_id'],
        price: json['price'],
        description: json['model'],
        quantity: json['quantity'],
        image: json["image"]);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['product_id'] = productId;
    data['name'] = name;
    data['model'] = model;
    data["image"] = image;
    data['quantity'] = quantity;
    data['stock'] = stock;
    data['shipping'] = shipping;
    data['price'] = price;
    data['total'] = total;
    data['reward'] = reward;
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
