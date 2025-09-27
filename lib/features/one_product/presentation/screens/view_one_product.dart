import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart'; // تأكد إنه فوق

import 'package:intl/intl.dart';
import 'package:nylon/controller/home/controller_home_widget.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/home/presentation/screens/widgets/products_container_home.dart';
import 'package:nylon/features/home/presentation/screens/widgets/widget_see_all.dart';
import 'package:nylon/features/one_product/presentation/controller/controller_one_product.dart';
import 'package:nylon/features/one_product/presentation/screens/widgets/bottom_bar_one_product.dart';
import 'package:nylon/features/one_product/presentation/screens/widgets/product_image_section.dart';
import 'package:nylon/view/home/widgets.dart';

import '../../../../core/languages/function_string.dart';

class ViewOneProduct extends StatefulWidget {
  const ViewOneProduct({super.key});

  @override
  State<ViewOneProduct> createState() => _ViewOneProductState();
}

class _ViewOneProductState extends State<ViewOneProduct> {
  final ControllerOneProduct _controller = Get.put(ControllerOneProduct());
  bool _showAllReviews = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerOneProduct>(builder: (controller) {
      return Scaffold(
        backgroundColor: AppColors.backgroundProduct,
        bottomNavigationBar: SafeArea(
            child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: const BottomNavigationBarOneProduct(),
        )),
        // الحل الأول: تعديل السطر المسبب للمشكلة في appBar
        appBar: customAppBar(
            label: translate(controller.products?.name ?? "Loading...",
                    controller.products?.name ?? "Loading...") ??
                (controller.products?.name ?? "Product"),
            isBack: true,
            onTap: () {
              ControllerHomeWidget controllerHomeWidget = Get.find();
              Get.offNamed(NamePages.pBottomBar);
              controllerHomeWidget.onTapBottomBar(2);
            }),
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            width: MediaQuery.of(context).size.width * 0.93,
            height: MediaQuery.of(context).size.height,
            child: LayoutBuilder(
              builder: (context, boxSize) {
                return GetBuilder<ControllerOneProduct>(builder: (controller) {
                  return HandlingDataView(
                    statusRequest: controller.statusRequestGetOP!,
                    widget: GetBuilder<ControllerOneProduct>(
                      builder: (controller) {
                        return ListView(
                          children: [
                            SizedBox(height: boxSize.maxHeight * 0.03),
                            ProductImageSectionWidget(
                              images: controller.productModel!.getAllImages(),
                              idProduct: controller
                                  .productModel!.product!.first.productId!,
                            ),
                            //ProductImageSectionWidget(image: _controller.products!.image??'',),
                            SizedBox(height: boxSize.maxHeight * 0.02),
                            _buildProductDetails(context),
                            SizedBox(height: boxSize.maxHeight * 0.01),
                            _buildProductDescription(context, boxSize),
                            SizedBox(height: boxSize.maxHeight * 0.04),
                            _buildProductRatings(context, boxSize),
                            SizedBox(height: boxSize.maxHeight * 0.01),
                            ..._buildUserReviews(_showAllReviews, context),
                            if (!_showAllReviews)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showAllReviews = true;
                                  });
                                },
                                child: Text(
                                  '190'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppColors.primaryColor,
                                      ),
                                ),
                              ),
                            if (controller.productModel!.productRelated !=
                                    null &&
                                controller.productModel!.productRelated!
                                    .isNotEmpty) ...{
                              SizedBox(height: boxSize.maxHeight * 0.03),
                              SeeAll(
                                  onTap: () {},
                                  titleAr: 'منتجات ذات صلة',
                                  titleEn: 'Related Products'),
                              GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 0.72,
                                ),
                                itemCount: controller
                                        .productModel!.productRelated?.length ??
                                    0,
                                itemBuilder: (context, i) {
                                  return ProductsContainerHome(
                                    products: controller
                                        .productModel!.productRelated![i],
                                    onTap: () async {
                                      controller.products = controller
                                          .productModel!.productRelated![i];
                                      controller.update();
                                      controller.getOneProduct(controller
                                          .productModel!
                                          .productRelated![i]
                                          .productId);
                                    },
                                    onTapFavorite: () {},
                                    onTapCart: () {},
                                  );
                                },
                              ),
                            },
                          ],
                        );
                      },
                    ),
                    onRefresh: () {
                      // _controller.getOneProduct();
                    },
                  );
                });
              },
            ),
          ),
        ),
      );
    });
  }

