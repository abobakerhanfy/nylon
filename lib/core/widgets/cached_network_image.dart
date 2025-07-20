import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nylon/core/theme/colors_app.dart';

// ignore: must_be_immutable
class CachedNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  double? width, height;
  BoxFit? fit;
  CachedNetworkImageWidget(
      {super.key, required this.imageUrl, this.width, this.height, this.fit});
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholder: (context, url) => SizedBox(
          width: width,
          height: height,
          child: Center(
              child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ))),
      errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: Colors.red[900],
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'نعتذر تحميل الصوره !!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black45,
                    ),
              )
            ],
          )),
    );
  }
}
