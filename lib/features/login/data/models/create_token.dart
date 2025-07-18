class CreateTokenModel {
  String? success;
  String? apiId;
  String? apiToken;

  CreateTokenModel({this.success, this.apiId, this.apiToken});

  CreateTokenModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    apiId = json['api_id'];
    apiToken = json['api_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['api_id'] = apiId;
    data['api_token'] = apiToken;
    return data;
  }
}
