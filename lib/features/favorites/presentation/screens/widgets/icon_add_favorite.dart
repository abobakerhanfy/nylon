import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/features/favorites/presentation/controller/controller_favorites.dart';

class FavoriteIcon extends StatelessWidget {
  final String idProduct;
  const FavoriteIcon({
    super.key,
    required this.idProduct,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerFavorites>(
        init: ControllerFavorites(),
        builder: (controller) {
          return InkWell(
            onTap: () {
              controller.addOrRemoveFavorites(idProduct: idProduct);
            },
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Stack(alignment: Alignment.center, children: [
                Opacity(
                  opacity: 0.10,
                  child: CircleAvatar(
                      radius: 15,
                      backgroundColor:
                          controller.favoritesMap.containsKey(idProduct)
                              ? Colors.red[700]
                              : Theme.of(context).scaffoldBackgroundColor),
                ),
                Icon(Icons.favorite,
                    color: controller.favoritesMap.containsKey(idProduct)
                        ? Colors.red[700]
                        : Colors.black26)
              ]),
            ),
          );
        });
  }
}
