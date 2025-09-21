class MobileSlider {
  List<ImageData>? image;
  String? status; // نخزّن كنص عشان اختلاف النوع من الـ API
  String? sort;

  MobileSlider({this.image, this.status, this.sort});

  int getSortOrder() {
    // يدعم لو sort كانت "3" أو 3 أو null
    final s = sort?.trim();
    if (s == null || s.isEmpty) return 0;
    return int.tryParse(s) ?? 0;
  }

  MobileSlider.fromJson(Map<String, dynamic> json) {
    if (json['image'] != null) {
      final list = json['image'];
      if (list is List) {
        image = list
            .whereType<Map<String, dynamic>>()
            .map((v) => ImageData.fromJson(v))
            .toList();
      } else {
        image = <ImageData>[];
      }
    }
    // 👇 تحويل آمن يدعم int أو String أو null
    status = _asString(json['status']);
    sort = _asString(json['sort']);
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
    final s = sortOrder?.trim();
    if (s == null || s.isEmpty) return 0;
    return int.tryParse(s) ?? 0;
  }

  ImageData.fromJson(Map<String, dynamic> json) {
    image = _asString(json['image']);
    link = _asString(json['link']);
    // أحيانًا بتيجي رقم: 0 أو 1، فحوّلناها لنص آمن
    sortOrder = _asString(json['sort_order']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['link'] = link;
    data['sort_order'] = sortOrder;
    return data;
  }
}

/// ===== Helpers =====
String? _asString(dynamic v) {
  if (v == null) return null;
  return v.toString();
}
