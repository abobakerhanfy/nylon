import 'package:flutter/material.dart';
import 'package:nylon/core/theme/colors_app.dart';

ThemeData themeDataEn= ThemeData(
  fontFamily: 'en',
  textTheme: TextTheme(
    bodySmall: TextStyle(
        fontWeight: FontWeight.w900,
        color:AppColors.textBlack,
        fontSize: 11
    ),
      bodyMedium:   TextStyle(
        fontWeight: FontWeight.bold,
        color:AppColors.textBlack,
        fontSize: 13
    ),
        bodyLarge: const TextStyle(
        fontWeight: FontWeight.normal,
        color:Colors.black,
        fontSize: 15
    ),
    
    headlineSmall:  TextStyle(
        fontWeight: FontWeight.normal,
        color:AppColors.textColor1,
        fontSize: 16
    ),
    headlineMedium:const  TextStyle(
        fontWeight: FontWeight.normal,
        color:Colors.white,
        fontSize: 20
    ),

    headlineLarge:
    const TextStyle(
        fontWeight: FontWeight.normal,
        color:Colors.black,
        fontSize: 20
    ),
    labelSmall: const TextStyle(
        fontWeight: FontWeight.bold,
        color:Colors.black,
        fontSize: 22
    ),
    labelMedium: const TextStyle(
        fontWeight: FontWeight.w400,
        color:Colors.black,
        fontSize: 24
    ),
    labelLarge: const TextStyle(
        fontWeight: FontWeight.normal,
        color:Colors.black,
        fontSize: 26
    ),
  
  ),


);

ThemeData themeDataAr= ThemeData(
fontFamily: 'ar',
  textTheme: TextTheme(
    bodySmall: TextStyle(
        fontWeight: FontWeight.w800,
        color:AppColors.textBlack,
        fontSize: 12
    ),
      bodyMedium:   TextStyle(
        fontWeight: FontWeight.bold,
       color:AppColors.textBlack,
        fontSize: 13
    ),
        bodyLarge: const TextStyle(
        fontWeight: FontWeight.normal,
        color:Colors.black,
        fontSize: 15
    ),
    
    headlineSmall:  TextStyle(
        fontWeight: FontWeight.normal,
        color:AppColors.textColor1,
        fontSize: 16
    ),
    headlineMedium:const  TextStyle(
        fontWeight: FontWeight.normal,
        color:Colors.white,
        fontSize: 18
    ),

    headlineLarge:
    const TextStyle(
        fontWeight: FontWeight.normal,
        color:Colors.black,
        fontSize: 20
    ),
  labelSmall: const TextStyle(
        fontWeight: FontWeight.bold,
        color:Colors.black,
        fontSize: 22
    ),
    labelMedium: const TextStyle(
        fontWeight: FontWeight.w400,
        color:Colors.black,
        fontSize: 24
    ),
    labelLarge: const TextStyle(
        fontWeight: FontWeight.bold,
        color:Colors.black,
        fontSize: 26
    ),
  ),
);