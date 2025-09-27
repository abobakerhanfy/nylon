import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/cached_network_image.dart';
import 'package:nylon/features/favorites/presentation/screens/widgets/icon_add_favorite.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: must_be_immutable
class ProductImageSectionWidget extends StatefulWidget {
  final List<String> images;
  final String idProduct;
  const ProductImageSectionWidget(
      {super.key, required this.images, required this.idProduct});

  @override
  _ProductImageSectionWidgetState createState() =>
      _ProductImageSectionWidgetState();
}

class _ProductImageSectionWidgetState extends State<ProductImageSectionWidget> {
  final MyServices _myServices = Get.find();
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: _myServices.sharedPreferences.getString('Lang') == 'ar'
            ? Alignment.bottomLeft
            : Alignment.bottomRight,
        children: [
          Stack(
            alignment: _myServices.sharedPreferences.getString('Lang') == 'ar'
                ? Alignment.topLeft
                : Alignment.topRight,
            children: [
              CarouselSlider.builder(
                itemCount: widget.images.length,
                itemBuilder: (context, index, realIndex) {
                  final imageUrl = widget.images[index];
                  return Container(
                    height: 364,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.borderBlack28, width: 0.3),
                    ),
                    child: CachedNetworkImageWidget(
                      height: 364,
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 364,
                  autoPlay: widget.images.length >
                      1, // إيقاف التمرير التلقائي إذا كانت صورة واحدة
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _activeIndex = index;
                    });
                  },
                  enableInfiniteScroll: widget.images.length >
                      1, // إيقاف السحب إذا كانت صورة واحدة
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  children: [
                    FavoriteIcon(
                      idProduct: widget.idProduct,
                    ),
                    // GetBuilder<ControllerFavorites>(
                    //   init: ControllerFavorites(),
                    //   builder: (_controller) {
                    //     return _buildImageActionButton('images/fov.svg',
                    //     _controller.favoritesMap.containsKey(_)?Colors.red: Theme.of(context).scaffoldBackgroundColor

                    //      );
                    //   }
                    // ),
                    // const SizedBox(height: 16),
                    // _buildImageActionButton(null, Colors.black38,
                    //     icon: Icons.share_outlined),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AnimatedSmoothIndicator(
              effect: ExpandingDotsEffect(
                dotWidth: 10,
                dotHeight: 10,
                spacing: 8,
                expansionFactor: 3, // حجم التوسيع للنقطة الفعالة
                radius: 15,
                activeDotColor: AppColors.primaryColor,
                dotColor: Colors.black38,
              ),
              curve: Curves.easeInOut,
              activeIndex: _activeIndex,
              count: widget.images.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageActionButton(String? asset, Color color, {IconData? icon}) {
    return InkWell(
      onTap: () {},
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
          ),
          if (asset != null) SvgPicture.asset(asset, color: color),
          if (icon != null) Icon(icon, color: color),
        ],
      ),
    );
  }
}
