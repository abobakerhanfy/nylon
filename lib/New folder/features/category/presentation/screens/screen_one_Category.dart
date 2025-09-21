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
  String? categoryId;
  String? categoryTitle;
  // Store the selected sort value

// خريطة واحدة قيمها ديناميكية حسب اللغة الحالية
  final Map<String, String> sorts = {
    "p.sort_order-ASC": translate("الافتراضي", "Default")!,
    "pd.name-ASC": translate("الإسم من أ - ي", "Name (A → Z)")!,
    "pd.name-DESC": translate("الإسم من ي - أ", "Name (Z → A)")!,
    "p.price-ASC":
        translate("حسب السعر (منخفض > مرتفع)", "Price (Low → High)")!,
    "p.price-DESC":
        translate("حسب السعر (مرتفع > منخفض)", "Price (High → Low)")!,
    "rating-DESC": translate("الأعلى تقييمًا", "Rating (High → Low)")!,
    "rating-ASC": translate("الأقل تقييمًا", "Rating (Low → High)")!,
    "p.model-ASC": translate("النوع (أ - ي)", "Model (A → Z)")!,
    "p.model-DESC": translate("النوع (ي - أ)", "Model (Z → A)")!,
  };

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;

    if (args == null || args['category_id'] == null) {
      print("❌ Get.arguments or category_id is null");
      // تقدر تظهر رسالة أو ترجع للشاشة السابقة
      return;
    }

    categoryId = args['category_id'];
    categoryTitle = args['title'] ?? '';

    _controller.categoryTitle = categoryTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: GetBuilder<ControllerOneCategory>(
          builder: (c) {
            final safeTitle = (c.categoryTitle?.trim().isNotEmpty == true)
                ? c.categoryTitle!.trim()
                : (categoryTitle ?? ''); // fallback لو لسه مفيش عنوان

            return customAppBar(
              label: translate(safeTitle, safeTitle)!,
              isBack: true,
              onTap: () {
                ControllerHomeWidget controllerHomeWidget = Get.find();
                Get.offNamed(NamePages.pBottomBar);
                controllerHomeWidget.onTapBottomBar(2);
              },
            );
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: LayoutBuilder(
          builder: (context, boxSize) {
            return GetBuilder<ControllerOneCategory>(
                // 🚫 تم إزالة init: ControllerOneCategory() عشان ما ينشئ كونترولر جديد بدون باراميترز
                builder: (controller) {
              return controller.statusRequestOneCag == StatusRequest.empty
                  ? const Center(
                      child: Text('لاتوجد منتجات لعرضها'),
                    )
                  : HandlingDataView(
                      statusRequest: controller.statusRequestOneCag ??
                          StatusRequest.loading,
                      widget: GetBuilder<ControllerOneCategory>(
                          // سيبنا الـ GetBuilder التاني زي ما هو بس أضفنا حراسة null
                          builder: (controller) {
                        final totalProductsText =
                            controller.oneCategory?.totalProducts?.toString() ??
                                '0';
                        final productsList =
                            controller.oneCategory?.products ?? <Products>[];

                        return ListView(
                          // physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Container(
                              width: boxSize.maxWidth,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // اليسار: العنوان + العدّاد
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            controller.categoryTitle ?? '',
                                            maxLines: 1,
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Colors.black,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '- ${controller.oneCategory?.totalProducts ?? '0'} ${"204".tr}',
                                          maxLines: 1,
                                          softWrap: false,
                                          overflow: TextOverflow.fade,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(color: Colors.black45),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // بدل Spacer بـ مسافة بسيطة
                                  const SizedBox(width: 8),

                                  // اليمين: نص الفرز + زر القائمة
                                  Flexible(
                                    child: Text(
                                      sorts[controller.selectedSort] ??
                                          'الافتراضي',
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    padding: EdgeInsets.zero,
                                    color: Colors.white,
                                    shadowColor: AppColors.primaryColor,
                                    icon: Icon(Icons.swap_vert,
                                        color: AppColors.textColor1, size: 27),
                                    onSelected: (value) =>
                                        controller.onSelctSort(value),
                                    itemBuilder: (context) =>
                                        sorts.entries.map((entry) {
                                      return PopupMenuItem<String>(
                                        value: entry.key,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text(entry.value,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),

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
                                    padding: const EdgeInsets.only(bottom: 20),
                                    controller: controller.scrollController,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20,
                                      childAspectRatio: 183 / 286,
                                    ),
                                    // ✅ آمنة ضد الـ null
                                    itemCount: productsList.length,
                                    itemBuilder: (context, i) {
                                      return ViewProductsOnCatg(
                                        products: productsList[i],
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
                                              padding: const EdgeInsets.only(
                                                  top: 20,
                                                  bottom:
                                                      20), // المسافة العلوية
                                              child: CircularProgressIndicator(
                                                color: AppColors.primaryColor,
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
                        _controller.getOneCategory(id: categoryId!);
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

  double _safeRating(dynamic r) {
    if (r == null) return 0.0;
    if (r is num) return r.toDouble();
    // أحيانًا الAPI بيرجع false في بعض اللغات — نخليه 0
    if (r is bool) return 0.0;
    // لو String وجي رقم
    final parsed = double.tryParse(r.toString());
    return parsed ?? 0.0;
  }

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
                    // ✅ تقييم آمن ضد null وأنواع مختلفة
                    StarRatingWidget(
                      rating: _safeRating(products.rating),
                    ),
                    // === PRICE BLOCK START (REPLACE THIS WHOLE Builder) ===
                    Builder(
                      builder: (context) {
                        // 👈 حجم الخط الأساسي
                        final baseFont =
                            Theme.of(context).textTheme.bodySmall?.fontSize ??
                                12;

                        final double? p =
                            parsePrice(products.price); // ممكن تكون 0 أو null
                        final double? s = parsePrice(
                            products.special); // أحيانًا بتيجي كنص فيه HTML

                        // نعتبر القيمة صالحة فقط لو > 0
                        final double? pv = (p != null && p > 0) ? p : null;
                        final double? sv = (s != null && s > 0) ? s : null;

                        // ويدجت لعرض السعر + أيقونة SAR
                        Widget priceChip(
                          double val, {
                          required Color color,
                          bool strike = false,
                          double? fontSize, // 👈 نقدر نمرر حجم خط مختلف
                        }) {
                          return Row(
                            children: [
                              Text(
                                formatPrice(val),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: color,
                                      fontSize: fontSize ?? baseFont,
                                      decoration: strike
                                          ? TextDecoration.lineThrough
                                          : null,
                                      decorationStyle: strike
                                          ? TextDecorationStyle.solid
                                          : null,
                                      decorationThickness: strike ? 1.5 : null,
                                    ),
                              ),
                              const SizedBox(width: 4),
                              Image.asset("images/riyalsymbol_compressed.png",
                                  height: 12),
                            ],
                          );
                        }

                        // لا توجد أسعار صالحة
                        if (pv == null && sv == null) {
                          return const SizedBox.shrink();
                        }

                        // حالة يوجد سعر واحد فقط -> هو السعر الحالي
                        if (pv != null && sv == null) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              priceChip(pv,
                                  color: AppColors.primaryColor,
                                  fontSize: baseFont)
                            ],
                          );
                        }
                        if (sv != null && pv == null) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              priceChip(sv,
                                  color: AppColors.primaryColor,
                                  fontSize: baseFont)
                            ],
                          );
                        }

                        // حالة يوجد سعرين: الأقل هو الحالي (لون البراند)، الأعلى قديم ومشطوب وأكبر شوية
                        final double low = (pv! < sv!) ? pv : sv;
                        final double high = (pv > sv) ? pv : sv;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            priceChip(low,
                                color: AppColors.primaryColor,
                                fontSize: baseFont), // الحالي
                            priceChip(high,
                                color: Colors.black45,
                                strike: true,
                                fontSize:
                                    baseFont + 2), // الكبير (مشطوب) أكبر شوية
                          ],
                        );
                      },
                    ),
// === PRICE BLOCK END ===

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

/// تحوّل أي قيمة سعر (num/bool/String مع HTML) إلى رقم.
/// ترجع null لو مفيش رقم صالح.
double? parsePrice(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is bool) return null; // أحيانًا بتيجي false
  if (v is String) {
    // نشيل الفواصل ونستخرج أول رقم (يدعم "12.34" داخل HTML)
    final cleaned = v.replaceAll(',', '');
    final m = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(cleaned);
    if (m != null) return double.tryParse(m.group(1)!);
  }
  return null;
}

/// تهيئة الرقم لنص مناسب (حد أقصى خانتين عشريتين، مع قص الأصفار الزيادة).
String formatPrice(dynamic price) {
  double? numeric = parsePrice(price);
  numeric ??= 0.0;

  String s = numeric.toString();
  if (s.contains('.')) {
    final parts = s.split('.');
    final frac = (parts[1].length > 2) ? parts[1].substring(0, 2) : parts[1];
    final trimmedFrac = frac.replaceFirst(RegExp(r'0+$'), '');
    return trimmedFrac.isEmpty ? parts[0] : '${parts[0]}.$trimmedFrac';
  }
  return numeric.toStringAsFixed(2);
}
