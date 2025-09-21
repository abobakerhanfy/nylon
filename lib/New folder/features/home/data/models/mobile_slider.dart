class MobileSlider {
  List<ImageData>? image;
  String? status;
  String? sort;

  MobileSlider({this.image, this.status, this.sort});
  int getSortOrder() {
    // قد تحتاج لتحويل `sortOrder` إلى قيمة عددية
    return int.tryParse(sort ?? '0') ?? 0;
  }

  MobileSlider.fromJson(Map<String, dynamic> json) {
    if (json['image'] != null) {
      image = <ImageData>[];
      json['image'].forEach((v) {
        image!.add(ImageData.fromJson(v));
      });
    }
    status = json['status'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (image != null) {
      data['image'] = image!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['sort'] = sort;
    return data;
  }
}

class ImageData {
  String? image;
  String? link;
  String? sortOrder;

  ImageData({this.image, this.link, this.sortOrder});
  int getSortOrder() {
    // قد تحتاج لتحويل `sortOrder` إلى قيمة عددية
    return int.tryParse(sortOrder ?? '0') ?? 0;
  }

  ImageData.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    link = json['link'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['link'] = link;
    data['sort_order'] = sortOrder;
    return data;
  }
}
