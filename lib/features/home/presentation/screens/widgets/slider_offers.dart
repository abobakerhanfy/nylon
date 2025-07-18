import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/widgets/cached_network_image.dart';
import 'package:nylon/features/home/data/models/mobile_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../controller/home/controller_home_widget.dart';
import '../../../../../core/theme/colors_app.dart';

// ignore: must_be_immutable
class SilderOffers extends StatefulWidget {
  final List<ImageData> image;
  const SilderOffers({
    super.key,
    required this.image,
  });

  @override
  State<SilderOffers> createState() => _SilderOffersState();
}

class _SilderOffersState extends State<SilderOffers> {
  @override
  void initState() {
    widget.image.sort((a, b) => a.sortOrder!.compareTo(b.sortOrder!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerHomeWidget>(
        init: ControllerHomeWidget(),
        builder: (controllerWHome) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 180,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  options: CarouselOptions(
                    onPageChanged: (index, _) {
                      controllerWHome.onTapSlider(index);
                    },
                    aspectRatio: 10 / 5,
                    autoPlayInterval: const Duration(seconds: 3),
                    enlargeCenterPage: true,
                    autoPlay: true,
                  ),
                  items: widget.image.map((
                    i,
                  ) {
                    return CachedNetworkImageWidget(
                      imageUrl: i.image!,
                      fit: BoxFit.fill,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              AnimatedSmoothIndicator(
                  effect: SlideEffect(
                      dotWidth: 10,
                      dotHeight: 10,
                      spacing: 5,
                      radius: 15,
                      activeDotColor: AppColors.activeSlider,
                      dotColor: AppColors.unActiveSlider),
                  curve: Curves.easeInOut,
                  activeIndex: controllerWHome.indexSlider,
                  count: widget.image.length),
            ],
          );
        });
  }
}
