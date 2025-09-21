// import 'package:nylon/features/home/data/models/products_featured.dart';

// class MobileFeatured {
//   String? nameAr;
//   String? nameEn;
//   List<Productss>? products;
//   String? limit;
//   String? status;
//   String? sortOrder;

//   MobileFeatured(
//       {this.nameAr,
//       this.nameEn,
//       this.products,
//       this.limit,
//       this.status,
//       this.sortOrder});
//   int getSortOrder() {
//     // قد تحتاج لتحويل `sortOrder` إلى قيمة عددية
//     return int.tryParse(sortOrder ?? '0') ?? 0;
//   }

//   num _toNum(dynamic v) {
//     if (v == null) return 0;
//     if (v is num) return v;
//     if (v is String) {
//       // نحاول نطلع أول رقم من السترينج (بيشيل أي HTML/رموز)
//       final match = RegExp(r'[-+]?\d*\.?\d+').firstMatch(v);
//       if (match != null) {
//         return num.tryParse(match.group(0)!) ?? 0;
//       }
//     }
//     return 0;
//   }

//   int _toInt(dynamic v) {
//     if (v == null) return 0;
//     if (v is int) return v;
//     if (v is bool) return v ? 1 : 0;
//     if (v is num) return v.toInt();
//     if (v is String) return int.tryParse(v) ?? _toNum(v).toInt();
//     return 0;
//   }

//   String _toStr(dynamic v) => v?.toString() ?? '';

//   MobileFeatured.fromJson(Map<String, dynamic> json) {
//     nameAr = json['name_ar'];
//     nameEn = json['name_en'];
//     if (json['products'] != null) {
//       products = <Productss>[];
//       json['products'].forEach((v) {
//         products!.add(Productss.fromJson(v));
//       });
//     }
//     limit = json['limit'];
//     status = json['status'];
//     sortOrder = json['sort_order'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name_ar'] = nameAr;
//     data['name_en'] = nameEn;
//     if (products != null) {
//       data['products'] = products!.map((v) => v.toJson()).toList();
//     }
//     data['limit'] = limit;
//     data['status'] = status;
//     data['sort_order'] = sortOrder;
//     return data;
//   }
// }

// class Productss {
//   String? productId;
//   String? name;
//   dynamic price;
//   dynamic special;
//   String? description;
//   dynamic quantity;
//   String? image;
//   String? priceTest;
//   num? afterDiscount;
//   List<Discounts>? offer;
//   int? rating;

//   Productss(
//       {this.productId,
//       this.name,
//       this.price,
//       this.description,
//       this.quantity,
//       this.image,
//       this.priceTest,
//       this.afterDiscount,
//       this.offer,
//       this.rating,
//       this.special});

//   double calculatePriceWithDiscount(int currentQuantity) {
//     double finalPrice = 0.0;

//     // التحقق من العروض
//     if (offer != null && offer!.isNotEmpty) {
//       for (var discount in offer!) {
//         if (currentQuantity >= int.parse(discount.quantity!)) {
//           // تحويل السعر في العرض إلى double في جميع الحالات
//           finalPrice = _convertToDouble(discount.price);
//           return double.parse(
//               finalPrice.toStringAsFixed(2)); // ضبط رقمين بعد العلامة العشرية
//         }
//       }
//     }

//     // تحويل السعر الأساسي للمنتج إلى double
//     finalPrice = _convertToDouble(price != 0 ? price : special);

//     // إرجاع السعر مع رقمين بعد العلامة العشرية
//     return double.parse(finalPrice.toStringAsFixed(2));
//   }

// // دالة مساعدة لتحويل السعر إلى double
//   double _convertToDouble(dynamic value) {
//     if (value is int) {
//       return value.toDouble();
//     } else if (value is double) {
//       return value;
//     } else if (value is String) {
//       return num.parse(value).toDouble();
//     } else {
//       return 0.0; // قيمة افتراضية إذا لم يكن السعر من الأنواع المعروفة
//     }
//   }

//   Productss.fromJson(Map<String, dynamic> json) {
//     productId = json['product_id']?.toString();
//     name = json['name']
//         as String?; // الاسم جاهز بالعربي/الإنجليزي حسب الليستة المختارة
//     price = json['price'];
//     special = json[
//         'special']; // أحيانًا رقم وأحيانًا String فيه <img> (هننضفه في الويجت)
//     description = json['description'] as String?;
//     quantity = json['quantity'];
//     image = (json['thumb'] ?? json['image'])
//         as String?; // ← الصورة من thumb حسب الAPI
//     rating = (json['rating'] is int)
//         ? json['rating'] as int
//         : int.tryParse(json['rating']?.toString() ?? '');
//     // percent في الAPI هي الخصم الظاهر على الشارة
//     afterDiscount = _parsePercent(json['percent']); // ترجع رقم بدون علامة %
//     // عروض كمية (لو موجودة عندك بنفس المفتاح)
//     if (json['offer'] != null) {
//       offer = <Discounts>[];
//       for (var v in (json['offer'] as List)) {
//         offer!.add(Discounts.fromJson(v));
//       }
//     }
//   }

