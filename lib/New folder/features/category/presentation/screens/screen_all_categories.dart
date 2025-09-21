import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/languages/function_string.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';

import 'package:nylon/features/category/presentation/controller/controller_category.dart';
import 'package:nylon/features/home/presentation/screens/widgets/products_container_home.dart';

class ViewcCategories extends StatefulWidget {
  const ViewcCategories({super.key});

  @override
  State<ViewcCategories> createState() => _ViewcCategoriesState();
}

class _ViewcCategoriesState extends State<ViewcCategories> {
  final _controller = Get.put(ControllerCategory());
  Locale? _lastLocale;

  @override
  void initState() {
    super.initState();
    // نخلي أول نداء بعد ما الشجرة والـ locale يثبتوا
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.updateCategories();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // لو اللغة اتغيّرت أثناء العمل، أعد التحميل بنفس الشاشة
    final current = Localizations.localeOf(context);
    if (_lastLocale != current) {
      _lastLocale = current;
      _controller.updateCategories();
      // لو حابب ترجع لأول تصنيف وقت تغيّر اللغة:
      // _controller.selectedIndex.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: customAppBarTow(title: '67'.tr),
      body: GetBuilder<ControllerCategory>(
        builder: (controller) {
          return HandlingDataView(
            statusRequest: controller.statusRequest!,
            widget: Obx(() {
              final data = controller.categories.value;

              // حماية من null أو القوائم الفاضية
              final categories = data?.productsFeatured ?? [];
              if (categories.isEmpty) {
                return Center(child: Text('148'.tr)); // "لا توجد منتجات"
              }

              final selIndex = controller.selectedIndex.value
                  .clamp(0, categories.length - 1);
              final selectedCategory = categories[selIndex];

              final isAr = (Get.locale?.languageCode ?? 'ar')
                  .toLowerCase()
                  .startsWith('ar');

              // اختَر قائمة المنتجات المناسبة للّغة الحالية مع fallback
              final List productsForLang = () {
                final List ar = (selectedCategory.productsAr ?? []) as List;
                final List en = (selectedCategory.productsEn ?? []) as List;
                final List base = (selectedCategory.products ?? []) as List;

                if (isAr) {
                  if (ar.isNotEmpty) return ar;
                  if (base.isNotEmpty) return base;
                  return en;
                } else {
                  if (en.isNotEmpty) return en;
                  if (base.isNotEmpty) return base;
                  return ar;
                }
              }();

              return Row(
                children: [
                  // قائمة التصنيفات
                  Container(
                    width: 107,
                    color: Colors.white,
                    child: ListView.separated(
                      separatorBuilder: (context, i) => Divider(
                        height: 0.5,
                        thickness: 0.5,
                        color: AppColors.borderBlack28,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, i) {
                        final cat = categories[i];
                        final isSelected = selIndex == i;
                        return InkWell(
                          onTap: () => controller.selectedIndex.value = i,
                          child: Container(
                            alignment: Alignment.center,
                            height: 54,
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              translate(cat.nameAr ?? 'notName',
                                      cat.nameEn ?? 'NotName') ??
                                  'NotName',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                  ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // شبكة المنتجات
                  Expanded(
                    child: productsForLang.isNotEmpty
                        ? GridView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 10),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              childAspectRatio: 0.50,
                            ),
                            itemCount: productsForLang.length,
                            itemBuilder: (context, i) {
                              final product = productsForLang[i];
                              return ProductsContainerHome(
                                products: product,
                                onTap: () {
                                  Get.toNamed(NamePages.pOneProduct,
                                      arguments: product);
                                },
                                onTapFavorite: () {},
                                onTapCart: () {},
                              );
                            },
                          )
                        : Center(child: Text('148'.tr)), // لا توجد منتجات
                  )
                ],
              );
            }),
            onRefresh: () async {
              await _controller.updateCategories();
            },
          );
        },
      ),
    );
  }
}
