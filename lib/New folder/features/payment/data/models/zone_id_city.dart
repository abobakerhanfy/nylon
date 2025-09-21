import 'dart:convert';

class Zone {
  String zoneId;
  String countryId;
  String name;
  String nameAr;
  String code;
  String status;

  Zone({
    required this.zoneId,
    required this.countryId,
    required this.name,
    required this.nameAr,
    required this.code,
    required this.status,
  });

  // Factory constructor to parse from JSON
  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      zoneId: json['zone_id'],
      countryId: json['country_id'],
      name: json['name'],
      nameAr: json['name_ar'],
      code: json['code'] ?? '', // In case of empty code
      status: json['status'],
    );
  }

  // Method to convert object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'zone_id': zoneId,
      'country_id': countryId,
      'name': name,
      'name_ar': nameAr,
      'code': code,
      'status': status,
    };
  }
}

List<Zone> parseZonesList(String jsonStr) {
  final parsed = json.decode(jsonStr).cast<Map<String, dynamic>>();
  return parsed.map<Zone>((json) => Zone.fromJson(json)).toList();
}
