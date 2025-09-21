class SlidersModel {
  String? name;
  List<Sliders>? sliders;
  String? stauts;

  SlidersModel({this.name, this.sliders, this.stauts});

  SlidersModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['sliders'] != null) {
      sliders = <Sliders>[];
      json['sliders'].forEach((v) {
        sliders!.add(Sliders.fromJson(v));
      });
    }
    stauts = json['stauts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (sliders != null) {
      data['sliders'] = sliders!.map((v) => v.toJson()).toList();
    }
    data['stauts'] = stauts;
    return data;
  }
}

class Sliders {
  String? name;
  String? link;

  Sliders({this.name, this.link});

  Sliders.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['link'] = link;
    return data;
  }
}
