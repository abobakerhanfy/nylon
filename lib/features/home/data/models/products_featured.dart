import 'package:nylon/features/home/data/models/mobile_featured.dart';

class ProductsFeatured {
  List<Products>? products;
  List<Products>? productsAr;
  List<Products>? productsEn;
  String? sort;
  String? nameAr;
  String? nameEn;
  String? status;

  ProductsFeatured(
      {this.products, this.productsAr, this.productsEn, this.sort});

  ProductsFeatured.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    if (json['products-ar'] != null) {
      productsAr = <Products>[];
      json['products-ar'].forEach((v) {
        productsAr!.add(Products.fromJson(v));
      });
    }
    if (json['products-en'] != null) {
      productsEn = <Products>[];
      json['products-en'].forEach((v) {
        productsEn!.add(Products.fromJson(v));
      });
    }
    sort = json['sort'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    status = json['status'];
  }

  int getSortOrder() {
    return int.tryParse(sort ?? '0') ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    if (productsAr != null) {
      data['products-ar'] = productsAr!.map((v) => v.toJson()).toList();
    }
    if (productsEn != null) {
      data['products-en'] = productsEn!.map((v) => v.toJson()).toList();
    }
    data['sort'] = sort;
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
  num? priceP; // هنا غيرنا int? إلى num?
  dynamic specials;
  bool? quantityP;
  bool? tax;
  String? expiredNew;
  @override
  int? rating;
  String? href;
  @override
  num? afterDiscount;
  @override
  List<Discounts>? offer;

  Products({
    this.productIdP,
    this.thumb,
    this.nameP,
    this.descriptionP,
    this.percent,
    this.textOffer,
    this.exclusive,
    this.priceP,
    this.specials,
    this.quantityP,
    this.tax,
    this.expiredNew,
    this.rating,
    this.href,
    required super.name,
    required super.special,
    required super.productId,
    required super.price,
    required super.description,
    required super.quantity,
    required super.image,
    this.afterDiscount,
    this.offer,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      name: json['name'] ?? '',
      special: json["special"] ?? 0,
      productId: json['product_id'] ?? '',
      price: json['price'] is num
          ? json['price']
          : json['price'] is String
              ? num.tryParse(json['price']) ?? 0
              : 0,
      description: json['description'] ?? '',
      quantity: json['quantity'] ?? 0,
      image: json['thumb'] ?? '',
      rating: json['rating'] is num
          ? json['rating']
          : num.tryParse(json['rating']?.toString() ?? '') ?? 0,
      afterDiscount: json['after_discount'] is num
          ? json['after_discount']
          : json['after_discount'] is String
              ? num.tryParse(json['after_discount']) ?? 0
              : 0,
      offer: json['offer'] != null
          ? (json['offer'] as List).map((v) => Discounts.fromJson(v)).toList()
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productIdP;
    data['thumb'] = thumb;
    data['name'] = name;
    data['description'] = description;
    data['percent'] = percent;
    data['text_offer'] = textOffer;
    data['exclusive'] = exclusive;
    data['price'] = priceP;
    data['special'] = special;
    data['quantity'] = quantityP;
    data['tax'] = tax;
    data['expired_new'] = expiredNew;
    data['rating'] = rating;
    data['href'] = href;
    data['after_discount'] = afterDiscount;
    if (offer != null) {
      data['offer'] = offer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Discounts {
  String? quantity;
  String? price;

  Discounts({this.quantity, this.price});

  Discounts.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantity'] = quantity;
    data['price'] = price;
    return data;
  }
}



// class ProductsFeatured {
//   List<Products>? products;
//   String? sort;
//   String? nameAr;
//   String? nameEn;

 


//   ProductsFeatured.fromJson(Map<String, dynamic> json) {
//     if (json['products'] != null) {
//       products = <Products>[];
//       json['products'].forEach((v) {
//         products!.add(new Products.fromJson(v));
//       });
//     }
//     sort = json['sort'];
//     nameAr = json['name_ar'];
//     nameEn = json['name_en'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.products != null) {
//       data['products'] = this.products!.map((v) => v.toJson()).toList();
//     }
//     data['sort'] = this.sort;
//     return data;
//   }
// }

// class Products extends Productss{
//   String? productIdP;
//   String? thumb;
//   String? nameP;
//   String? descriptionP;
//   String? percent;
//   String? textOffer;
//   String? exclusive;
//   dynamic priceP;
//   bool? special;
//  dynamic quantityP;
//   bool? tax;
//   String? expiredNew;
//   int? rating;
//   String? href;

//   Products(
//       {this.productIdP,
//       this.thumb,
//       this.nameP,
//       this.descriptionP,
//       this.percent,
//       this.textOffer,
//       this.exclusive,
//       this.priceP,
//       this.special,
//       this.quantityP,
//       this.tax,
//       this.expiredNew,
//       this.rating,
//       this.href,
//        required super.name,
//       required super.productId,
//        required super.priceTest,
//         required super.description,
//         required super.quantity,
//         required super.image,
//       });

//  factory Products.fromJson(Map<String, dynamic> json) {
//   return Products(
//      productId : json['product_id'],
//     thumb : json['thumb'],
//     name : json['name'],
//     description : json['description'],
//     percent : json['percent'],
//     textOffer : json['text_offer'],
//     exclusive : json['exclusive'],
//    //  price : json['price'],
//     special : json['special'],
//     quantity : json['quantity'],
//     tax : json['tax'],
//     expiredNew : json['expired_new'],
//     rating : json['rating'],
//     href : json['href'], 
//     image: json['thumb'],
//     nameP: json['name'],
//     descriptionP: json['description'],
//     priceP:json['price'], 
//     quantityP: json['quantity'],
//     productIdP: json['product_id'],
//     priceTest: json['price']

//   );
   
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['product_id'] = this.productId;
//     data['thumb'] = this.thumb;
//     data['name'] = this.name;
//     data['description'] = this.description;
//     data['percent'] = this.percent;
//     data['text_offer'] = this.textOffer;
//     data['exclusive'] = this.exclusive;
//     data['price'] = this.price;
//     data['special'] = this.special;
//     data['quantity'] = this.quantity;
//     data['tax'] = this.tax;
//     data['expired_new'] = this.expiredNew;
//     data['rating'] = this.rating;
//     data['href'] = this.href;
//     return data;
//   }
// }