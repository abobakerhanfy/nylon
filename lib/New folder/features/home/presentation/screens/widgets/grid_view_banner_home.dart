import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/cached_network_image.dart';
import 'package:nylon/features/home/data/models/multi_banner.dart';
// شيل التكرار لو عندك import get مكرر
import 'package:nylon/core/function/url_utils.dart';
import 'package:nylon/core/routes/name_pages.dart';

// ignore: must_be_immutable
class GridViewBannerHome extends StatelessWidget {
  final MultiBanner banner;

  GridViewBannerHome({super.key, required this.banner});

  final MyServices _myServices = Get.find();

  @override
  Widget build(BuildContext context) {
    final bool isAr = _myServices.sharedPreferences.getString('Lang') == 'ar';

    // نبني عناصر (صورة + رابط) بدل قائمة صور فقط
    final items = <Map<String, String>>[];

    void addItem(String? imgAr, String? imgEn, String? link) {
      final img = isAr ? imgAr : imgEn;
      if (img != null && img.isNotEmpty) {
        items.add({
          'img': img,
          'link': link ?? '',
        });
      }
    }

    // من الموديل MultiBanner
    addItem(banner.imgAr1, banner.imgEn1, banner.link1);
    addItem(banner.imgAr2, banner.imgEn2, banner.link2);
    addItem(banner.imgAr3, banner.imgEn3, banner.link3);
    addItem(banner.imgAr4, banner.imgEn4, banner.link4);
    addItem(banner.imgAr5, banner.imgEn5, banner.link5);
    addItem(banner.imgAr6, banner.imgEn6, banner.link6);

    if (items.isEmpty) return const SizedBox();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 182 / 323.56,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final imageUrl = item['img']!;
        final link = item['link'] ?? '';

        return InkWell(
          onTap: () {
            final id =
                extractPathParam(link); // هترجع "109_153" أو "154" لو موجودة
            if (id != null && id.isNotEmpty) {
              // نمرّر كل المفاتيح المشهورة علشان ما نخبطش في أي شاشة
              Get.toNamed(
                NamePages.pOneCategory,
                arguments: {
                  'idCategory': id,
                  'category_id': id,
                  'categoryId': id,
                },
              );
            } else {
              // لو اللينك فرندلي بدون ?path= (زي /gift-wrapping-boxes)
              // تقدر هنا تفتح WebView/براوزر أو تعمل ريزولفر للـ SEO URL -> category_id
              // launchUrlString(link);
            }
          },
          child: Container(
            color: AppColors.background,
            child: AspectRatio(
              aspectRatio: 182 / 323.56,
              child: CachedNetworkImageWidget(
                imageUrl: imageUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      },
    );
  }
}
