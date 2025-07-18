class RewardModel {
  List<Reward>? data;

  RewardModel({this.data});

  RewardModel.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List?)?.map((e) => Reward.fromJson(e)).toList();

  Map<String, dynamic> toJson() => {
        if (data != null) 'data': data!.map((v) => v.toJson()).toList(),
      };
}

class Reward {
  String? rewardId;
  String? name;
  String? type;
  String? value;
  String? status;
  String? dateAdded;

  Reward({
    this.rewardId,
    this.name,
    this.type,
    this.value,
    this.status,
    this.dateAdded,
  });

  Reward.fromJson(Map<String, dynamic> json)
      : rewardId = json['reward_id'],
        name = json['name'],
        type = json['type'],
        value = json['value'],
        status = json['status'],
        dateAdded = json['date_added'];

  Map<String, dynamic> toJson() => {
        'reward_id': rewardId,
        'name': name,
        'type': type,
        'value': value,
        'status': status,
        'date_added': dateAdded,
      };
}
