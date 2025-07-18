import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart ' as http;
import 'package:nylon/core/function/status_request.dart';
import 'package:path/path.dart';
import 'check_internet.dart';

class Method {
  Future<Either<StatusRequest, Map>> postData(
      {required String url, required Map data, String? token}) async {
    print(url);
    print(data);

    try {
      if (await checkInInternet()) {
        var response = await http.post(Uri.parse(url), body: data, headers: {
          // 'Accept': 'application/json',
          // if(token != null)
          //   'Authorization': 'Bearer $token',
        });
        print(response.body);
        print(response.body);
        print(url);

        print('posssssssssssssssssssssssst');
        final statusRequest = handleStatusCode(
          response.statusCode,
        );
        if (statusRequest == StatusRequest.success) {
          final responseBody =
              jsonDecode(response.body) as Map<String, dynamic>;
          return Right(responseBody);
        } else {
          return Left(statusRequest);
        }
      } else {
        return const Left(StatusRequest.internetFailure);
      }
    } catch (e) {
      print(e.toString());
      print('errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrror');
      return const Left(StatusRequest.offLienFailure);
    }
  }

  Future<Either<StatusRequest, Map<String, dynamic>>> getData(
      {required String url, String? token}) async {
    try {
      if (await checkInInternet()) {
        var response = await http.get(Uri.parse(url));
        // 'Content-Type': 'application/json',
        // 'Accept': 'application/json',
        // if(token!=null)
        //   'Authorization': 'Bearer $token',

        print(response.body);

        print(url);
        print(response.statusCode);
        print('geeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeet');

        final statusRequest = handleStatusCode(
          response.statusCode,
        );
        if (statusRequest == StatusRequest.success) {
          final responseBody =
              jsonDecode(response.body) as Map<String, dynamic>;
          return Right(responseBody);
        } else {
          return Left(statusRequest);
        }
      } else {
        return const Left(StatusRequest.internetFailure);
      }
    } catch (e) {
      print(e.toString());
      print('errrrrrrrrrrrrrrroe catxh Methoddddddddddddddddddddddddd');

      return const Left(StatusRequest.offLienFailure);
    }
  }

  Future<Either<StatusRequest, Map>> postFileData(
      {required String url,
      required Map data,
      String? token,
      required List<File> images}) async {
    try {
      final Map<String, String> he = {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      if (await checkInInternet()) {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
              url,
            ));
        request.headers.addAll(he);
        for (var image in images) {
          String fileName = image.path.split('/').last;
          var stream = http.ByteStream(image.openRead());
          var length = await image.length();
          var multipartFile = http.MultipartFile(
            'images[]',
            stream,
            length,
            filename: fileName,
          );
          request.files.add(
            multipartFile,
          );
        }
        data.forEach((key, value) {
          request.fields[key] = value;
        });
        var stremR = await request.send();
        var response = await http.Response.fromStream(stremR);
        if (1 == 1) {
          var resbonsMap = jsonDecode(response.body) as Map<String, dynamic>;
          return Right(resbonsMap);
        } else {
          return const Left(StatusRequest.serverFailure);
        }
      } else {
        return const Left(StatusRequest.internetFailure);
      }
    } catch (e) {
      return const Left(StatusRequest.offLienFailure);
    }
  }

  Future<Either<StatusRequest, Map>> postFile(
      {required String url, String? token, required List<File> images}) async {
    try {
      final Map<String, String> he = {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      if (await checkInInternet()) {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
              url,
            ));
        request.headers.addAll(he);
        for (var image in images) {
          String fileName = image.path.split('/').last;
          var stream = http.ByteStream(image.openRead());
          var length = await image.length();
          var multipartFile = http.MultipartFile(
            'images[]',
            stream,
            length,
            filename: fileName,
          );
          request.files.add(
            multipartFile,
          );
        }
        var stremR = await request.send();
        var response = await http.Response.fromStream(stremR);
        if (1 == 1) {
          var resbonsMap = jsonDecode(response.body) as Map<String, dynamic>;
          return Right(resbonsMap);
        } else {
          return const Left(StatusRequest.serverFailure);
        }
      } else {
        return const Left(StatusRequest.internetFailure);
      }
    } catch (e) {
      return const Left(StatusRequest.offLienFailure);
    }
  }

// https://khaled.nylonsa.com/index.php?route=api/api/payment/upload&api_token=5d791c8fe833a7a1af52a5dab3
//https://khaled.nylonsa.com/index.php?route=api/payment/upload&api_token=5e39b5b4e3d0fa5929e0d55738
  Future<Either<StatusRequest, Map>> postOneImage(
      {required String url,
      required Map data,
      required File file,
      String? token}) async {
    try {
      final Map<String, String> he = {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      if (await checkInInternet()) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(url),
        );
        print(url);
        request.headers.addAll(he);
        var length = await file.length();
        var strem = http.ByteStream(file.openRead());
        var multipartR = http.MultipartFile('file', strem, length,
            filename: basename(file.path));
        request.files.add(multipartR);
        data.forEach((key, value) {
          request.fields[key] = value;
        });
        var resbons = await request.send();
        var resbosbody = await http.Response.fromStream(resbons);
        final statusRequest = handleStatusCode(
          resbosbody.statusCode,
        );
        print('=================================${resbosbody.body}');
        if (statusRequest == StatusRequest.success) {
          print('sssssssssssssssssssssssssssssssssssssssssssss090');
          print(resbosbody.body);

          var resbonsMap = jsonDecode(resbosbody.body) as Map<String, dynamic>;
          return Right(resbonsMap);
        } else {
          return const Left(StatusRequest.serverFailure);
        }
      } else {
        print('CheckIntrnet');
        return const Left(StatusRequest.internetFailure);
      }
    } catch (e) {
      print('jjjjjjjjjjjjjjjjjjj');
      print(e.toString());
      return const Left(StatusRequest.offLienFailure);
    }
  }

  Future<void> getDatas(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("Logged out successfully");
    } else {
      print("Failed to logout: ${response.statusCode}");
    }
  }
}
