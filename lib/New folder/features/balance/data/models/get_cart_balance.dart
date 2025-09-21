class GetBalanceCart {
  List<Totals>? totals;

  GetBalanceCart({this.totals});

  GetBalanceCart.fromJson(Map<String, dynamic> json) {
    if (json['totals'] != null) {
      totals = <Totals>[];
      json['totals'].forEach((v) {
        totals!.add(Totals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (totals != null) {
      data['totals'] = totals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Totals {
  String? title;
  String? text;

  Totals({this.title, this.text});

  Totals.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['text'] = text;
    return data;
  }
}
