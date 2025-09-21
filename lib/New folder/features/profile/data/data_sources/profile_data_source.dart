import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/url/url_api.dart'; // Added missing import for AppApi
import 'package:nylon/features/profile/data/models/address_list_model.dart';

abstract class ProfileDataSource {
  Future<Either<StatusRequest, Map>> urlUpdataUserData({required Map data});
  Future<Either<StatusRequest, Map>> getCustomerById();
  Future<Either<StatusRequest, List<Address>>> getAddresses();
}

class ProfileDataSourceImpl implements ProfileDataSource {
  final Method _method;
  ProfileDataSourceImpl(this._method);
  final MyServices _myServices = Get.find();

  @override
  Future<Either<StatusRequest, Map>> urlUpdataUserData({required Map data}) async {
    print(data);
    var response = await _method.postData(
        url:
            '${AppApi.urlUpdataUserData}${_myServices.sharedPreferences.getString('token')}${_myServices.getLanguageCode()}',
        data: data);
    return response.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<StatusRequest, Map>> getCustomerById() async {
    var respnse = await _method.postData(
        url:
            '${AppApi.urlgetCustomerById}${_myServices.sharedPreferences.getString('token')}${_myServices.getLanguageCode()}',
        data: {'customer_id': _myServices.sharedPreferences.getString('UserId')});
    return respnse.fold((failure) {
      return left(failure);
    }, (data) {
      return right(data);
    });
  }

  // Moved getAddresses implementation inside the class
  @override
  Future<Either<StatusRequest, List<Address>>> getAddresses() async {
    // Assuming getCustomerById returns addresses under an 'addresses' key
    // This might need adjustment based on the actual API response structure
    var response = await getCustomerById();
    return response.fold(
      (failure) {
        print("Failed to get customer data for addresses: $failure");
        return left(failure);
      },
      (data) {
        // Check if the key exists and is a map before accessing 'addresses'
        if (data.containsKey("data") && data["data"] is Map && (data["data"] as Map).containsKey("addresses") && data["data"]["addresses"] is List) {
          try {
            List<Address> addresses = (data["data"]["addresses"] as List)
                .map((addrJson) => Address.fromJson(addrJson as Map<String, dynamic>))
                .toList();
            print("Successfully parsed ${addresses.length} addresses.");
            return right(addresses);
          } catch (e) {
            print("Error parsing addresses: $e");
            return left(StatusRequest.serverFailure); // Or a more specific error
          }
        } else {
          // Handle case where addresses are not found or format is wrong
          print("Addresses key not found or invalid format in getCustomerById response data");
          print("Response data: $data"); // Log the actual data for debugging
          return right([]); // Return empty list as success, but with no addresses
        }
      },
    );
  }
}

