import 'package:nylon/features/home/data/models/mobile_featured.dart';

class CategoryModel {
  String? totalProducts;
  String? thumb;
  String? description;
  List<Products>? products;
  List<Sorts>? sorts;
  String? pagination;
  String? sort;
  String? order;

  CategoryModel(
      {this.totalProducts,
      this.thumb,
      this.description,
      this.products,
      this.sorts,
      this.pagination,
      this.sort,
      this.order});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    totalProducts = json['total_products'];
    thumb = json['thumb'];
    description = json['description'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    if (json['sorts'] != null) {
      sorts = <Sorts>[];
      json['sorts'].forEach((v) {
        sorts!.add(Sorts.fromJson(v));
      });
    }
    pagination = json['pagination'];
    sort = json['sort'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_products'] = totalProducts;
    data['thumb'] = thumb;
    data['description'] = description;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    if (sorts != null) {
      data['sorts'] = sorts!.map((v) => v.toJson()).toList();
    }
    data['pagination'] = pagination;
    data['sort'] = sort;
    data['order'] = order;
    return data;
  }
}

class Products extends Productss {
  String? productIdP;
  String? thumb;
  String? nameP;
  String? descriptionP;
  String? percent;
  String? textOffer;
  String? exclusive;
  @override
  dynamic special;
  dynamic priceP;
  bool? quantityP;
  dynamic tax;
  String? expiredNew;
  int? ratingP;
  String? href;

  Products(
      {this.productIdP,
      this.thumb,
      this.nameP,
      this.descriptionP,
      this.percent,
      this.textOffer,
      this.exclusive,
      this.special,
      this.priceP,
      this.quantityP,
      this.tax,
      this.expiredNew,
      this.ratingP,
      this.href,
      required super.name,
      required super.productId,
      required super.price,
      required super.description,
      required super.image,
      required super.rating});

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      name: json['name'],
      productId: json['product_id'],
      price: json['price'],
      description: json['description'],
      image: json['thumb'],
      productIdP: json['product_id'],
      thumb: json['thumb'],
      nameP: json['name'],
      descriptionP: json['description'],
      percent: json['percent'],
      textOffer: json['text_offer'],
      exclusive: json['exclusive'],
      special: json['special'],
      priceP: json['price'],
      quantityP: json['quantity'],
      tax: json['tax'],
      expiredNew: json['expired_new'],
      ratingP: json['rating'],
      rating: json['rating'],
    );
  }
}

class Sorts {
  String? text;
  String? value;
  String? href;

  Sorts({this.text, this.value, this.href});

  Sorts.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['value'] = value;
    data['href'] = href;
    return data;
  }
}
