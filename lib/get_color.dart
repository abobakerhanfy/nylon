import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:nylon/core/function/method_GPUD.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/home/data/data_sources/home_data_source.dart';

Future<Color> loadBackgroundColor() async {
  try {
    final homeDataSource = HomeDataSourceImpl(Method());

    final themeResponse = await homeDataSource.getTheme();

    return themeResponse.fold(
      (failure) {
        return fullAppBackgroundColor;
      },
      (data) {
        print('mohamed $data');
        final hex = data["data"]["background_color"];
        return hexToColor(hex);
      },
    );
  } catch (e) {
    //return hexToColor('bd9835');
    return fullAppBackgroundColor;
  }
}

Color hexToColor(String hex) {
  hex = hex.replaceAll("#", "");
  if (hex.length == 6) hex = "FF$hex";
  return Color(int.parse(hex, radix: 16));
}
