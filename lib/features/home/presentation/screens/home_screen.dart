import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/routes/name_pages.dart';

import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/features/home/data/models/search_model.dart';
import 'package:nylon/features/home/presentation/controller/home_controller.dart';
import 'package:nylon/features/home/presentation/screens/view_all_widget_home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      appBar: customAppBarTow(title: '67'.tr, actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: InkWell(
              onTap: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              child: SvgPicture.asset('images/search.svg')),
        ),
      ]),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GetBuilder<ControllerHome>(builder: (controller) {
            return HandlingDataView(
                statusRequest: controller.statusRequest!,
                widget: GetBuilder<ControllerHome>(
                  builder: (controller) {
                    return HomeViewAllWidget();
                  },
                ),
                onRefresh: () {
                  controller.getData();
                });
          });
        },
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => '12'.tr;
  @override
  TextStyle? get searchFieldStyle =>
      Theme.of(Get.context!).textTheme.bodyMedium;

  // تغيير الميثود الخاصة بالبحث لتكون بطيئة فقط عند الضغط على "بحث"
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // مسح النص المدخل
          showSuggestions(context); // إظهار الاقتراحات عند المسح
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // إغلاق البحث
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Products>>(
      future: query.isNotEmpty ? searchPosts(query) : Future.value([]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error '));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found'));
        } else {
          List<Products> results = snapshot.data!;
          return ProductSearchResults(products: results);
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(child: Text('ابحث باستخدام كلمات رئيسية')),
    );
  }

  Future<List<Products>> searchPosts(String query) async {
    final response = await http.post(
      Uri.parse(
          'https://khaled.nylonsa.com/index.php?route=api/product/search'),
      body: {'search': query},
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['products'] != null) {
        SearchModel searchModel = SearchModel.fromJson(jsonResponse);

        // إرجاع قائمة المنتجات فقط من الموديل
        return searchModel.products?.products ?? [];
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load products');
    }
  }
}

class ProductSearchResults extends StatelessWidget {
  final List<Products> products;

  const ProductSearchResults({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index]; // استخدام الكائن من النوع Products
          return Card(
            elevation: 5,
            color: Colors.white,
            margin: const EdgeInsets.all(10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: Image.network(product.thumb ?? ""), // عرض الصورة
              title: Text(product.nameP ?? "",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        (product.price is int
                            ? (product.price as int)
                                .toDouble()
                                .toStringAsFixed(2)
                            : product.priceP is double
                                ? (product.priceP as double).toStringAsFixed(2)
                                : double.parse(product.priceP)
                                    .toStringAsFixed(2)),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primaryColor,
                            ),
                      ),
                      const SizedBox(width: 4),
                      Image.asset("images/riyalsymbol_compressed.png",
                          height: 16),
                      const SizedBox(width: 4),
                      Text('11'.tr), // أو كلمة "ريال" حسب ترجمتك
                    ],
                  ),
                  if (product.specialP ?? false)
                    const Text('عرض خاص',
                        style: TextStyle(fontSize: 14, color: Colors.red)),
                ],
              ),

              onTap: () {
                Get.toNamed(NamePages.pOneProduct, arguments: product);
                // افتح الرابط عندما ينقر المستخدم
              },
            ),
          );
        },
      ),
    );
  }
}



  // void launchURL(String url) {
  //   // استخدم حزمة مثل url_launcher لفتح الرابط
  //   // يمكن إضافتها عبر pubspec.yaml
  //   // import 'package:url_launcher/url_launcher.dart';
  //   launch(url);
  // }



/*
ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _spacerSizedBox(),
                 const SearchAndNotification(),
                  const SizedBox(height: 8),
                  
                 CategoriesOnHome(sliders: _controller.dataHome!.categoryMenu!.sliders!),
                  const SizedBox(height: 8),
              InkWell(
  onTap: () {},
  child: Container(
    height: constraints.maxHeight * 0.40, 
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(_controller.dataHome!.bigBanner!.imageEn!),
        fit: BoxFit.cover, 
      ),
    ),
  ),
),
                       
                  
                  // HomeImage(onTap:(){
                    
                  // },image: 'images/test2.png',width: constraints.maxWidth,height:constraints.maxHeight*0.50,),
                 
                  _spacerSizedBox(),
                  _buildSeeAll('اقوي العروض', 'Best offers'),
                  _spacerSizedBox(),
                
                  SilderOffers(image:_controller.dataHome!.mobileSlider!.image!,),
                  _spacerSizedBox(),
                  _buildSeeAll(_controller.dataHome!.mobileFeatured!.nameAr!,  _controller.dataHome!.mobileFeatured!.nameEn!),
                  _spacerSizedBox(),
                  
                  ProductsListOnHome(products: _controller.dataHome!.mobileFeatured!.products!,),
                 _spacerSizedBox(),
                     HomeImage(onTap: () {},image: 'images/test3.png',width: constraints.maxWidth,height:160),
                  _spacerSizedBox(),
                  _buildSeeAll('اقوي عروض رمضان', 'The best Ramadan offers'),
                //  _spacerSizedBox(),
                 // const   ProductsListOnHome(),
                  _spacerSizedBox(),
                      HomeImage(onTap:(){},image: 'images/test2.png',width: constraints.maxWidth,height:160 ,),
                 _spacerSizedBox(),
                GridViewBannerHome(banner: _controller.dataHome!.multiBanner!,),
                ],
              );
*/
