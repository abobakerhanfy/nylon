import 'package:nylon/features/home/data/models/big_banner.dart';
import 'package:nylon/features/home/data/models/category_menu.dart';
import 'package:nylon/features/home/data/models/mobile_featured.dart';
import 'package:nylon/features/home/data/models/mobile_slider.dart';
import 'package:nylon/features/home/data/models/multi_banner.dart';
import 'package:nylon/features/home/data/models/products_featured.dart';

class NewModelHome {
  List<MultiBanner>? multiBanner;
  List<ProductsFeatured>? productsFeatured;
  List<BigBanner>? bigBanner;
  List<MobileFeatured>? mobileFeatured;
  List<CategoryMenu>? categoryMenu;
  List<MobileSlider>? mobileSlider;

  NewModelHome(
      {this.multiBanner,
      this.productsFeatured,
      this.bigBanner,
      this.mobileFeatured,
      this.categoryMenu,
      this.mobileSlider});

  NewModelHome.fromJson(Map<String, dynamic> json) {
    if (json['multi_banner'] != null) {
      multiBanner = <MultiBanner>[];
      json['multi_banner'].forEach((v) {
        multiBanner!.add(MultiBanner.fromJson(v));
      });
    }
    if (json['products_featured'] != null) {
      productsFeatured = <ProductsFeatured>[];
      json['products_featured'].forEach((v) {
        productsFeatured!.add(ProductsFeatured.fromJson(v));
      });
    }
    if (json['big_banner'] != null) {
      bigBanner = <BigBanner>[];
      json['big_banner'].forEach((v) {
        bigBanner!.add(BigBanner.fromJson(v));
      });
    }
    if (json['mobile_featured'] != null) {
      mobileFeatured = <MobileFeatured>[];
      json['mobile_featured'].forEach((v) {
        mobileFeatured!.add(MobileFeatured.fromJson(v));
      });
    }
    if (json['category_menu'] != null) {
      categoryMenu = <CategoryMenu>[];
      json['category_menu'].forEach((v) {
        categoryMenu!.add(CategoryMenu.fromJson(v));
      });
    }
    if (json['mobile_slider'] != null) {
      mobileSlider = <MobileSlider>[];
      json['mobile_slider'].forEach((v) {
        mobileSlider!.add(MobileSlider.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (multiBanner != null) {
      data['multi_banner'] = multiBanner!.map((v) => v.toJson()).toList();
    }
    if (productsFeatured != null) {
      data['products_featured'] =
          productsFeatured!.map((v) => v.toJson()).toList();
    }
    if (bigBanner != null) {
      data['big_banner'] = bigBanner!.map((v) => v.toJson()).toList();
    }
    if (mobileFeatured != null) {
      data['mobile_featured'] = mobileFeatured!.map((v) => v.toJson()).toList();
    }
    if (categoryMenu != null) {
      data['category_menu'] = categoryMenu!.map((v) => v.toJson()).toList();
    }
    if (mobileSlider != null) {
      data['mobile_slider'] = mobileSlider!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
