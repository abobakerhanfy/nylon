import 'package:nylon/features/home/data/models/mobile_featured.dart' as mf;

class ProductsFeatured {
  List<Products>? products;
  List<Products>? productsAr;
  List<Products>? productsEn;
  String? sort;
  String? title;
  String? nameAr;
  String? nameEn;
  String? status;
  String? categoryId; // ضيف السطر ده

  ProductsFeatured(
      {this.products,
      this.productsAr,
      this.productsEn,
      this.sort,
      this.categoryId});

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
    categoryId = json['category_id']; // ضيف السطر ده
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

class Products extends mf.Productss {
  String? productIdP;
  String? thumb;
  String? nameP;
  String? descriptionP;
  String? percent;
  String? textOffer;
  String? exclusive;
  num? priceP;
  dynamic specials;
  bool? quantityP;
  bool? tax;
  String? expiredNew;
  String? href;

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
    this.href,
    required super.name,
    required super.special,
    required super.productId,
    required super.price,
    required super.description,
    required super.quantity,
    required super.image,
    super.afterDiscount,
    super.offer,
    super.rating,
  });

  static num _pickNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    if (v is String) {
      final m = RegExp(r'[-+]?\d*\.?\d+').firstMatch(v);
      if (m != null) return num.tryParse(m.group(0)!) ?? 0;
    }
    return 0;
  }

  factory Products.fromJson(Map<String, dynamic> json) {
    final parsedPrice = _pickNum(json['price']);
    final parsedSpecial = _pickNum(json['special']);
    final parsedRating = _pickNum(json['rating']).toInt();
    final parsedAfter = _pickNum(json['after_discount']);

    final offers = (json['offer'] is List)
        ? (json['offer'] as List)
            .map((e) => mf.Discounts.fromJson(e as Map<String, dynamic>))
            .toList()
        : null;

    return Products(
      name: (json['name'] ?? '').toString(),
      special: parsedSpecial,
      productId: (json['product_id'] ?? '').toString(),
      price: parsedPrice,
      description: (json['description'] ?? '').toString(),
      quantity: json['quantity'] is bool
          ? ((json['quantity'] as bool) ? 1 : 0)
          : _pickNum(json['quantity']).toInt(),
      image: (json['thumb'] ?? '').toString(),
      rating: parsedRating,
      afterDiscount: parsedAfter,
      offer: offers,
      productIdP: json['product_id']?.toString(),
      thumb: json['thumb']?.toString(),
      nameP: json['name']?.toString(),
      descriptionP: json['description']?.toString(),
      percent: json['percent']?.toString(),
      textOffer: json['text_offer']?.toString(),
      exclusive: json['exclusive']?.toString(),
      priceP: parsedPrice,
      specials: json['special'],
      quantityP: json['quantity'] is bool ? json['quantity'] as bool : null,
      tax: json['tax'] == true,
      expiredNew: json['expired_new']?.toString(),
      href: json['href']?.toString(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = productIdP ?? productId;
    data['thumb'] = thumb ?? image;
    data['name'] = nameP ?? name;
    data['description'] = descriptionP ?? description;
    data['percent'] = percent;
    data['text_offer'] = textOffer;
    data['exclusive'] = exclusive;
    data['price'] = priceP ?? price;
    data['special'] = special;
    data['quantity'] = quantityP ?? (quantity != null ? quantity! > 0 : null);
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