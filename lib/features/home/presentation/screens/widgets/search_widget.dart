import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/colors_app.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderBlack28, width: 1),
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: TextFormField(
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 18, color: Theme.of(context).scaffoldBackgroundColor),
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            filled: true,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                'images/search.svg',
              ),
            ),
            hintText: '12'.tr,
            hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
