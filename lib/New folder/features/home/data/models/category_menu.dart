class CategoryMenu {
  String? name;
  String? nameEn;
  Sliders? sliders;
  String? stauts;
  String? sortOrder;

  CategoryMenu(
      {this.name, this.sliders, this.stauts, this.sortOrder, this.nameEn});

  CategoryMenu.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameEn = json['name_en'];
    sliders =
        json['sliders'] != null ? Sliders.fromJson(json['sliders']) : null;
    stauts = json['stauts'];
    sortOrder = json['sort_order'];
  }
  int getSortOrder() {
    // قد تحتاج لتحويل `sortOrder` إلى قيمة عددية
    return int.tryParse(sortOrder ?? '0') ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (sliders != null) {
      data['sliders'] = sliders!.toJson();
    }
    data['stauts'] = stauts;
    data['sort_order'] = sortOrder;
    return data;
  }
}

class Sliders {
  List<SliderHome>? sliderAr;
  List<SliderHome>? sliderEn;

  Sliders({this.sliderAr, this.sliderEn});

  Sliders.fromJson(Map<String, dynamic> json) {
    if (json['1'] != null) {
      sliderAr = <SliderHome>[];
      json['1'].forEach((v) {
        if (v['stauts'] != '0') {
          sliderAr!.add(SliderHome.fromJson(v));
        }
      });
    }
    if (json['2'] != null) {
      sliderEn = <SliderHome>[];
      json['2'].forEach((v) {
        if (v['stauts'] != '0') {
          sliderEn!.add(SliderHome.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sliderAr != null) {
      data['1'] = sliderAr!.map((v) => v.toJson()).toList();
    }
    if (sliderEn != null) {
      data['2'] = sliderEn!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SliderHome {
  String? title;
  String? description;
  String? link;
  String? image;
  String? thumb;
  String? sortOrder;
  String? categoryId;

  SliderHome(
      {this.title,
      this.description,
      this.link,
      this.categoryId,
      this.image,
      this.thumb,
      this.sortOrder});

  SliderHome.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    link = json['link'];
    categoryId = json["category_id"];
    image = json['image'];
    thumb = json['thumb'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data["category_id"] = categoryId;
    data['description'] = description;
    data['link'] = link;
    data['image'] = image;
    data['thumb'] = thumb;
    data['sort_order'] = sortOrder;
    return data;
  }
}

// class CategoryMenu {
//   String? name;
//   List<SlidersData>? sliders;
//   String? stauts;
//   String? sortOrder;

//   CategoryMenu({this.name, this.sliders, this.stauts, this.sortOrder});
//  int getSortOrder() {
//     // قد تحتاج لتحويل `sortOrder` إلى قيمة عددية
//     return int.tryParse(sortOrder ?? '0') ?? 0;
//   }
//   CategoryMenu.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     if (json['sliders'] != null) {
//       sliders = <SlidersData>[];
//       json['sliders'].forEach((v) {
//         sliders!.add(new SlidersData.fromJson(v));
//       });
//     }
//     stauts = json['stauts'];
//     sortOrder = json['sort_order'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     if (this.sliders != null) {
//       data['sliders'] = this.sliders!.map((v) => v.toJson()).toList();
//     }
//     data['stauts'] = this.stauts;
//     data['sort_order'] = this.sortOrder;
//     return data;
//   }
// }
// class SlidersData {
//   String? name;
//   String? link;
//   String?image;

//   SlidersData({this.name, this.link});

//   SlidersData.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     link = json['link'];
//     image=json["image"];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['link'] = this.link;
//     return data;
//   }
// }
