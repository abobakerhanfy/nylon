import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/widgets/cached_network_image.dart';
import 'package:nylon/core/languages/controllerLocale.dart';

import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/features/home/data/models/search_model.dart';
import 'package:nylon/features/home/presentation/controller/home_controller.dart';
import 'package:nylon/features/home/presentation/screens/view_all_widget_home.dart';
import 'package:nylon/core/function/method_GPUD.dart'; // فيه class Method
import 'package:flutter/foundation.dart';

// ✅ عدّل import حسب مكان الكنترولر عندك (المرفوع باسم controllerLocale.dart)
import 'package:nylon/core/services/services.dart';
// ✅ عدّل import حسب مكان MyServices عندك
// ✅ عدّل import حسب اسم كلاس الروابط عندك وملفها (أنت قلت عندك static const String serachProduct)
import 'package:nylon/core/url/url_api.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: fullAppBackgroundColor,
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
                    return const HomeViewAllWidget();
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

  // زرار مسح النص
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  // سهم الرجوع
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  // نتائج نهائية (لو المستخدم ضغط Enter/بحث)
  @override
  Widget buildResults(BuildContext context) {
    final q = query.trim();
    if (q.isEmpty) {
      return Center(child: Text("search_empty".tr));
    }
    return FutureBuilder<List<Products>>(
      future: searchPosts(q),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error '));
        }
        final results = snapshot.data ?? [];
        if (results.isEmpty) {
          return Center(child: Text("search_empty".tr));
        }
        return ProductSearchResults(products: results);
      },
    );
  }

  // الاقتراحات — تتحدث لحظيًا من أول حرف
  @override
  Widget buildSuggestions(BuildContext context) {
    final q = query.trim();

    // لو مفيش كتابة: رسالة إرشادية
    if (q.isEmpty) {
      return Container(
        color: Get.theme.scaffoldBackgroundColor,
        child: Center(child: Text("search_hint".tr)),
      );
    }

    // فيه كتابة حتى لو حرف واحد → نجيب نتائج مباشرة
    return FutureBuilder<List<Products>>(
      future: searchPosts(q),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("search_error".tr));
        }
        final results = snapshot.data ?? [];
        if (results.isEmpty) {
          return Center(child: Text("search_empty".tr));
        }
        return ProductSearchResults(products: results);
      },
    );
  }
}

Future<List<Products>> searchPosts(String q) async {
  if (q.isEmpty) return [];

  // Debounce بسيط علشان يقلل الطلبات وقت الكتابة
  await Future.delayed(const Duration(milliseconds: 250));

  // 1) اللغة
  String lang = 'en-gb';
  try {
    if (Get.isRegistered<ControllerLocal>()) {
      lang = Get.find<ControllerLocal>().apiLang; // 'ar' أو 'en-gb'
    } else {
      final my = Get.find<MyServices>();
      final sharedLang = my.sharedPreferences.getString('Lang') ?? 'en';
      lang = sharedLang.toLowerCase() == 'ar' ? 'ar' : 'en-gb';
    }
  } catch (_) {}

  // 2) التوكن
  final my = Get.find<MyServices>();
  final token = my.sharedPreferences.getString('api_token') ??
      my.sharedPreferences.getString('token') ??
      '';

  // 3) URL النهائي — زي أسلوبك بالظبط
  final url = '${AppApi.serachProduct}$token&lang=$lang';

  // 4) نفّذ POST أولاً (search في الـ body) — ده اللي السيرفر متوقعه
  final method = Get.find<Method>();
  if (kDebugMode) {
    debugPrint(
        '🔎 [SEARCH] (POST) q="$q" lang=$lang token=${token.isNotEmpty ? "SET" : "MISSING"}');
    debugPrint('🔎 [SEARCH] (POST) URL: $url  | body: {search: "$q"}');
  }

  final postResp = await method.postData(url: url, data: {'search': q});

  List<Products> parseProducts(Map<String, dynamic> data) {
    try {
      final searchModel = SearchModel.fromJson(data);
      return searchModel.products?.products ?? <Products>[];
    } catch (e) {
      if (kDebugMode) debugPrint('❌ [SEARCH] Parsing error: $e');
      return <Products>[];
    }
  }

  final postResult = postResp.fold<List<Products>>((failure) {
    if (kDebugMode) debugPrint('❌ [SEARCH] POST Failure: $failure');
    return <Products>[];
  }, (data) {
    if (kDebugMode) {
      final preview = data.toString();
      debugPrint(
          '🔎 [SEARCH] POST OK, preview: ${preview.length > 300 ? preview.substring(0, 300) : preview}');
    }
    return parseProducts(Map<String, dynamic>.from(data));
  });

  if (postResult.isNotEmpty) {
    if (kDebugMode) {
      debugPrint('✅ [SEARCH] Using POST results: ${postResult.length}');
    }
    return postResult;
  }

  // 5) Fallback: جرّب GET (search في الـ query) لو POST رجّع products:null
  final safeQ = Uri.encodeQueryComponent(q);
  final getUrl = '${AppApi.serachProduct}$token&lang=$lang&search=$safeQ';
  if (kDebugMode) {
    debugPrint('🟡 [SEARCH] Fallback GET → $getUrl');
  }

  final getResp = await method.getData(url: getUrl);

  final getResult = getResp.fold<List<Products>>((failure) {
    if (kDebugMode) debugPrint('❌ [SEARCH] GET Failure: $failure');
    return <Products>[];
  }, (data) {
    if (kDebugMode) {
      final preview = data.toString();
      debugPrint(
          '🔎 [SEARCH] GET OK, preview: ${preview.length > 300 ? preview.substring(0, 300) : preview}');
    }
    return parseProducts(data);
  });

  if (kDebugMode) debugPrint('🔚 [SEARCH] Final results: ${getResult.length}');
  return getResult;
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
            color: Get.theme.scaffoldBackgroundColor,
            margin: const EdgeInsets.all(10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: (product.thumb != null && product.thumb!.isNotEmpty)
                  ? CachedNetworkImageWidget(
                      imageUrl: product.thumb!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.image_not_supported),
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
