import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/languages/function_string.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/cached_network_image.dart';

import '../../../data/models/one_order_model.dart';

class ItemsMyOrdersWidget extends StatelessWidget {
  final List<Products> products;
  const ItemsMyOrdersWidget({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, i) => const SizedBox(height: 15),
      itemCount: products.length ?? 0,
      itemBuilder: (context, i) {
        return InkWell(
          onTap: () {
            Get.toNamed(NamePages.pOneProduct, arguments: products[i]);
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: 394,
            height: 92,
            decoration: BoxDecoration(
                color: AppColors.colorBackgroundOrder,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.colorBackgroundOrder,
                      spreadRadius: 0.5,
                      blurRadius: 4)
                ],
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 52,
                      height: 52,
                      child: CachedNetworkImageWidget(
                        height: 52,
                        imageUrl: products[i].image ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translate(
                              products[i].name ?? '',
                              products[i].name ?? '',
                            )!,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${products[i].productPrice} X',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.pinkColor,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              Text(
                                '  ${products[i].quantity ?? ''}  ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: AppColors.pinkColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15),
                              ),
                              const Spacer(),
                              Text(
                                '${products[i].totalOrderWithoutTax}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.pinkColor,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(width: 4),
                              Image.asset("images/riyalsymbol_compressed.png",
                                  height: 14),
                            ],
                          )
                        ],
                      ),
                    ),

                    // const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
