import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nylon/controller/home/controller_home_widget.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';
import 'package:nylon/core/theme/colors_app.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  void initState() {
    super.initState();

    // ✅ تأكد من وجود token أو إنشاؤه
    Get.find<ControllerLogin>().checkAndCreateToken();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerHomeWidget>(
      init: ControllerHomeWidget(),
      builder: (controller) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.indexBar,
            elevation: 16,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.black,
            unselectedItemColor: AppColors.textColor,
            showUnselectedLabels: true,
            onTap: (vale) {
              controller.onTapBottomBar(vale);
            },
            unselectedLabelStyle: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                    fontSize: 8,
                    color: Colors.red,
                    fontWeight: FontWeight.normal),
            selectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 8, color: Colors.red, fontWeight: FontWeight.normal),
            items: [
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(4),
                    child: SvgPicture.asset('images/home.svg'),
                  ),
                  label: '16'.tr),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SvgPicture.asset('images/cartigries.svg'),
                ),
                label: '17'.tr,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SvgPicture.asset('images/cart.svg'),
                ),
                label: '18'.tr,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SvgPicture.asset('images/fov.svg'),
                ),
                label: '19'.tr,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SvgPicture.asset('images/profile.svg'),
                ),
                label: '20'.tr,
              ),
            ],
          ),
          body: controller.screens.elementAt(controller.indexBar),
        );
      },
    );
  }
}