// تحديث دالة _buildProductDetails مع فحص null
  Widget _buildProductDetails(BuildContext context) {
    // فحص إذا كانت البيانات متاحة
    if (_controller.productModel?.product == null ||
        _controller.productModel!.product!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                translate(
                      _controller.productModel!.product!.first.name ??
                          "Product Name",
                      _controller.productModel!.product!.first.name ??
                          "Product Name",
                    ) ??
                    "Product Name",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textColor1, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (_controller.productModel!.discounts != null &&
                  _controller.productModel!.discounts!.isNotEmpty) ...{
                const SizedBox(height: 6),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xffff6f61),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "198".tr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).scaffoldBackgroundColor),
                    )),
              }
            ],
          ),
        ),
        const SizedBox(width: 5),
        GetBuilder<ControllerOneProduct>(
          builder: (controller) {
            if (controller.productModel?.product == null ||
                controller.productModel!.product!.isEmpty) {
              return const SizedBox.shrink();
            }

            final product = controller.productModel!.product!.first;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // السعر قبل الخصم
                if (product.special != null &&
                    product.special != 0 &&
                    product.price != 0)
                  Row(
                    children: [
                      Text(
                        product.special!.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black45,
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              decorationStyle: TextDecorationStyle.double,
                              decorationThickness:
                                  Get.locale?.languageCode == "ar" ? 7.0 : 0.5,
                              decorationColor: Colors.black,
                            ),
                      ),
                      const SizedBox(width: 4),
                      Image.asset("images/riyalsymbol_compressed.png",
                          height: 14),
                    ],
                  ),

                // السعر النهائي
                Row(
                  children: [
                    Text(
                      controller.productModel!
                          .calculatePriceWithDiscount(controller.count ?? 1)
                          .toStringAsFixed(2),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primaryColor,
                            fontSize: 14,
                          ),
                    ),
                    const SizedBox(width: 4),
                    Image.asset("images/riyalsymbol_compressed.png",
                        height: 14),
                  ],
                ),

                // وسم الخصم
                if (product.percent != null && product.percent != "100%-")
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 238, 155, 148),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      product.percent!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Get.theme.scaffoldBackgroundColor,
                            fontSize: 12,
                            height: 1.5,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            );
          },
        )
      ],
    );
  }

// تحديث _buildProductDescription مع فحص null
  Widget _buildProductDescription(
      BuildContext context, BoxConstraints boxSize) {
    final rawHtml = _controller.productModel?.product?.first.description ?? '';

    if (rawHtml.isEmpty) {
      return const SizedBox.shrink();
    }

    final normalized = rawHtml
        .replaceAll('&nbsp;', '<br/>')
        .replaceAllMapped(RegExp(r'\.\s*'), (m) => '.<br/>');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '61'.tr,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.primaryColor,
              ),
        ),
        SizedBox(height: boxSize.maxHeight * 0.01),
        Container(
          width: boxSize.maxWidth * 0.25,
          height: 1,
          color: AppColors.primaryColor,
        ),
        SizedBox(height: boxSize.maxHeight * 0.01),
        Html(
          data: translate(normalized, normalized) ?? normalized,
          style: {
            "body": Style(
              fontSize: FontSize(13),
              lineHeight: LineHeight.number(1.8),
              color: AppColors.textColor1,
            ),
            "li": Style(margin: Margins.only(bottom: 6)),
          },
        ),
        if (_controller.productModel?.discounts != null &&
            _controller.productModel!.discounts!.isNotEmpty)
          Center(
            child: Container(
              margin: const EdgeInsets.all(8),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${"200".tr} ${_controller.productModel!.discounts!.first.quantity ?? ""} '
                '${"199".tr} ${_controller.productModel!.discounts!.first.price ?? ""} ',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).scaffoldBackgroundColor),
              ),
            ),
          ),
      ],
    );
  }
}

String formatDescription(String description) {
  List<String> lines = description.split('.');

  return lines
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .join('.\n');
}

