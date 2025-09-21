import 'package:nylon/features/home/data/models/mobile_featured.dart';

class OneProductModel {
  List<Product>? product; // قائمة المنتجات
  List<Images>? images; // قائمة الصور
  List<Discounts>? discounts; // قائمة الخصومات
  List<ProductRelated>? productRelated; // المنتجات ذات الصلة
  List<Categories>? categories; // قائمة التصنيفات

  OneProductModel({
    this.product,
    this.images,
    this.discounts,
    this.productRelated,
    this.categories,
  });

  OneProductModel.fromJson(Map<String, dynamic> json) {
    if (json['product'] != null) {
      product = <Product>[]; // تحويل البيانات الخاصة بالمنتجات
      json['product'].forEach((v) {
        product!.add(Product.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <Images>[]; // تحويل البيانات الخاصة بالصور
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    if (json['discounts'] != null) {
      discounts = <Discounts>[]; // تحويل البيانات الخاصة بالخصومات
      json['discounts'].forEach((v) {
        discounts!.add(Discounts.fromJson(v));
      });
    }

    if (json['ProductRelated'] != null) {
      productRelated =
          <ProductRelated>[]; // تحويل البيانات الخاصة بالمنتجات ذات الصلة
      json['ProductRelated'].forEach((v) {
        productRelated!.add(ProductRelated.fromJson(v));
      });
    }

    if (json['categories'] != null) {
      categories = <Categories>[]; // تحويل البيانات الخاصة بالتصنيفات
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (product != null) {
      data['product'] = product!.map((v) => v.toJson()).toList();
    }
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (discounts != null) {
      data['discounts'] = discounts!.map((v) => v.toJson()).toList();
    }

    if (productRelated != null) {
      data['ProductRelated'] = productRelated!.map((v) => v.toJson()).toList();
    }

    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  // دالة لحساب السعر بناءً على الكمية والخصومات
  double calculatePriceWithDiscount(int quantity) {
    // 1. تحديد السعر الأساسي:
    double basePrice = _convertToDouble(product?.first.price) > 0
        ? _convertToDouble(product?.first.price) // استخدم السعر إذا كان غير صفر
        : _convertToDouble(
            product?.first.special); // سعر افتراضي في حال عدم وجود سعر

    // 2. تحقق من الخصومات
    if (discounts != null && discounts!.isNotEmpty) {
      for (var discount in discounts!) {
        // إذا كانت الكمية المطلوبة تساوي أو أكبر من الكمية المطلوبة للخصم
        if (quantity >= discount.quantity!) {
          return _convertToDouble(
              discount.price); // إرجاع السعر بعد تطبيق الخصم
        }
      }
    }

    // 3. إذا لم يكن هناك خصم أو لم تحقق الكمية، العودة بالسعر الأساسي
    return basePrice;
  }

  // دالة مساعدة لتحويل السعر إلى double
  double _convertToDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else if (value is String) {
      return num.parse(value).toDouble();
    } else {
      return 0.0; // قيمة افتراضية إذا لم يكن السعر من الأنواع المعروفة
    }
  }

  // دالة للحصول على جميع الصور
  List<String> getAllImages() {
    List<String> allImages = [];

    // إضافة الصورة الأولى من الحقل "image" إذا كانت موجودة
    if (product?.first.image != null) {
      allImages.add(product!.first.image!);
    }

    // إضافة الصور من الحقل "images" إذا كانت موجودة
    if (images != null && images!.isNotEmpty) {
      allImages.addAll(
        images!
            .map((img) => img.popup)
            .where((popup) => popup != null)
            .cast<String>(),
      );
    }

    return allImages;
  }
}

class Product {
  String? productId;
  String? name;
  String? metaTitle;
  String? metaDescription;
  int? quantity;
  int? minimum;
  int? viewed;
  String? percent;
  dynamic price;
  dynamic special;
  String? description;
  String? image;
  int? rating;

  Product(
      {this.productId,
      this.name,
      this.metaTitle,
      this.metaDescription,
      this.quantity,
      this.minimum,
      this.viewed,
      this.percent,
      this.price,
      this.special,
      this.description,
      this.image,
      this.rating});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    name = json['name'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    quantity = json['quantity'];
    minimum = json['minimum'];
    viewed = json['viewed'];
    percent = json['percent'];
    price = json['price'];
    special = json['special'];
    description = json['description'];
    image = json['image'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['name'] = name;
    data['meta_title'] = metaTitle;
    data['meta_description'] = metaDescription;
    data['quantity'] = quantity;
    data['minimum'] = minimum;
    data['viewed'] = viewed;
    data['percent'] = percent;
    data['price'] = price;
    data['special'] = special;
    data['description'] = description;
    data['image'] = image;
    data['rating'] = rating;
    return data;
  }
}

class Images {
  String? popup;

  Images({this.popup});

  Images.fromJson(Map<String, dynamic> json) {
    popup = json['popup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['popup'] = popup;
    return data;
  }
}

class Discounts {
  int? quantity;
  dynamic price;

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

class ProductRelated extends Productss {
  String? productIdP; // معرف المنتج
  String? thumb; // صورة مصغرة
  String? namep; // الاسم
  String? descriptionP; // الوصف
  String? percent; // النسبة
  String? textOffer; // عرض نصي
  String? exclusive; // حصري
  Null hasCart; // هل يحتوي على سلة
  int? pricep; // السعر
  int? specialp; // عرض خاص
  bool? tax; // ضريبة
  String? expiredNew; // منتهية جديدة
  int? ratingP; // التقييم

  ProductRelated({
    this.productIdP,
    this.thumb,
    this.namep,
    this.descriptionP,
    this.percent,
    this.textOffer,
    this.exclusive,
    this.hasCart,
    this.pricep,
    this.specialp,
    this.tax,
    this.expiredNew,
    this.ratingP,
    required super.name,
    required super.special,
    required super.productId,
    required super.price,
    required super.description,
    required super.image,
    required super.rating,
  });

  factory ProductRelated.fromJson(Map<String, dynamic> json) {
    return ProductRelated(
      name: json['name'],
      special: json['special'],
      productId: json['product_id'],
      price: json['price'],
      description: json['description'],
      rating: json['rating'],
      image: json['thumb'],
    );
    //   productId = json['product_id'];
    //   thumb = json['thumb'];
    //   name = json['name'];
    //   description = json['description'];
    //   percent = json['percent'];
    //   textOffer = json['text_offer'];
    //   exclusive = json['exclusive'];
    //   hasCart = json['has_cart'];
    //   price = json['price'];
    //   special = json['special'];
    //   tax = json['tax'];
    //   expiredNew = json['expired_new'];
    //   rating = json['rating'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['thumb'] = thumb;
    data['name'] = name;
    data['description'] = description;
    data['percent'] = percent;
    data['text_offer'] = textOffer;
    data['exclusive'] = exclusive;
    data['has_cart'] = hasCart;
    data['price'] = price;
    data['special'] = special;
    data['tax'] = tax;
    data['expired_new'] = expiredNew;
    data['rating'] = rating;
    return data;
  }
}

class Categories {
  String? categoriesId; // معرف التصنيف
  String? name; // اسم التصنيف

  Categories({this.categoriesId, this.name});

  Categories.fromJson(Map<String, dynamic> json) {
    categoriesId = json['categories_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categories_id'] = categoriesId;
    data['name'] = name;
    return data;
  }
}

// class OneProductModel {
//   ProductData? productData;
//   List<Images>? images;
//   List<Discounts>? discounts;
//   List<Null>? options;
//   String? minimum;
//   List<Null>? recurrings;

//   OneProductModel({
//     this.productData,
//     this.images,
//     this.discounts,
//   });

//   OneProductModel.fromJson(Map<String, dynamic> json) {
//     productData = json['product'] != null
//         ? new ProductData.fromJson(json['product'])
//         : null;
//     if (json['images'] != null && json['images'] != []) {
//       images = <Images>[];
//       json['images'].forEach((v) {
//         images!.add(new Images.fromJson(v));
//       });
//     }
//     if (json['discounts'] != null) {
//       discounts = <Discounts>[];
//       json['discounts'].forEach((v) {
//         discounts!.add(new Discounts.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.productData != null) {
//       data['product_data'] = this.productData!.toJson();
//     }
//     if (this.images != null) {
//       data['images'] = this.images!.map((v) => v.toJson()).toList();
//     }
//     if (this.discounts != null) {
//       data['discounts'] = this.discounts!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }

//   // دالة لحساب السعر بناءً على الكمية والخصومات
//   double calculatePriceWithDiscount(int quantity) {
//     // 1. تحديد السعر الأساسي:
//     double basePrice = _convertToDouble(productData?.priceAfterDiscount) > 0
//         ? _convertToDouble(productData?.priceAfterDiscount)  // استخدم السعر بعد الخصم إذا كان غير صفر
//         : _convertToDouble(productData?.basePrice);  // وإلا استخدم السعر الأساسي

//     // 2. تحقق من الخصومات
//     if (discounts != null && discounts!.isNotEmpty) {
//       for (var discount in discounts!) {
//         // إذا كانت الكمية المطلوبة تساوي أو أكبر من الكمية المطلوبة للخصم
//         if (quantity >= discount.quantity!) {
//           return _convertToDouble(discount.price);  // إرجاع السعر بعد تطبيق الخصم
//         }
//       }
//     }

//     // 3. إذا لم يكن هناك خصم أو لم تحقق الكمية، العودة بالسعر الأساسي
//     return basePrice;
//   }

//   // دالة مساعدة لتحويل السعر إلى double
//   double _convertToDouble(dynamic value) {
//     if (value is int) {
//       return value.toDouble();
//     } else if (value is double) {
//       return value;
//     } else if (value is String) {
//       return num.parse(value).toDouble();
//     } else {
//       return 0.0;  // قيمة افتراضية إذا لم يكن السعر من الأنواع المعروفة
//     }
//   }

//   // دالة للحصول على جميع الصور
//   List<String> getAllImages() {
//     List<String> allImages = [];

//     // إضافة الصورة الأولى من الحقل "image" إذا كانت موجودة
//     if (productData?.image != null) {
//       allImages.add(productData!.image!);
//     }

//     // إضافة الصور من الحقل "images" إذا كانت موجودة
//     if (images != null && images!.isNotEmpty) {
//       allImages.addAll(
//         images!.map((img) => img.popup).where((popup) => popup != null).cast<String>(),
//       );
//     }

//     return allImages;
//   }
// }

// class ProductData {
//   String? productId;
//   String? name;
//   String? description;
//   dynamic discountRate;
//  dynamic discountInRiyals;
//   String? textOffer;
//   String? tag;
//   String? model;
//   String? statusNew;
//   String? expiredNew;
//   String? notreplaced;
//   String? exclusive;
//   String? location;
//   String? quantity;
//   String? stockStatus;
//   String? image;
//   dynamic priceAfterDiscount;
//   dynamic basePrice;
//   dynamic rating;
//   dynamic reviews;
//   String? minimum;
//   String? status;
//   String? dateAdded;
//   String? viewed;

//   ProductData({
//     this.productId,
//     this.name,
//     this.description,
//     this.discountRate,
//     this.discountInRiyals,
//     this.textOffer,
//     this.tag,
//     this.model,
//     this.statusNew,
//     this.expiredNew,
//     this.notreplaced,
//     this.exclusive,
//     this.location,
//     this.quantity,
//     this.stockStatus,
//     this.image,
//     this.priceAfterDiscount,
//     this.basePrice,
//     this.rating,
//     this.reviews,
//     this.minimum,
//     this.status,
//     this.dateAdded,
//     this.viewed,
//   });

//   ProductData.fromJson(Map<String, dynamic> json) {
//     productId = json['product_id'];
//     name = json['name'];
//     description = json['description'];
//     discountRate = json['discount_rate'];
//     discountInRiyals = json['discount_in_Riyals'];
//     textOffer = json['text_offer'];
//     tag = json['tag'];
//     model = json['model'];
//     statusNew = json['status_new'];
//     expiredNew = json['expired_new'];
//     notreplaced = json['notreplaced'];
//     exclusive = json['exclusive'];
//     location = json['location'];
//     quantity = json['quantity'];
//     stockStatus = json['stock_status'];
//     image = json['image'];
//     priceAfterDiscount = json['price_after_discount'];
//     basePrice = json['base_price'];
//     rating = json['rating'];
//     reviews = json['reviews'];
//     minimum = json['minimum'];
//     status = json['status'];
//     dateAdded = json['date_added'];
//     viewed = json['viewed'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['product_id'] = this.productId;
//     data['name'] = this.name;
//     data['description'] = this.description;
//     data['discount_rate'] = this.discountRate;
//     data['discount_in_Riyals'] = this.discountInRiyals;
//     data['text_offer'] = this.textOffer;
//     data['tag'] = this.tag;
//     data['model'] = this.model;
//     data['status_new'] = this.statusNew;
//     data['expired_new'] = this.expiredNew;
//     data['notreplaced'] = this.notreplaced;
//     data['exclusive'] = this.exclusive;
//     data['location'] = this.location;
//     data['quantity'] = this.quantity;
//     data['stock_status'] = this.stockStatus;
//     data['image'] = this.image;
//     data['price_after_discount'] = this.priceAfterDiscount;
//     data['base_price'] = this.basePrice;
//     data['rating'] = this.rating;
//     data['reviews'] = this.reviews;
//     data['minimum'] = this.minimum;
//     data['status'] = this.status;
//     data['date_added'] = this.dateAdded;
//     data['viewed'] = this.viewed;
//     return data;
//   }
// }

// class Discounts {
//   int? quantity;
//   dynamic price;

//   Discounts({
//     this.quantity,
//     this.price,
//   });

//   Discounts.fromJson(Map<String, dynamic> json) {
//     quantity = json['quantity'];
//     price = json['price'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['quantity'] = this.quantity;
//     data['price'] = this.price;
//     return data;
//   }
// }

// class Images {
//   String? popup;
//   String? thumb;

//   Images({
//     this.popup,
//     this.thumb,
//   });

//   Images.fromJson(Map<String, dynamic> json) {
//     popup = json['popup'];
//     thumb = json['thumb'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['popup'] = this.popup;
//     data['thumb'] = this.thumb;
//     return data;
//   }
// }
