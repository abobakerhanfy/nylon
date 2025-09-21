class MultiBanner {
  String? en1;
  String? ar1;
  String? imgEn1;
  String? imgAr1;
  String? link1;
  String? en2;
  String? ar2;
  String? imgEn2;
  String? imgAr2;
  String? link2;
  String? en3;
  String? ar3;
  String? imgEn3;
  String? imgAr3;
  String? link3;
  String? en4;
  String? ar4;
  String? imgEn4;
  String? imgAr4;
  String? link4;
  String? en5;
  String? ar5;
  String? imgEn5;
  String? imgAr5;
  String? link5;
  String? en6;
  String? ar6;
  String? imgEn6;
  String? imgAr6;
  String? link6;
  String? sortOrder;

  MultiBanner(
      {this.en1,
      this.ar1,
      this.imgEn1,
      this.imgAr1,
      this.link1,
      this.en2,
      this.ar2,
      this.imgEn2,
      this.imgAr2,
      this.link2,
      this.en3,
      this.ar3,
      this.imgEn3,
      this.imgAr3,
      this.link3,
      this.en4,
      this.ar4,
      this.imgEn4,
      this.imgAr4,
      this.link4,
      this.en5,
      this.ar5,
      this.imgEn5,
      this.imgAr5,
      this.link5,
      this.en6,
      this.ar6,
      this.imgEn6,
      this.imgAr6,
      this.link6,
      this.sortOrder});
  int getSortOrder() {
    return int.tryParse(sortOrder ?? '0') ?? 0;
  }

  List<String?> get englishImageUrls => [
        imgEn1,
        imgEn2,
        imgEn3,
        imgEn4,
        imgEn5,
        imgEn6,
      ]..removeWhere((url) => url == null);

  List<String?> get arabicImageUrls => [
        imgAr1,
        imgAr2,
        imgAr3,
        imgAr4,
        imgAr5,
        imgAr6,
      ]..removeWhere((url) => url == null);

  MultiBanner.fromJson(Map<String, dynamic> json) {
    en1 = json['en_1'];
    ar1 = json['ar_1'];
    imgEn1 = json['img_en_1'];
    imgAr1 = json['img_ar_1'];
    link1 = json['link_1'];
    en2 = json['en_2'];
    ar2 = json['ar_2'];
    imgEn2 = json['img_en_2'];
    imgAr2 = json['img_ar_2'];
    link2 = json['link_2'];
    en3 = json['en_3'];
    ar3 = json['ar_3'];
    imgEn3 = json['img_en_3'];
    imgAr3 = json['img_ar_3'];
    link3 = json['link_3'];
    en4 = json['en_4'];
    ar4 = json['ar_4'];
    imgEn4 = json['img_en_4'];
    imgAr4 = json['img_ar_4'];
    link4 = json['link_4'];
    en5 = json['en_5'];
    ar5 = json['ar_5'];
    imgEn5 = json['img_en_5'];
    imgAr5 = json['img_ar_5'];
    link5 = json['link_5'];
    en6 = json['en_6'];
    ar6 = json['ar_6'];
    imgEn6 = json['img_en_6'];
    imgAr6 = json['img_ar_6'];
    link6 = json['link_6'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['en_1'] = en1;
    data['ar_1'] = ar1;
    data['img_en_1'] = imgEn1;
    data['img_ar_1'] = imgAr1;
    data['link_1'] = link1;
    data['en_2'] = en2;
    data['ar_2'] = ar2;
    data['img_en_2'] = imgEn2;
    data['img_ar_2'] = imgAr2;
    data['link_2'] = link2;
    data['en_3'] = en3;
    data['ar_3'] = ar3;
    data['img_en_3'] = imgEn3;
    data['img_ar_3'] = imgAr3;
    data['link_3'] = link3;
    data['en_4'] = en4;
    data['ar_4'] = ar4;
    data['img_en_4'] = imgEn4;
    data['img_ar_4'] = imgAr4;
    data['link_4'] = link4;
    data['en_5'] = en5;
    data['ar_5'] = ar5;
    data['img_en_5'] = imgEn5;
    data['img_ar_5'] = imgAr5;
    data['link_5'] = link5;
    data['en_6'] = en6;
    data['ar_6'] = ar6;
    data['img_en_6'] = imgEn6;
    data['img_ar_6'] = imgAr6;
    data['link_6'] = link6;
    data['sort_order'] = sortOrder;
    return data;
  }
}
