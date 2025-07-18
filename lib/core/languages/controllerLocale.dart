import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../services/services.dart';
import '../theme/text_theme.dart';

class ControllerLocal extends GetxController{
  MyServices myServices = Get.find();
  Locale? languages;
  ThemeData abbThem = themeDataEn ;
late bool isLangAr;
  chooseLanguages({required String codeLocale,required Function() than }){
Locale locale = Locale(codeLocale);

myServices.sharedPreferences.setString('Lang', codeLocale);
abbThem = codeLocale == 'en'?themeDataEn:themeDataAr;
Get.changeTheme(abbThem);
isLangAr = codeLocale == 'en'? false:true;
Get.updateLocale(locale).then((value) => than());
    print(codeLocale);
update();

  }
@override
  void onInit() {
  String? sharedPrefLang = myServices.sharedPreferences.getString('Lang');
  if(sharedPrefLang=='ar'){
    languages=const Locale('ar');
    initializeDateFormatting("ar");
    abbThem = themeDataAr;
    isLangAr = true;

  }else if(sharedPrefLang=='en'){
    initializeDateFormatting('en');
    languages=const Locale('en');
    abbThem = themeDataEn;
    isLangAr = false;
  }else{
    languages = Locale(Get.deviceLocale!.languageCode);
  }
  print(languages);
    super.onInit();
    update();
  }



}