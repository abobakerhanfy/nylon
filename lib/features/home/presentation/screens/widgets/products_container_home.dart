import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/widgets/cached_network_image.dart';
import 'package:nylon/features/home/data/models/mobile_featured.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/icon_add_cart.dart';
import 'package:nylon/features/favorites/presentation/screens/widgets/icon_add_favorite.dart';

import '../../../../../core/languages/function_string.dart';
import '../../../../../core/theme/colors_app.dart';

// ignore: must_be_immutable
class ProductsContainerHome extends StatelessWidget {
  final Productss products;
  int? ratings;
  final Function() onTap;
  final Function() onTapFavorite;
  final Function() onTapCart;
  ProductsContainerHome(
      {super.key,
      required this.products,
      required this.onTapFavorite,
      required this.onTapCart,
      required this.onTap});
  final MyServices _myServices = Get.find();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: _myServices.sharedPreferences.getString('Lang') == 'ar'
          ? Alignment.topLeft
          : Alignment.topRight,
      children: [
        SizedBox(
          width: 185,
          child: InkWell(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border.all(color: AppColors.borderBlack28, width: 0.05),
                  borderRadius: BorderRadius.circular(15)),
              child: LayoutBuilder(builder: (context, size) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Stack(
                        alignment:
                            _myServices.sharedPreferences.getString('Lang') ==
                                    'ar'
                                ? Alignment.topLeft
                                : Alignment.topRight,
                        children: [
                          CachedNetworkImageWidget(
                            fit: BoxFit.contain,
                            imageUrl: products.image ?? '',
                          ),
                          // وضع شارة العرض وأيقونة المفضلة في صف واحد
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // تحقق إذا كان هناك عرض وأضف شارة العرض
                                if (products.offer != null &&
                                    products.offer!.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffff6f61),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      'عرض',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                // أيقونة المفضلة
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: onTapFavorite,
                                child: FavoriteIcon(
                                  idProduct: products.productId!,
                                ),
                              ),
                              CartIcon(idProduct: products.productId!),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        color: Colors.white,
                        child: Stack(
                          alignment:
                              _myServices.sharedPreferences.getString('Lang') ==
                                      'ar'
                                  ? Alignment.bottomLeft
                                  : Alignment.bottomRight,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  translate(products.name, products.name)!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: AppColors.textColor),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (products.rating != null)
                                  StarRatingWidget(
                                    rating: products.rating!.toDouble(),
                                  ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (products.price != null &&
                                            products.price is! bool &&
                                            products.price != 0)
                                          Row(
                                            children: [
                                              Text(
                                                (products.price is int
                                                        ? (products.price
                                                                as int)
                                                            .toDouble()
                                                        : products.price
                                                                is double
                                                            ? products.price
                                                                as double
                                                            : double.parse(
                                                                products
                                                                    .price!))
                                                    .toStringAsFixed(2),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                              ),
                                              const SizedBox(width: 4),
                                              Image.asset(
                                                  "images/riyalsymbol_compressed.png",
                                                  height: 14),
                                            ],
                                          ),
                                        if (products.special != null &&
                                            products.special is! bool &&
                                            products.special != 0 &&
                                            products.price != 0)
                                          Row(
                                            children: [
                                              Text(
                                                (products.special is int
                                                        ? (products.special
                                                                as int)
                                                            .toDouble()
                                                        : products.special
                                                                is double
                                                            ? products.special
                                                                as double
                                                            : double.parse(
                                                                products
                                                                    .special!))
                                                    .toStringAsFixed(2),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: Colors.black45,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 14,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      decorationStyle:
                                                          TextDecorationStyle
                                                              .double,
                                                      decorationThickness: Get
                                                                  .locale
                                                                  ?.languageCode ==
                                                              "ar"
                                                          ? 3.0
                                                          : 1,
                                                      decorationColor:
                                                          Colors.black,
                                                    ),
                                              ),
                                              const SizedBox(width: 4),
                                              Image.asset(
                                                  "images/riyalsymbol_compressed.png",
                                                  height: 14),
                                            ],
                                          ),
                                        if (products.special != null &&
                                            products.special is! bool &&
                                            products.special != 0 &&
                                            products.price == 0)
                                          Row(
                                            children: [
                                              Text(
                                                (products.special is int
                                                        ? (products.special
                                                                as int)
                                                            .toDouble()
                                                        : products.special
                                                                is double
                                                            ? products.special
                                                                as double
                                                            : double.parse(
                                                                products
                                                                    .special!))
                                                    .toStringAsFixed(2),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                              ),
                                              const SizedBox(width: 4),
                                              Image.asset(
                                                  "images/riyalsymbol_compressed.png",
                                                  height: 14),
                                            ],
                                          ),
                                      ],
                                    ),
                                    if (products.afterDiscount != null &&
                                        products.afterDiscount != 0)
                                      DiscountWidgetOnContainer(
                                          discount: products.afterDiscount!),
                                    const SizedBox.shrink(),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class DiscountWidgetOnContainer extends StatelessWidget {
  const DiscountWidgetOnContainer({super.key, required this.discount});

  final dynamic discount;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(
              0xffff6f61), // const Color.fromARGB(255, 161, 38, 38),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          '$discount%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontSize: 12,
              ),
        ));
  }
}

class StarRatingWidget extends StatelessWidget {
  final double rating; // تقييم بين 0 و 5
  final int starCount = 5; // عدد النجوم الكلي (مثلاً 5)

  const StarRatingWidget({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    for (int i = 0; i < starCount; i++) {
      if (i < rating) {
        stars.add(const Icon(
          Icons.star,
          color: Colors.yellow,
          size: 16,
        ));
      } else {
        stars.add(const Icon(
          Icons.star_border,
          color: Colors.black26,
          size: 16,
        ));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }
}
