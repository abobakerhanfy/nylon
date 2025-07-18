import 'package:nylon/features/home/data/models/mobile_featured.dart';

class FavoritesModel {
  List<Products>? products;

  FavoritesModel({this.products});

  FavoritesModel.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products extends Productss {
  String? productIdP;
  String? thumb;
  String? nameP;
  String? model;
  String? stock;
  double? priceP;
  dynamic specialP;
  String? href;
  String? remove;

  Products({
    this.productIdP,
    this.thumb,
    this.nameP,
    this.model,
    this.stock,
    this.priceP,
    this.specialP,
    this.href,
    this.remove,
    required super.name,
    required super.special,
    required super.productId,
    required super.price,
    required super.description,
    required super.image,
    required productIP,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      name: json['name'],
      special: json['special'],
      productId: json['product_id'],
      price: json['price'],
      description: json['model'],
      image: json['thumb'],
      productIP: json['product_id'],
      thumb: json['thumb'],
      nameP: json['name'],
      model: json['model'],
      priceP: json['price'],
      specialP: json['special'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['thumb'] = thumb;
    data['name'] = name;
    data['model'] = model;
    data['stock'] = stock;
    data['price'] = price;
    data['special'] = special;
    data['href'] = href;
    data['remove'] = remove;
    return data;
  }
}
