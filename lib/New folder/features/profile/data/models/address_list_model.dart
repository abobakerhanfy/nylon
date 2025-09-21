import 'dart:convert';

// Function to parse the list of addresses
List<Address> addressListFromJson(String str) => List<Address>.from(json.decode(str).map((x) => Address.fromJson(x)));

// Function to encode the list of addresses
String addressListToJson(List<Address> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Address {
    String? addressId;
    String? firstname;
    String? lastname;
    String? company;
    String? address1;
    String? address2;
    String? postcode;
    String? city;
    String? zoneId;
    String? zone;
    String? zoneCode;
    String? countryId;
    String? country;
    String? isoCode2;
    String? isoCode3;
    String? addressFormat;
    bool? defaultAddress; // Added to indicate if it's the default

    Address({
        this.addressId,
        this.firstname,
        this.lastname,
        this.company,
        this.address1,
        this.address2,
        this.postcode,
        this.city,
        this.zoneId,
        this.zone,
        this.zoneCode,
        this.countryId,
        this.country,
        this.isoCode2,
        this.isoCode3,
        this.addressFormat,
        this.defaultAddress,
    });

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        addressId: json["address_id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        company: json["company"],
        address1: json["address_1"],
        address2: json["address_2"],
        postcode: json["postcode"],
        city: json["city"],
        zoneId: json["zone_id"],
        zone: json["zone"],
        zoneCode: json["zone_code"],
        countryId: json["country_id"],
        country: json["country"],
        isoCode2: json["iso_code_2"],
        isoCode3: json["iso_code_3"],
        addressFormat: json["address_format"],
        // Assuming the API might return '1' or '0' for default
        defaultAddress: json["default"] == '1' || json["default"] == true,
    );

    Map<String, dynamic> toJson() => {
        "address_id": addressId,
        "firstname": firstname,
        "lastname": lastname,
        "company": company,
        "address_1": address1,
        "address_2": address2,
        "postcode": postcode,
        "city": city,
        "zone_id": zoneId,
        "zone": zone,
        "zone_code": zoneCode,
        "country_id": countryId,
        "country": country,
        "iso_code_2": isoCode2,
        "iso_code_3": isoCode3,
        "address_format": addressFormat,
        "default": defaultAddress == true ? '1' : '0',
    };

    // Helper to get a displayable string for the address
    String get displayAddress {
      List<String> parts = [];
      if (firstname != null && firstname!.isNotEmpty) parts.add(firstname!);
      if (lastname != null && lastname!.isNotEmpty) parts.add(lastname!);
      if (address1 != null && address1!.isNotEmpty) parts.add(address1!);
      if (address2 != null && address2!.isNotEmpty) parts.add(address2!);
      if (city != null && city!.isNotEmpty) parts.add(city!);
      if (zone != null && zone!.isNotEmpty) parts.add(zone!);
      if (country != null && country!.isNotEmpty) parts.add(country!);
      if (postcode != null && postcode!.isNotEmpty) parts.add(postcode!);
      return parts.join(', ');
    }
}

