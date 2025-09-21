import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/routes/name_pages.dart';

import 'package:nylon/features/home/data/models/mobile_featured.dart';
import 'package:nylon/features/home/presentation/screens/widgets/products_container_home.dart';
import 'package:nylon/features/home/presentation/screens/widgets/widget_see_all.dart';

// ignore: must_be_immutable
class ProductsListOnHome extends StatelessWidget {
  final List<Productss> products;
  String? nameAr;
  String? nameEn;
  final String? categoryId; // ← جديد

  ProductsListOnHome({
    super.key,
    required this.products,
    this.nameAr,
    this.nameEn,
    this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return products.isNotEmpty
        ? Column(
            children: [
              if (nameAr != null || nameEn != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SeeAll(
                    onTap: () {
                      final id = (categoryId ?? '').trim();
                      debugPrint('before -> OneCategory (SeeAll) id=$id');

                      if (id.isEmpty) {
                        Get.snackbar('تنبيه', 'القسم غير معروف.');
                        return;
                      }
                      // للتتبع في اللوج
                      debugPrint('NAV -> OneCategory (SeeAll) id=$id');

                      Get.toNamed(
                        NamePages.pOneCategory,
                        arguments: {
                          'categoryId': id,
                          'titleAr': nameAr,
                          'titleEn': nameEn,
                        },
                      );
                    },
                    titleAr: nameAr ?? '',
                    titleEn: nameEn ?? '',
                  ),
                ),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, i) {
                    return ProductsContainerHome(
                      products: products[i],
                      onTap: () {
                        Get.toNamed(NamePages.pOneProduct,
                            arguments: products[i]);
                      },
                      onTapFavorite: () {
                        print(products[i].price);
                        print(products[i].description);
                      },
                      onTapCart: () {},
                    );
                  },
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}
