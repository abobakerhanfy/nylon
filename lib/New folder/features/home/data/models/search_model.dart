import 'package:nylon/features/home/data/models/mobile_featured.dart';

class SearchModel {
  ProductsData? products;
  String? moreResults;

  SearchModel({this.products, this.moreResults});

  SearchModel.fromJson(Map<String, dynamic> json) {
    products = json['products'] != null
        ? ProductsData.fromJson(json['products'])
        : null;
    moreResults = json['more_results'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.toJson();
    }
    data['more_results'] = moreResults;
    return data;
  }
}

class ProductsData {
  List<Products>? products;

  ProductsData({this.products});

  ProductsData.fromJson(Map<String, dynamic> json) {
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
  dynamic priceP;
  dynamic specialP;
  String? nameP;
  String? href;

  Products(
      {this.productIdP,
      this.thumb,
      this.priceP,
      this.specialP,
      this.nameP,
      this.href,
      required super.name,
      required super.productId,
      required super.price,
      required super.image,
      required super.special});

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      name: json['name'],
      productId: json['product_id'],
      price: json['price'],
      image: json['thumb'],
      productIdP: json['product_id'],
      thumb: json['thumb'],
      priceP: json['price'],
      special: json['special'],
      nameP: json['name'],
      href: json['href'],
    );
  }
}
