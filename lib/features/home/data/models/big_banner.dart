class BigBanner {
  String? en;
  String? ar;
  String? imageEn;
  String? imageAr;
  String? categories;
  String? status;
  String? sort;

  BigBanner(
      {this.en,
      this.ar,
      this.imageEn,
      this.imageAr,
      this.categories,
      this.status,
      this.sort});
  int getSortOrder() {
    // قد تحتاج لتحويل `sort` إلى قيمة عددية
    return int.tryParse(sort ?? '0') ?? 0;
  }

  BigBanner.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
    imageEn = json['image_en'];
    imageAr = json['image_ar'];
    categories = json['categories'];
    status = json['status'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['en'] = en;
    data['ar'] = ar;
    data['image_en'] = imageEn;
    data['image_ar'] = imageAr;
    data['categories'] = categories;
    data['status'] = status;
    data['sort'] = sort;
    return data;
  }
}
