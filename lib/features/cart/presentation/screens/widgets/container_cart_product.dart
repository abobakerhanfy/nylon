import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/widgets/cached_network_image.dart';
import 'package:nylon/features/cart/data/models/get_cart_model.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';

import '../../../../../../../core/languages/function_string.dart';
import '../../../../../../../core/theme/colors_app.dart';

class ContainerProductCart extends StatefulWidget {
  final Products products;
  final bool onCart;
  const ContainerProductCart(
      {super.key, required this.products, required this.onCart});

  @override
  State<ContainerProductCart> createState() => _ContainerProductCartState();
}

class _ContainerProductCartState extends State<ContainerProductCart> {
  final ControllerCart _controller = Get.find();
  late int originalQuantity;
  @override
  void initState() {
    originalQuantity = int.tryParse(widget.products.quantity ?? '1') ?? 1;
    super.initState();
  }

  Future<void> updateProductQuantity(int newQuantity) async {
    setState(() {
      if (newQuantity != originalQuantity) {
        _controller.editCartProduct(
            cartId: widget.products.cartId!, quantity: newQuantity);
        originalQuantity = newQuantity;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.products.cartId!), // مفتاح فريد لكل عنصر
      background: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.red[900], // لون الخلفية عند السحب
        alignment: Get.locale?.languageCode == 'ar'
            ? Alignment.centerLeft
            : Alignment.centerRight,

        child: Icon(Icons.delete,
            size: 30, color: Get.theme.scaffoldBackgroundColor),
        // أيقونة الحذف
      ),
      direction: DismissDirection.endToStart, // تحديد اتجاه السحب
      onDismissed: (direction) {
        _controller.addOrRemoveCart(
            idProduct: widget.products.productId!, quantity: originalQuantity);
      },
      child: InkWell(
        onTap: () {
          Get.toNamed(NamePages.pOneProduct, arguments: widget.products);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          width: 350,
          height: 110,
          decoration: BoxDecoration(
            color: (widget.products.name?.contains('***') == true ||
                    widget.products.stock == false)
                ? const Color.fromRGBO(255, 0, 0, 0.5) // أحمر شفاف
                : Get.theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8), // اختيارية لتحسين الشكل
          ),
          child: LayoutBuilder(builder: (context, boxSize) {
            return Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                  width: boxSize.minWidth * 0.30,
                  child: Center(
                    child: CachedNetworkImageWidget(
                      height: boxSize.minWidth * 0.30,
                      imageUrl: widget.products.image != null
                          ? widget.products.image!
                          : '',
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Image.network(widget.products.image!),
                ),
                SizedBox(
                  width: boxSize.maxWidth * 0.01,
                ),
                SizedBox(
                  width: boxSize.minWidth * 0.40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate(
                            widget.products.model, widget.products.model)!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        translate(widget.products.name, widget.products.name)!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.greyColor,
                            ),
                      ),
                      Text(
                        '66'.tr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.greyColor,
                            ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                    width: boxSize.minWidth * 0.27,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //'${widget.products.price! * widget.products.count} ${'11'.tr}'
                        Text(
                          (double.parse(widget.products.price!) *
                                  double.parse(widget.products.quantity!))
                              .toStringAsFixed(2),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.greyColor,
                                    fontSize: 14,
                                  ),
                        ),
                        const SizedBox(width: 4),
                        Image.asset(
                          "images/riyalsymbol_compressed.png",
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  int currentQuantity =
                                      int.tryParse(widget.products.quantity!) ??
                                          1;
                                  currentQuantity++;
                                  widget.products.quantity =
                                      currentQuantity.toString();
                                  updateProductQuantity(currentQuantity);
                                });
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: AppColors.primaryColor),
                                child: Icon(
                                  Icons.add,
                                  color: Get.theme.scaffoldBackgroundColor,
                                  size: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: Text(
                                widget.products.quantity!,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  int currentQuantity =
                                      int.tryParse(widget.products.quantity!) ??
                                          0;
                                  if (currentQuantity > 1) {
                                    currentQuantity--;
                                    widget.products.quantity =
                                        currentQuantity.toString();
                                    updateProductQuantity(currentQuantity);
                                  }
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: AppColors.primaryColor),
                                child: Text(
                                  '-',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
              ],
            );
          }),
        ),
      ),
    );
  }
}
