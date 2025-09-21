
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/static/static_images.dart';
import 'package:nylon/core/widgets/logo_widget.dart';

import '../../core/theme/colors_app.dart';
import 'package:animate_do/animate_do.dart';

class Bordering  extends StatefulWidget {
  const Bordering ({super.key});

  @override
  State<Bordering> createState() => _BorderingState();
}

class _BorderingState extends State<Bordering> {
  Timer? _timer;
  Duration  duration = const  Duration(seconds: 2);
  Future timerBordering()async {
print('start');
    _timer = Timer.periodic(const Duration(seconds:4), (timer) async {
      Get.offNamed(NamePages.pBottomBar);
    });

  }
  @override
  void initState() {
    timerBordering();
    super.initState();
  }

@override
  void dispose() {
    _timer!.cancel();
    print('end');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:BounceInRight(
        child:  SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: LayoutBuilder(
            builder: (context, boxSize) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(StaticAppImages.borderImage),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.1,
                        child: Container(
                          color: Colors.grey[400],
                          height: boxSize.maxHeight,
                          width: boxSize.maxWidth,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 90),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Bounce(
                          duration: duration,
                          child:logoWidget()
                        ),
                       Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child:  BounceInUp(
                                  duration: duration,
                                  child: Text(
                                    "13".tr,
                                    style: TextStyle(
                                      color: AppColors.textBorderColor,
                                      fontSize: 30,
                                      fontFamily: 'ar',
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),),
                              Center(
                                child: BounceInDown(
                                  duration: duration,
                                  child: Text(
                                    "14".tr,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(height: boxSize.maxHeight * 0.10),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}