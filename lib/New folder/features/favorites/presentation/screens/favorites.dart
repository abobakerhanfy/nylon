import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/core/widgets/fovorite/container_items.dart';
import 'package:nylon/features/favorites/presentation/controller/controller_favorites.dart';
import 'package:nylon/features/favorites/presentation/screens/widgets/empty_favorite.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: customAppBarTow(title: '146'.tr),
      body: GetBuilder<ControllerFavorites>(builder: (controller) {
        return controller.statusRequestGetFav == StatusRequest.empty
            ? const EmptyFov()
            : HandlingDataView(
                statusRequest: controller.statusRequestGetFav!,
                widget: GetBuilder<ControllerFavorites>(builder: (controller) {
                  return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      separatorBuilder: (context, i) => const SizedBox(
                            height: 15,
                          ),
                      itemCount: controller.favorites!.products!.length ?? 0,
                      itemBuilder: (context, i) {
                        return FavoriteConatainerItems(
                          products: controller.favorites!.products![i],
                        );
                      });
                }),
                onRefresh: () {
                  controller.getFavorites();
                },
              );
      }),
    );
  }
}
