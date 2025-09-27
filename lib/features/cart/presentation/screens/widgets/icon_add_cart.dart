import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';

class CartIcon extends StatelessWidget {
  final String idProduct;
  const CartIcon({
    super.key,
    required this.idProduct,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerCart>(builder: (controller) {
      return InkWell(
        onTap: () async {
          await controller.addOrRemoveCart(idProduct: idProduct, quantity: 1);
        },
        child: Stack(alignment: Alignment.center, children: [
          Opacity(
            opacity: controller.cartMap.containsKey(idProduct) ? 1 : 0.10,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: controller.cartMap.containsKey(idProduct)
                  ? AppColors.primaryColor
                  : Colors.grey[400],
              //AppColors.backgroundO,
            ),
            //AppColors.primaryColor,
          ),
          SvgPicture.asset('images/addcart.svg',
              width: 16,
              color: controller.cartMap.containsKey(idProduct)
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Colors.black26),
        ]),
      );
    });
  }
}
