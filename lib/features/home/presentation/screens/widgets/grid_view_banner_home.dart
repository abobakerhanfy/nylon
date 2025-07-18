import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/cached_network_image.dart';
import 'package:nylon/features/home/data/models/multi_banner.dart';

// ignore: must_be_immutable
class GridViewBannerHome extends StatelessWidget {
  final MultiBanner banner;

  GridViewBannerHome({super.key, required this.banner});

  final MyServices _myServices = Get.find();

  @override
  Widget build(BuildContext context) {
    bool isAr = _myServices.sharedPreferences.getString('Lang') == 'ar';

    List<String?> imageUrls =
        isAr ? banner.arabicImageUrls : banner.englishImageUrls;

    return imageUrls.isNotEmpty
        ? GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 182 / 323.56,
            ),
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              final imageUrl = imageUrls[index];
              return Container(
                color: AppColors.background,
                child: AspectRatio(
                  aspectRatio: 182 / 323.56,
                  child: CachedNetworkImageWidget(
                    imageUrl: imageUrl!,
                    fit: BoxFit.fill,
                  ),
                ),
              );

              // Container(
              //   color: Colors.black26,
              //   child: imageUrl != null
              //       ? AspectRatio(
              //           aspectRatio: 182 / 323.56,
              //           child: Image.network(
              //             imageUrl,
              //             fit: BoxFit.cover,
              //           ),
              //         )
              //       : const Center(
              //           child: Text('No Image'),
              //         ),
              // );
            },
          )
        : const SizedBox();
  }
}
