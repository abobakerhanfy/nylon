import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/features/home/data/models/category_menu.dart';
import 'package:nylon/features/home/data/models/mobile_slider.dart';
import 'package:nylon/features/home/data/models/products_featured.dart';
import 'package:nylon/features/home/presentation/controller/home_controller.dart';
import 'package:nylon/features/home/presentation/screens/widgets/categories_on_home.dart';
import 'package:nylon/features/home/presentation/screens/widgets/grid_view_banner_home.dart';
import 'package:nylon/features/home/presentation/screens/widgets/image_home.dart';
import 'package:nylon/features/home/presentation/screens/widgets/products_list_on_home.dart';
import 'package:nylon/features/home/presentation/screens/widgets/slider_offers.dart';

import '../../data/models/mobile_featured.dart';

class HomeViewAllWidget extends StatefulWidget {
  const HomeViewAllWidget({super.key});

  @override
  _HomeViewAllWidgetState createState() => _HomeViewAllWidgetState();
}

class _HomeViewAllWidgetState extends State<HomeViewAllWidget> {
  List<Map<String, dynamic>> allItems = [];
  final MyServices _myServices = Get.find();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final ControllerHome controller = Get.find();
    if (controller.dataHome != null) {
      setState(() {
        if (controller.dataHome!.multiBanner != null) {
          allItems.addAll(controller.dataHome!.multiBanner!
              .map((e) => {'type': 'multi_banner', 'data': e}));
        }
        if (controller.dataHome!.productsFeatured != null) {
          allItems.addAll(controller.dataHome!.productsFeatured!
              .map((e) => {'type': 'products_featured', 'data': e}));
        }
        if (controller.dataHome!.bigBanner != null) {
          allItems.addAll(controller.dataHome!.bigBanner!
              .map((e) => {'type': 'big_banner', 'data': e}));
        }
        if (controller.dataHome!.mobileFeatured != null) {
          allItems.addAll(controller.dataHome!.mobileFeatured!
              .map((e) => {'type': 'mobile_featured', 'data': e}));
        }
        if (controller.dataHome!.categoryMenu != null) {
          allItems.addAll(controller.dataHome!.categoryMenu!
              .map((e) => {'type': 'category_menu', 'data': e}));
        }
        if (controller.dataHome!.mobileSlider != null) {
          allItems.addAll(controller.dataHome!.mobileSlider!
              .map((e) => {'type': 'mobile_slider', 'data': e}));
        }

        allItems.sort((a, b) {
          int sortOrderA = (a['data'] as dynamic).getSortOrder();
          int sortOrderB = (b['data'] as dynamic).getSortOrder();
          return sortOrderA.compareTo(sortOrderB);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListView.separated(
        padding: const EdgeInsets.all(6),
        separatorBuilder: (context, i) => const SizedBox(
          height: 16,
        ),
        itemCount: allItems.length,
        itemBuilder: (context, index) {
          final item = allItems[index];
          return buildItem(item);
        },
      ),
    );
  }

  Widget buildItem(Map<String, dynamic> item) {
    switch (item['type']) {
      case 'multi_banner':
        final multiBanner = item['data'];
        return GridViewBannerHome(banner: multiBanner);
      case 'products_featured':
        ProductsFeatured products = item['data'];
        return ProductsListOnHome(
          products: _myServices.sharedPreferences.getString('Lang') == 'ar'
              ? products.productsAr!
              : products.productsEn!,
          nameAr: products.nameAr,
          nameEn: products.nameEn,
        );
      case 'big_banner':
        final bigBanner = item['data'];
        return HomeBigBanner(
          imageAr: bigBanner.imageAr,
          imageEn: bigBanner.imageEn,
          onTap: () {},
        );
      case 'mobile_featured':
        MobileFeatured products = item['data'];
        return ProductsListOnHome(
          products: products.products!,
          nameAr: products.nameAr,
          nameEn: products.nameEn,
        );
      case 'category_menu':
        CategoryMenu categoryMenu = item['data'];

        return CategoriesOnHome(
          products: _myServices.sharedPreferences.getString('Lang') == 'ar'
              ? categoryMenu.sliders!.sliderAr
              : categoryMenu.sliders!.sliderEn,
          nameEn: categoryMenu.nameEn,
          nameAr: categoryMenu.name,
        );

      case 'mobile_slider':
        final mobileSlider = item['data'];
        List<ImageData> imageSliders = mobileSlider.image ?? [];
        return SilderOffers(image: imageSliders);

      default:
        return Container();
    }
  }
}





























// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';

// import 'package:nylon/core/theme/colors_app.dart';
// import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
// import 'package:nylon/features/home/presentation/screens/widgets/categories_on_home.dart';
// import 'package:nylon/features/home/presentation/screens/widgets/products_container_home.dart';

// import '../../../../core/languages/function_string.dart';
// import '../../../../core/routes/name_pages.dart';
// import 'widgets/search_widget.dart';
// import 'widgets/slider_offers.dart';
// import 'widgets/widget_see_all.dart';
// import '../../../../view/fortune_wheel/fortune_wheel.dart';

// class ScreenHome extends StatelessWidget {
//   const ScreenHome({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset:false,
//       backgroundColor: AppColors.background,
//       appBar: customAppBarTow(title: '67'.tr),
//             body: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child:LayoutBuilder(
//           builder: (context,boxSize){
//             return ListView(
//               children: [
//                 SizedBox(height: boxSize.maxHeight*0.03,),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   child: Row(
//                     children: [
//                       const SizedBox(width: 10,),
//                       const Expanded(
//                         child: SearchWidget(),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         child: InkWell(
//                           onTap: () {
//                             showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return AlertDialog(
//                                   backgroundColor: Colors.white,
//                                   title: SizedBox(
//                                     width: MediaQuery.of(context).size.width,
//                                     child: const FortuneWheelPage(),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: SvgPicture.asset('images/Notification.svg'),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 ),
//                 SizedBox(height: boxSize.maxHeight*0.01,),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                      const  WidgetCategoriesOnHome(),
//                       SizedBox(height: boxSize.maxHeight*0.01,),
//                       SizedBox(
//                         width: double.infinity,
//                         height: boxSize.minHeight*0.50,
//                        child: Image.asset('images/test2.png',fit: BoxFit.cover,),
//                       ),
//                       SizedBox(height: boxSize.maxHeight*0.02,),
//                       SeeAll(onTap: (){
//                       },
//                           titleAr: 'اقوي العروض',
//                           titleEn: 'Best offers'),
//                       SizedBox(height: boxSize.maxHeight*0.02,),
//                      SilderOffers(),
//                       SizedBox(height: boxSize.maxHeight*0.02,),
//                       SeeAll(onTap: (){
//                       },
//                           titleAr: 'وصل حديثا',
//                           titleEn: 'Newly arrived'),

//                       SizedBox(height: boxSize.maxHeight*0.02,),
//                       SizedBox(
//                         height: 260,
//                         child: ListView.builder(
//                           physics: const BouncingScrollPhysics(),
//                           padding:const EdgeInsets.symmetric(horizontal: 8),
//                        //   physics: const NeverScrollableScrollPhysics(),
//                           scrollDirection: Axis.horizontal,

//                           itemCount: 4,
//                           itemBuilder: (context,i){
//                             return
//                               ProductsContainerHome(
//                                 image: 'images/test5.png',
//                                 labelAr: 'اطباق قصدير',
//                                 labelEn: 'Tin dishes',
//                                 descriptionAr:'صحن قصدير حلى (125حبة)' ,
//                                 descriptionEn: 'Tin dessert dish (125 pieces)',
//                                 price: 20.00,
//                                 onTap: (){
//                                   Get.toNamed(NamePages.pOneProduct);
//                                 },
//                                 onTapFavorite: (){},
//                                 onTapCart: (){}, );
//                           },
//                         ),
//                       ),
//                       SizedBox(height: boxSize.maxHeight*0.04,),
//                       // HomeImage(
//                       //     onTap: (){},
//                       //     image: 'images/test3.png',
//                       //     boxSize: boxSize),
//                       SizedBox(height: boxSize.maxHeight*0.02,),
//                       SeeAll(onTap: (){},
//                           titleAr:'اقوي عروض رمضان',
//                           titleEn: 'The best Ramadan offers'),

//                       SizedBox(height: boxSize.maxHeight*0.02,),
//                       SizedBox(
//                         height: 260,
//                         child: ListView.builder(
//                           physics: const BouncingScrollPhysics(),
//                           padding:const EdgeInsets.symmetric(horizontal: 8),
//                           // physics: const NeverScrollableScrollPhysics(),
//                           scrollDirection: Axis.horizontal,

//                           itemCount: 4,
//                           itemBuilder: (context,i){
//                             return   ProductsContainerHome(
//                               image: 'images/test5.png',
//                               labelAr: 'اطباق قصدير',
//                               labelEn: 'Tin dishes',
//                               descriptionAr:'صحن قصدير حلى (125حبة)' ,
//                               descriptionEn: 'Tin dessert dish (125 pieces)',
//                               price: 20.00,
//                               onTap: (){},
//                               onTapFavorite: (){},
//                               onTapCart: (){}, );
//                           },
//                         ),
//                       ),
//                       SizedBox(height: boxSize.maxHeight*0.04,),
//                       // HomeImage(
//                       //     onTap: (){},
//                       //     image: 'images/test2.png',
//                       //     boxSize: boxSize),
//                       SizedBox(height: boxSize.maxHeight*0.02,),
//                       SizedBox(
//                         height: 320*2,

//                         child: GridView.builder(
//                           padding:const EdgeInsets.symmetric(horizontal: 8),
//                           physics: const NeverScrollableScrollPhysics(),
//                           scrollDirection: Axis.vertical,
//                           gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               mainAxisSpacing: 15,
//                               crossAxisSpacing:15,//
//                               childAspectRatio:182/323.56
//                           ),
//                           itemCount: 4,
//                           itemBuilder: (context,i){
//                             return Container(
//                                 color: Colors.black38,
//                                 child: Image.asset('images/test4.png')
//                             );
//                           },
//                         ),
//                       ),

//                     ],
//                   ),
//                 )
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class WidgetCategoriesOnHome extends StatelessWidget {
//   const WidgetCategoriesOnHome({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height:MediaQuery.of(context).size.height*0.20,
//       alignment: Alignment.center,
//       child: ListView.separated(
//         physics: const BouncingScrollPhysics(),
//         scrollDirection: Axis.horizontal,
//           separatorBuilder: (context,i)=>SizedBox(width: MediaQuery.of(context).size.width*0.04,),
//           itemCount: 8,
//         itemBuilder:(context,i){
//             return
//               CategoriesContainer(
//                           onTap: (){
//                             Get.toNamed(NamePages.pOneCategory);
//                           },
//                           label: translate('القسم$i','item$i')!,
//                           image: 'images/coffeeImage.png',
//                          // boxSize: boxSize,
//                         );
    
//         },
//       ),
//     );
//   }
// }
