import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          child: BottomNavigationBarOneProduct(),
        )),
        appBar: customAppBar(
            label: translate(
                controller.products!.name, controller.products!.name)!,
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
                            ..._buildUserReviews(_showAllReviews),
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

  Widget _buildProductDetails(BuildContext context) {
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
                  _controller.productModel!.product!.first.name,
                  _controller.productModel!.product!.first.name,
                )!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textColor1, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (_controller.productModel!.discounts != null &&
                  _controller.productModel!.discounts!.isNotEmpty) ...{
                const SizedBox(
                  height: 6,
                ),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xffff6f61),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "198".tr,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    )),
              }
            ],
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        GetBuilder<ControllerOneProduct>(
          builder: (controller) {
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

                // السعر النهائي بعد الخصم أو الأساسي
                Row(
                  children: [
                    Text(
                      controller.productModel!
                          .calculatePriceWithDiscount(controller.count)
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
                            color: Colors.white,
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

  Widget _buildProductDescription(
      BuildContext context, BoxConstraints boxSize) {
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
        Text(
          translate(
              formatDescription(
                  _controller.productModel!.product!.first.description ?? ''),
              formatDescription(
                  _controller.productModel!.product!.first.description ?? ''))!,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textColor1,
                fontSize: 13,
                height: 2,
              ),
        ),
        if (_controller.productModel!.discounts != null &&
            _controller.productModel!.discounts!.isNotEmpty)
          Center(
            child: Container(
              margin: const EdgeInsets.all(8),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryColor, // Colors.blue[700],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${"200".tr} ${_controller.productModel!.discounts!.first.quantity} ${"199".tr} ${_controller.productModel!.discounts!.first.price!} ',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white),
              ),
            ),
          )
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
List<Widget> _buildUserReviews(bool showAllReviews) {
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
                style: const TextStyle(color: Colors.white)),
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



// class ViewOneProduct extends StatelessWidget {
//   ViewOneProduct({super.key});
//   final MyServices _myServices = Get.find();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundProduct,
//       bottomNavigationBar: Container(
//         padding:const  EdgeInsets.symmetric(horizontal:25,vertical: 6),
//         height: MediaQuery.of(context).size.height*0.15,
//         color: Colors.white,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,

//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Text(' ${'45'.tr}  20.00  ${'11'.tr} ',style:Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: AppColors.textColor1,fontSize: 11
//                   ),),
//                 ),

//              Row(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: [
//                  Container(
//                    width: 29,
//                    height: 29,
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(100),
//                      color: AppColors.primaryColor
//                    ),
//                    child: const Icon(Icons.add,color: Colors.white,),
//                  ),
//                  const Padding(
//                    padding: EdgeInsets.symmetric(horizontal: 10),
//                    child: Text('02',style: TextStyle(fontSize: 16,color: Colors.black),),
//                  ),
//                  Container(alignment: Alignment.center,
//                    width: 29,
//                    height: 29,
//                    decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(100),
//                        color: AppColors.grayO
//                    ),
//                    child: const Text('-',style: TextStyle(fontSize: 20,color: Colors.black38),),
//                  )
//                ],
//              )
//               ],
//             ),
//             Row(
//               children: [
//                 Expanded(child: InkWell(
//                   onTap:(){
//                     print('ddd');
//              //  Get.toNamed(NamePages.pSignIn);
//                   },
//                   child: Container(
//                     alignment: Alignment.center,

//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: AppColors.primaryColor,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset('images/cart.svg',color: Colors.white,),
//                        const  SizedBox(width: 8,),
//                         Text('62'.tr,style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: Colors.white,fontWeight: FontWeight.normal
//                         ),),
//                       ],
//                     ),
//                   ),
//                 )),
//               ],
//             ),

//           ],
//         ),
//       ),
//       appBar: customAppBar(label: translate('صحن قصدير حلى (125حبة)','Tin dessert dish (125 pieces)')!, isBack: true),
//       body: Center(
//         child: Container(
// padding: const EdgeInsets.symmetric(horizontal: 5),
//           width: MediaQuery.of(context).size.width*0.90,
//           height: MediaQuery.of(context).size.height,
//           child: LayoutBuilder(
//             builder: (context,boxSize){
//               return ListView(
//                 children: [
//                   SizedBox(height: boxSize.maxHeight*0.03),
//                   Center(
//                     child: Stack(
//                       alignment: _myServices.sharedPreferences.getString('Lang')=='ar'? Alignment.bottomLeft:Alignment.bottomRight,
//                       children: [
//                         Stack(
//                           alignment:_myServices.sharedPreferences.getString('Lang')=='ar'? Alignment.topLeft:Alignment.topRight,
//                           children: [
//                             Container(
//                               height:364,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: AppColors.borderBlack28,width: 0.5),
//                               ),
//                               child: Image.asset('images/test5.png',fit:BoxFit.fill ,),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
//                               child: Column(
//                                 children: [
//                                   InkWell(
//                                     onTap: (){},
//                                     child: Stack(
//                                         alignment: Alignment.center,
//                                         children: [
//                                         CircleAvatar(
//                                                 backgroundColor: Colors.grey[200]
//                                               //AppColors.backgroundO,
//                                             ),

//                                           SvgPicture.asset('images/fov.svg',color:Colors.black38),

//                                         ]
//                                     ),
//                                   ),
//                                   SizedBox(height: boxSize.maxHeight*0.02,),
//                                   InkWell(
//                                     onTap: (){},
//                                     child: Stack(
//                                         alignment: Alignment.center,
//                                         children: [
//                                           CircleAvatar(
//                                               backgroundColor: Colors.grey[200]
//                                             //AppColors.backgroundO,
//                                           ),

//                                         const Icon(Icons.share_outlined,color: Colors.black38,)

//                                         ]
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             )

//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: AnimatedSmoothIndicator(
//                               effect:  ExpandingDotsEffect(
//                                   dotWidth: 10,
//                                   dotHeight: 10,
//                                   spacing: 8,
//                                   radius: 15,
//                                   activeDotColor: AppColors.primaryColor,
//                                   dotColor: Colors.black38,
//                               ),
//                               curve:Curves.easeInOut,
//                               activeIndex: 3,
//                               count: 4
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: boxSize.maxHeight*0.02,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Text(translate('صحن قصدير حلى (125حبة)','Tin dessert dish (125 pieces)')!,style:Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: AppColors.textColor1,
//                         ),overflow: TextOverflow.ellipsis,),
//                       ),

//                       Text('20.00 ${'11'.tr}',style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                         color: AppColors.primaryColor,
//                       ),),
//                     ],
//                   ),
//                   SizedBox(height: boxSize.maxHeight*0.02,),

//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('61'.tr,style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: AppColors.primaryColor,
//                   ),),
//                   SizedBox(height: boxSize.maxHeight*0.01,),
//                   Container(
//                     width: boxSize.maxWidth*0.25,
//                     height: 1,
//                     color: AppColors.primaryColor,
//                   ),
//                   SizedBox(height: boxSize.maxHeight*0.01,),
//                   Text( translate(" هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق"" إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد،",
//               '"This text is an example of text that can be replaced in the same space. This text was generated from the Arabic text generator, where you can generate such text or many other texts in addition to increasing the number of letters that the application generates.""If you need a larger number of paragraphs, the Arabic text generator allows you to increase the number of paragraphs as you want,"')!
//                   ,style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: AppColors.textColor1,fontSize: 11
//                     ),)
//                 ],

//               )
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
///////////////////////////////////////////////////