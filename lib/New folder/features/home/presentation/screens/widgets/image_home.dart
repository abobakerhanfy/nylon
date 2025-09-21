
import 'package:flutter/material.dart';
import 'package:nylon/core/languages/function_string.dart';
import 'package:nylon/core/widgets/cached_network_image.dart';

// ignore: must_be_immutable
class HomeBigBanner extends StatelessWidget {
  final Function() onTap;
   String? imageAr;
    String? imageEn;

 HomeBigBanner({super.key, required this.onTap, this.imageAr,this.imageEn, });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap ,
      child:   CachedNetworkImageWidget(
        fit: BoxFit.fill,
          imageUrl: translate(imageAr, imageEn)!,
           width: MediaQuery.of(context).size.width*0.90, 
           height:MediaQuery.of(context).size.height*0.65,
           
            ),

    );
  }
}
