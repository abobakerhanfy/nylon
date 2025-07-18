import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/controller/home/controller_home_widget.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/languages/function_string.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/cached_network_image.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/icon_add_cart.dart';
import 'package:nylon/features/category/data/models/category_model.dart';
import 'package:nylon/features/category/presentation/controller/controller_one_category.dart';
import 'package:nylon/features/favorites/presentation/screens/widgets/icon_add_favorite.dart';
import 'package:nylon/features/home/presentation/screens/widgets/products_container_home.dart';
import 'package:nylon/view/home/widgets.dart';

class ViewOneCategory extends StatefulWidget {
  const ViewOneCategory({super.key});

  @override
  State<ViewOneCategory> createState() => _ViewOneCategoryState();
}

class _ViewOneCategoryState extends State<ViewOneCategory> {
  final ControllerOneCategory _controller = Get.find();
  // Store the selected sort value

  Map<String, String> sorts = {
    "p.sort_order-ASC": "الافتراضي",
    "pd.name-ASC": "الإسم من أ - ي",
    "pd.name-DESC": "الإسم من ي - أ",
    "p.price-ASC": "حسب السعر (منخفض > مرتفع)",
    "p.price-DESC": "حسب السعر (مرتفع > منخفض)",
    "rating-DESC": "الأعلى تقييمًا",
    "rating-ASC": "الأقل تقييمًا",
    "p.model-ASC": "النوع (أ - ي)",
    "p.model-DESC": "النوع (ي - أ)"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: customAppBar(
          label: translate(
              _controller.category!.title!, _controller.category!.title!)!,
          isBack: true,
          onTap: () {
            ControllerHomeWidget controllerHomeWidget = Get.find();
            Get.offNamed(NamePages.pBottomBar);
            controllerHomeWidget.onTapBottomBar(2);
          }),
      body: Container(
        padding: const EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: LayoutBuilder(
          builder: (context, boxSize) {
            return GetBuilder<ControllerOneCategory>(
                init: ControllerOneCategory(),
                builder: (controller) {
                  return controller.statusRequestOneCag == StatusRequest.empty
                      ? const Center(
                          child: Text('لاتوجد منتجات لعرضها'),
                        )
                      : HandlingDataView(
                          statusRequest: controller.statusRequestOneCag!,
                          widget: GetBuilder<ControllerOneCategory>(
                              builder: (controller) {
                            return ListView(
                              // physics: const NeverScrollableScrollPhysics(),
                              children: [
                                Container(
                                    width: boxSize.maxWidth,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Text(
                                                  controller.category!.title!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: Colors.black,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                  maxLines: 2,
                                                ),
                                                Text(
                                                  '- ${controller.oneCategory!.totalProducts} ${"204".tr}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                          color:
                                                              Colors.black45),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Expanded(
                                          child: Container(
                                              child: Text(
                                            sorts[controller.selectedSort] ??
                                                'الافتراضي',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          )),
                                        ),
                                        PopupMenuButton<String>(
                                          padding: const EdgeInsets.all(0),
                                          color: Colors.white,
                                          shadowColor: AppColors.primaryColor,
                                          icon: Icon(Icons.swap_vert,
                                              color: AppColors.textColor1,
                                              size: 27),
                                          onSelected: (String value) {
                                            controller.onSelctSort(value);

                                            // _controller.getOneCategory();
                                            //print('Selected sort: $selectedSort');
                                          },
                                          itemBuilder: (BuildContext context) {
                                            return sorts.entries.map((entry) {
                                              return PopupMenuItem<String>(
                                                value: entry.key,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Text(
                                                  entry.value,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              );
                                            }).toList();
                                          },
                                        ),
                                      ],
                                    )),

                                // Container(
                                //   width: boxSize.maxWidth,
                                //   height: 48,
                                //   padding:const  EdgeInsets.all(8),
                                //   margin:const EdgeInsets.all(8),
                                //   decoration: BoxDecoration(
                                //       color: Colors.white,
                                //     borderRadius: BorderRadius.circular(12)
                                //   ),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //     children: [
                                //       Container(
                                //         margin:const  EdgeInsets.symmetric(horizontal: 4),
                                //         child: Row(
                                //           children: [
                                //             Text('63'.tr,style: Theme.of(context).textTheme.headlineSmall,),
                                //           const   SizedBox(width: 7,),
                                //             SvgPicture.asset('images/sort.svg')
                                //           ],
                                //         ),
                                //       ),
                                //       Container(
                                //         width: 1,
                                //         height: 48,
                                //         color: Colors.black38,
                                //       ),
                                //       Container(
                                //         margin:const  EdgeInsets.symmetric(horizontal: 4),
                                //         child: Row(
                                //           children: [
                                //             Text('64'.tr,style: Theme.of(context).textTheme.headlineSmall,),
                                //             const   SizedBox(width: 7,),
                                //             Icon(Icons.swap_vert,color: AppColors.textColor1,size: 27,)
                                //           ],
                                //         ),
                                //       ),
                                //       // Container(
                                //       //   width: 1,
                                //       //   height: 48,
                                //       //   color: Colors.black38,
                                //       // ),
                                //       // Container(
                                //       //   margin:const  EdgeInsets.symmetric(horizontal: 4),
                                //       //   child: Row(
                                //       //     children: [
                                //       //       Text('65'.tr,style: Theme.of(context).textTheme.headlineSmall,),
                                //       //       const   SizedBox(width: 7),
                                //       //       Icon(Icons.arrow_drop_down,color: AppColors.textColor1,size: 27,)
                                //       //     ],
                                //       //   ),
                                //       // ),

                                //     ],
                                //   ),
                                // ),

                                SizedBox(
                                  height: boxSize.maxHeight * 0.02,
                                ),
                                //  Container(
                                //   child: Text(_controller.oneCategory!.description!,

                                // style: Theme.of(context).textTheme.bodyMedium,),
                                // ),
                                //  SizedBox(height: boxSize.maxHeight*0.02,),
                                SizedBox(
                                  height: boxSize.maxHeight * 0.90,
                                  child: Stack(
                                    children: [
                                      GridView.builder(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        controller: controller.scrollController,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 20,
                                          crossAxisSpacing: 20,
                                          childAspectRatio: 183 / 286,
                                        ),
                                        itemCount: controller
                                            .oneCategory!.products!.length,
                                        itemBuilder: (context, i) {
                                          return ViewProductsOnCatg(
                                            products: controller
                                                .oneCategory!.products![i],
                                          );
                                        },
                                      ),
                                      if (controller.statusRequestgetMoreCatg ==
                                          StatusRequest.loading)
                                        Positioned(
                                          bottom:
                                              10, // زيادة المسافة بين المؤشر والمنتج الأخير
                                          left: 0,
                                          right: 0,
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top: 20,
                                                      bottom:
                                                          20), // المسافة العلوية
                                                  child:
                                                      CircularProgressIndicator(
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                ),
                                              ),
                                              // Text('جاري التحميل '),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                          onRefresh: () {
                            // _controller.getOneCategory(idCategory: idCategory);
                          },
                        );
                });
          },
        ),
      ),
    );
  }
}

class ViewProductsOnCatg extends StatelessWidget {
  final Products products;
  const ViewProductsOnCatg({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(NamePages.pOneProduct, arguments: products);
        print('sssssssssss');
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: LayoutBuilder(builder: (context, boxSize) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Stack(
              //   alignment: Alignment.topRight,

              //   children: [

              Container(
                height: boxSize.maxHeight * 0.55,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                ),
                child: CachedNetworkImageWidget(
                  height: boxSize.maxHeight * 0.55,
                  fit: BoxFit.cover,
                  imageUrl: products.thumb ?? '',
                ),
              ),
              // Container(
              //   width: 60,
              //   child: DiscountWidgetOnContainer(discount:products.percent)),
              //   ],
              // ),
              SizedBox(
                height: boxSize.maxHeight * 0.45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        translate(
                          products.name ?? '',
                          products.name ?? '',
                        )!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.textColor1),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    StarRatingWidget(
                      rating: products.rating!.toDouble(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text(
                              formatPrice(products.price),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.primaryColor,
                                    fontSize: 12,
                                  ),
                            ),
                            const SizedBox(width: 4),
                            Image.asset("images/riyalsymbol_compressed.png",
                                height: 12),
                          ],
                        ),
                        if (products.special != null && products.special != 0)
                          Row(
                            children: [
                              Text(
                                formatPrice(products.special),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.black45,
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                      decorationThickness: 1.5,
                                      decorationColor: Colors.black,
                                    ),
                              ),
                              const SizedBox(width: 4),
                              Image.asset("images/riyalsymbol_compressed.png",
                                  height: 12),
                            ],
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: CartIcon(idProduct: products.productId!),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(NamePages.pOneProduct,
                                  arguments: products);
                            },
                            child:
                                Stack(alignment: Alignment.center, children: [
                              Opacity(
                                opacity: 0.10,
                                child: CircleAvatar(
                                    radius: boxSize.maxHeight * 0.06,
                                    backgroundColor: AppColors.pinkColor
                                    //AppColors.backgroundO,
                                    ),
                              ),
                              const Icon(
                                Icons.visibility,
                                color: Colors.black45,
                              )
                            ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: FavoriteIcon(
                            idProduct: products.productId!,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}

String formatPrice(dynamic price) {
  // تحويل السعر إلى double
  double formattedPrice = price is int ? price.toDouble() : price;

  // تحويل السعر إلى نص وحذف الأصفار الزائدة
  String priceString = formattedPrice.toString();

  // التحقق إذا كان السعر يحتوي على كسور
  if (priceString.contains('.')) {
    // تقسيم الرقم إلى الأرقام قبل وبعد العلامة العشرية
    List<String> parts = priceString.split('.');

    // إذا كان الجزء بعد العلامة العشرية يحتوي على أكثر من رقمين، قم بقصه
    if (parts[1].length > 2) {
      // أخذ أول رقمين بعد العلامة العشرية
      parts[1] = parts[1].substring(0, 2);
    }

    // إعادة تجميع الرقم بعد إزالة الكسور الزائدة
    return '${parts[0]}.${parts[1]}';
  }

  // إذا لم يحتوي السعر على كسور، يتم إرجاعه كـ double برقمين عشريين
  return formattedPrice.toStringAsFixed(2);
}
