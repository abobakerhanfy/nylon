import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/languages/function_string.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/cached_network_image.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';
import 'package:nylon/features/category/presentation/screens/screen_one_Category.dart';
import 'package:nylon/features/favorites/data/models/favorites_model.dart';
import 'package:nylon/features/favorites/presentation/controller/controller_favorites.dart';

class FavoriteConatainerItems extends StatelessWidget {
  final Products products;
  FavoriteConatainerItems({
    super.key,
    required this.products,
  });
  final ControllerFavorites _controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(NamePages.pOneProduct, arguments: products);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 149,
        decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12)),
        child: LayoutBuilder(builder: (context, boxSize) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(6),
                  child: CachedNetworkImageWidget(
                    fit: BoxFit.contain,
                    imageUrl: products.thumb ?? '',
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  translate(products.name ?? '',
                                      products.name ?? '')!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.normal,
                                          color: AppColors.textColor1),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              InkWell(
                                onTap: () {
                                  _controller.addOrRemoveFavorites(
                                      idProduct: products.productId!);
                                },
                                child: CircleAvatar(
                                    backgroundColor: AppColors.primaryColor,
                                    radius: 12,
                                    child: Center(
                                        child: Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ))),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: boxSize.maxHeight * 0.04,
                          ),
                          Text(
                              translate(
                                  products.model ?? '', products.model ?? '')!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.greyColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatPrice(products.price),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.primaryColor,
                                ),
                            maxLines: 2,
                          ),
                          const SizedBox(width: 4),
                          Image.asset(
                            "images/riyalsymbol_compressed.png",
                            height: 14,
                          ),
                          SizedBox(
                            height: boxSize.maxHeight * 0.05,
                          ),
                          GetBuilder<ControllerCart>(builder: (controllerCart) {
                            int:
                            ControllerCart();
                            return InkWell(
                              onTap: () {
                                controllerCart.addOrRemoveCart(
                                    idProduct: products.productId!,
                                    quantity: 1);
                              },
                              child: Container(
                                width: boxSize.maxWidth * 0.55,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    border: Border.all(
                                        color: AppColors.primaryColor,
                                        width: 1)),
                                child: Text(
                                  controllerCart.cartMap
                                          .containsKey(products.productId)
                                      ? '150'.tr
                                      : '62'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppColors.primaryColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400),
                                ),
                              ),
                            );
                          })
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
