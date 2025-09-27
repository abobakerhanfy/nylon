import 'package:flutter/material.dart';
import 'package:nylon/core/static/static_images.dart';

import '../../core/widgets/border/container_lang.dart';
import '../../core/widgets/logo_widget.dart';
import 'package:get/get.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: LayoutBuilder(builder: (context, boxSize) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(StaticAppImages.borderImage),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 90, bottom: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    logoWidget(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ContainerLang(
                            boxSize: boxSize, label: 'English', local: 'en'),
                        ContainerLang(
                            boxSize: boxSize, label: 'العربية', local: 'ar'),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
