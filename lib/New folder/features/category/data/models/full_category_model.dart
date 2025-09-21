import 'package:nylon/features/home/data/models/products_featured.dart';

class FullCategory {
  List<ProductsFeatured>? productsFeatured;

  FullCategory({this.productsFeatured});

  FullCategory.fromJson(Map<String, dynamic> json) {
    if (json['products_featured'] != null) {
      productsFeatured = <ProductsFeatured>[];
      json['products_featured'].forEach((v) {
        productsFeatured!.add(ProductsFeatured.fromJson(v));
      });
      productsFeatured!.sort((a, b) {
        return a.getSortOrder().compareTo(b.getSortOrder());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (productsFeatured != null) {
      data['products_featured'] =
          productsFeatured!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
