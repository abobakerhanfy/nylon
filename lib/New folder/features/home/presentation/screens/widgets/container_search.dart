
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/colors_app.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const  EdgeInsets.symmetric(vertical: 6),
      alignment: Alignment.center,
      width: 304,
      height: 37,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.borderBlack28, width: 1)
      ),
      child: ClipRRect( // استخدم ClipRRect لقص المحتوى إلى حواف الـ Container
        borderRadius: BorderRadius.circular(15),
        child: TextFormField(
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 18,color: Colors.black),
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            filled: false,
            hintText: '12'.tr,
            hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black,fontSize: 11
            ),
            border: InputBorder.none,
            prefixIcon:  SvgPicture.asset('images/search.svg'),
          ),
          cursorHeight:35.0,
          cursorColor: Colors.blue,
          clipBehavior: Clip.antiAlias,
        ),
      ),
    );
  }
}
