import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/languages/function_string.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/category/presentation/controller/controller_category.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/features/home/presentation/screens/widgets/products_container_home.dart';

class ViewcCategories extends StatefulWidget {
  const ViewcCategories({super.key});

  @override
  State<ViewcCategories> createState() => _ViewcCategoriesState();
}

class _ViewcCategoriesState extends State<ViewcCategories> {
//final controller  =  Get.lazyPut<ControllerCategory>(() => ControllerCategory());
  final _controller = Get.put(ControllerCategory());
  @override
  void initState() {
    _controller.updateCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: customAppBarTow(title: '67'.tr),
      body: GetBuilder<ControllerCategory>(builder: (controller) {
        return HandlingDataView(
            statusRequest: controller.statusRequest!,
            widget: Obx(() {
              final categories = controller.categories.value!.productsFeatured!;
              final selectedIndex = controller.selectedIndex.value;
              final selectedCategory = categories[selectedIndex];

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
                        final category = categories[i];
                        final isSelected = selectedIndex == i;
                        return InkWell(
                          onTap: () {
                            controller.selectedIndex.value = i;
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 54,
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.white,
                            child: Text(
                              translate(
                                category.nameAr ?? 'notName',
                                category.nameEn ?? 'NotName',
                              )!,
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
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  selectedCategory.products != null
                      ? Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 10),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              childAspectRatio: 0.50,
                            ),
                            itemCount: selectedCategory.products?.length ?? 0,
                            itemBuilder: (context, i) {
                              final product = selectedCategory.products![i];
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
                          ),
                        )
                      : Expanded(
                          child: Center(
                          child: Text('148'.tr),
                        ))
                ],
              );
            }),
            onRefresh: () {});
      }),
    );
  }
}