// قسم التقييم بالنجمات
Widget _buildRatingStars(double rating, int reviewsCount) {
  List<Widget> stars = [];

  // إضافة النجوم المملوءة (حسب التقييم)
  for (int i = 0; i < rating.floor(); i++) {
    stars.add(const Icon(Icons.star, color: Colors.amber, size: 16));
  }

  // إضافة النجوم الفارغة (في حالة التقييم الجزئي)
  if (rating != rating.floor()) {
    stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 16));
  }

  // إضافة النجوم الفارغة المتبقية لتعبئة الـ 5 نجوم
  for (int i = stars.length; i < 5; i++) {
    stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 16));
  }

  return Row(
    children: [
      ...stars,
      const SizedBox(width: 8),
      Text(
        '$rating ($reviewsCount ${'191'.tr})', // مع عدد التقييمات
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    ],
  );
}

Widget _buildProductRatings(BuildContext context, BoxConstraints boxSize) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // عنوان التقييمات
      Row(
        children: [
          Text(
            '191'.tr,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primaryColor,
                  fontSize: 14, // يمكنك تعديل الحجم حسب الحاجة
                  fontWeight: FontWeight.bold, // لجعل العنوان بارزًا
                ),
          ),
          const Spacer(),
          _buildRatingStars(4, 18),
        ],
      ),
      SizedBox(height: boxSize.maxHeight * 0.01),

      // خط أفقي تحت العنوان
      Container(
        width: boxSize.maxWidth * 0.25,
        height: 1,
        color: AppColors.primaryColor,
      ),
      SizedBox(height: boxSize.maxHeight * 0.01),
    ],
  );
}

List<Map<String, dynamic>> reviews = [
  {
    'username': 'Ahmed',
    'comment': 'تقييم ممتاز جداً. أنصح به بشدة.',
    'rating': 5,
    'date': DateTime.now().toString()
  },
  {
    'username': 'Ali',
    'comment': 'خدمة رائعة وسريعة، أتمنى لو كانت الأسعار أفضل.',
    'rating': 4,
    'date': DateTime.now().subtract(const Duration(days: 2)).toString()
  },
  {
    'username': 'Sara',
    'comment': 'منتج رائع ولكن يحتاج إلى بعض التحسينات.',
    'rating': 3,
    'date': DateTime.now().subtract(const Duration(days: 3)).toString()
  },
  {
    'username': 'Mohamed',
    'comment': 'جيد جداً، السعر مناسب والجودة أيضاً جيدة.',
    'rating': 4,
    'date': DateTime.now().subtract(const Duration(days: 4)).toString()
  },
  {
    'username': 'Mona',
    'comment': 'منتج ممتاز! أحببت هذا المنتج وسأشتريه مرة أخرى.',
    'rating': 5,
    'date': DateTime.now().subtract(const Duration(days: 5)).toString()
  },
  {
    'username': 'Youssef',
    'comment': 'الجودة عالية والسعر ممتاز.',
    'rating': 5,
    'date': DateTime.now().subtract(const Duration(days: 6)).toString()
  },
  {
    'username': 'Laila',
    'comment': 'تجربة ممتازة، سأوصي بها للأصدقاء.',
    'rating': 4,
    'date': DateTime.now().subtract(const Duration(days: 7)).toString()
  },
];
List<Widget> _buildUserReviews(bool showAllReviews, BuildContext context) {
  // إذا كانت _showAllReviews هي true، سنعرض جميع التقييمات
  final reviewsToDisplay = showAllReviews ? reviews : reviews.take(4).toList();

  return reviewsToDisplay.map((review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // عرض صورة المستخدم
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.blue,
            child: Text(review['username']![0],
                style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم المستخدم
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review['username']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        // تنسيق التاريخ مع الأيقونة
                        Text(
                          formatDate(review['date']!),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.access_time, // أيقونة الوقت
                          color: Colors.grey,
                          size: 14,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // عرض النجوم
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < review['rating'] ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                      size: 16,
                    );
                  }),
                ),
                const SizedBox(height: 4),
                // تعليق المستخدم
                Text(
                  review['comment']!,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }).toList();
}

// تنسيق التاريخ باستخدام intl
String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  return DateFormat('yyyy-MM-dd HH:mm')
      .format(dateTime); // تنسيق التاريخ والوقت
}