// // حوّل "100%-" أو "23%-" → 100 أو 23
//   num? _parsePercent(dynamic p) {
//     if (p == null) return null;
//     final s = p.toString().replaceAll(RegExp(r'[^0-9\.\-]'), '');
//     if (s.isEmpty) return null;
//     return num.tryParse(s);
//   }

//   // Productss.fromJson(Map<String, dynamic> json) {
//   //   productId = json['product_id'];
//   //   name = json['name'];
//   //   price = json['price'];
//   //   description = json['description'];
//   //   quantity = json['quantity'];
//   //   image = json['image'];
//   //   rating = json['rating'];
//   //   special = json["special"];
//   //   afterDiscount = json['after_discount'];
//   //   if (json['offer'] != null) {
//   //     offer = <Discounts>[];
//   //     json['offer'].forEach((v) {
//   //       offer!.add(Discounts.fromJson(v));
//   //     });
//   //   }
//   // }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['product_id'] = productId;
//     data['name'] = name;
//     data['price'] = price;
//     data['description'] = description;
//     data['quantity'] = quantity;
//     data['image'] = image;
//     data['rating'] = rating;
//     data['after_discount'] = afterDiscount;
//     if (offer != null) {
//       data['offer'] = offer!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
// احذف الـ import self-referential هنا

class MobileFeatured {
  String? nameAr;
  String? nameEn;
  List<Productss>? products;
  String? limit;
  String? status;
  String? sortOrder;

  MobileFeatured({
    this.nameAr,
    this.nameEn,
    this.products,
    this.limit,
    this.status,
    this.sortOrder,
  });

  int getSortOrder() => int.tryParse(sortOrder ?? '0') ?? 0;

  MobileFeatured.fromJson(Map<String, dynamic> json) {
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    if (json['products'] != null) {
      products = <Productss>[];
      for (var v in (json['products'] as List)) {
        products!.add(Productss.fromJson(v));
      }
    }
    limit = json['limit'];
    status = json['status'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name_ar'] = nameAr;
    data['name_en'] = nameEn;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['limit'] = limit;
    data['status'] = status;
    data['sort_order'] = sortOrder;
    return data;
  }
}

class Productss {
  String? productId;
  String? name;
  dynamic price;
  dynamic special;
  String? description;
  dynamic quantity;
  String? image;
  String? priceTest;
  num? afterDiscount;
  List<Discounts>? offer;
  int? rating;

  Productss({
    this.productId,
    this.name,
    this.price,
    this.description,
    this.quantity,
    this.image,
    this.priceTest,
    this.afterDiscount,
    this.offer,
    this.rating,
    this.special,
  });

  double calculatePriceWithDiscount(int currentQuantity) {
    double finalPrice = 0.0;

    if (offer != null && offer!.isNotEmpty) {
      for (var discount in offer!) {
        if (currentQuantity >= int.parse(discount.quantity!)) {
          finalPrice = _convertToDouble(discount.price);
          return double.parse(finalPrice.toStringAsFixed(2));
        }
      }
    }

    finalPrice = _convertToDouble(price != 0 ? price : special);
    return double.parse(finalPrice.toStringAsFixed(2));
  }

  double _convertToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      final match = RegExp(r'[-+]?\d*\.?\d+').firstMatch(value);
      if (match != null) {
        return double.tryParse(match.group(0)!) ?? 0.0;
      }
      return 0.0;
    }
    return 0.0;
  }

  Productss.fromJson(Map<String, dynamic> json) {
    productId = json['product_id']?.toString();
    name = json['name'] as String?;
    price = json['price'];
    special = json['special'];
    description = json['description'] as String?;
    quantity = json['quantity'];
    image = (json['thumb'] ?? json['image']) as String?;
    rating = (json['rating'] is int)
        ? json['rating'] as int
        : int.tryParse(json['rating']?.toString() ?? '');
    afterDiscount = _parsePercent(json['percent']);
    if (json['offer'] != null) {
      offer = <Discounts>[];
      for (var v in (json['offer'] as List)) {
        offer!.add(Discounts.fromJson(v));
      }
    }
  }

  num? _parsePercent(dynamic p) {
    if (p == null) return null;
    final s = p.toString().replaceAll(RegExp(r'[^0-9\.\-]'), '');
    if (s.isEmpty) return null;
    return num.tryParse(s);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = productId;
    data['name'] = name;
    data['price'] = price;
    data['description'] = description;
    data['quantity'] = quantity;
    data['image'] = image;
    data['rating'] = rating;
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
    quantity = json['quantity']?.toString();
    price = json['price']?.toString();
  }
  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        'price': price,
      };
}
