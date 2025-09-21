import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/widgets/cached_network_image.dart';
import 'package:nylon/features/home/data/models/mobile_featured.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/icon_add_cart.dart';
import 'package:nylon/features/favorites/presentation/screens/widgets/icon_add_favorite.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';

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
  double parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is int) return price.toDouble();
    if (price is double) return price;
    if (price is bool) return 0.0;

    String priceString = price.toString();

    // إزالة HTML tags والمحتوى غير المرغوب فيه
    priceString = priceString.replaceAll(RegExp(r'<[^>]*>'), '');
    priceString = priceString.replaceAll(RegExp(r'[^\d.]'), '');

    // التحقق من وجود نقاط متعددة
    List<String> parts = priceString.split('.');
    if (parts.length > 2) {
      priceString = '${parts[0]}.${parts[1]}';
    }

    if (priceString.isEmpty) return 0.0;

    try {
      return double.parse(priceString);
    } catch (e) {
      print('Error parsing price: $price -> $priceString');
      return 0.0;
    }
  }

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
                              GetBuilder<ControllerCart>(
                                builder: (cart) {
                                  final pid = products.productId!.toString();
                                  final items =
                                      cart.cartModel.value?.products ?? [];
                                  final idx = items.indexWhere((p) =>
                                      (p.productId?.toString() ?? '') == pid);

                                  // اقرا الكمية الحالية بأمان (سواء quantityC أو quantity)
                                  final qStr = idx == -1
                                      ? '0'
                                      : (items[idx].quantityC ??
                                          items[idx].quantity ??
                                          '0');
                                  final qty = int.tryParse(qStr) ?? 0;

                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      // الأيقونة نفسها + اللمس لزيادة الكمية
                                      InkWell(
                                        onTap: () async {
                                          if (idx == -1) {
                                            // المنتج مش موجود في السلة → ضيفه 1
                                            await cart.addCart(
                                                idProduct: pid, quantity: 1);
                                          } else {
                                            // المنتج موجود → زوّد كميته +1
                                            final next = qty + 1;
                                            final cartId = cart.cartMap[pid];
                                            if (cartId != null) {
                                              await cart.editCartProduct(
                                                  cartId: cartId,
                                                  quantity: next);
                                            } else {
                                              // احتياطي لو الخريطة لسه ما اتحدّثتش
                                              await cart.getCart();
                                            }
                                          }

                                          // حدّث إجمالي السلة فوراً (10 → 11)
                                          await cart.getCart();
                                        },
                                        child: CartIcon(
                                            idProduct: products.productId!),
                                      ),

                                      // لو عايز تشيل البادچ من على أيقونة الكارت احذف البلوك ده👇
                                      if (qty > 0)
                                        const Positioned(
                                          top: -6,
                                          right: -6,
                                          child: SizedBox
                                              .shrink(), // ← أو حط بادچ لو حابب
                                        ),
                                    ],
                                  );
                                },
                              ),
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
                                                            : parsePrice(
                                                                products.price))
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
                                                            : parsePrice(
                                                                products
                                                                    .special))
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
                                                            : parsePrice(
                                                                products
                                                                    .special))
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
