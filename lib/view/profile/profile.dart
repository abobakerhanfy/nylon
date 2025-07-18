import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nylon/controller/home/controller_home_widget.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/widgets/Profile/widgets.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/button_on_cart.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';
import 'package:nylon/features/notification/presentation/controller/controller_notification.dart';
import 'package:nylon/view/home/widgets.dart';

import '../../core/routes/name_pages.dart';

class Profile extends StatelessWidget {
  Profile({super.key});
  final MyServices _myServices = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(
          label: '20'.tr,
          isBack: false,
          onTap: () {
            ControllerHomeWidget controllerHomeWidget = Get.find();
            controllerHomeWidget.onTapBottomBar(2);
          }),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: LayoutBuilder(
          builder: (context, boxSize) {
            return ListView(
              children: [
                SizedBox(
                  height: boxSize.maxHeight * 0.02,
                ),
                if (!_myServices.userIsLogin())
                  ButtonOnCart(
                      width: double.infinity,
                      label: '${'22'.tr} / ${'23'.tr}',
                      onTap: () {
                        Get.toNamed(NamePages.pSignIn);
                      }),
                SizedBox(
                  height: boxSize.maxHeight * 0.02,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  // height: boxSize.maxHeight*0.76,
                  child: GridView(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, childAspectRatio: 2.5 / 3),
                    children: [
                      if (_myServices.userIsLogin())
                        ContainerProfileImage(
                            onTap: () {
                              Get.toNamed(NamePages.pMyprofile);
                            },
                            svg: 'images/profile.svg',
                            label: '201'.tr,
                            boxSize: boxSize),
                      ContainerProfileImage(
                          onTap: () {
                            Get.toNamed(NamePages.pMyOrders);
                          },
                          svg: 'images/test13.svg',
                          label: '30'.tr,
                          boxSize: boxSize),
                      ContainerProfileImage(
                          onTap: () {
                            // ControllerOrder _controller = Get.put(ControllerOrder());
                            // _controller.getReturnOrders();
                            Get.toNamed(NamePages.pReplacementAndReturn);
                          },
                          svg: 'images/test14.svg',
                          label: '31'.tr,
                          boxSize: boxSize),
                      ContainerProfileImage(
                          onTap: () {
                            Get.toNamed(NamePages.pViewBalance);
                          },
                          svg: 'images/test14.svg',
                          label: '32'.tr,
                          boxSize: boxSize),
                      ContainerProfileImage(
                          onTap: () {
                            Get.toNamed(NamePages.pMyCoupons);
                            //   Get.toNamed(NamePages.pFortuneWheel);
                            //  showDialog(
                            //      context: context,
                            //      builder:(context){
                            //        return  AlertDialog(

                            //          backgroundColor:Colors.white,
                            //          title:   SizedBox(
                            //            width: MediaQuery.of(context).size.width,
                            //            child:  const FortuneWheelPage(),
                            //          ),
                            //        );
                            //      });
                          },
                          svg: 'images/test17.svg',
                          label: '29'.tr,
                          boxSize: boxSize),
                      ContainerProfileImage(
                          onTap: () {
                            Get.toNamed(NamePages.pMyAddresses);
                          },
                          svg: 'images/test15.svg',
                          label: '28'.tr,
                          boxSize: boxSize),
                      ContainerProfileImage(
                          onTap: () {},
                          svg: 'images/test14.svg',
                          label: '27'.tr,
                          boxSize: boxSize),
                      ContainerProfileImage(
                          onTap: () {
                            Get.toNamed(NamePages.pLanguage);
                          },
                          svg: 'images/test16.svg',
                          label: '26'.tr,
                          boxSize: boxSize),
                      ContainerProfileImage(
                          onTap: () {
                            Get.toNamed(NamePages.pSendNumerOrder);
                          },
                          svg: 'images/test13.svg',
                          label: '82'.tr,
                          boxSize: boxSize),
                      ContainerProfileImage(
                          onTap: () {},
                          svg: '',
                          label: "202".tr,
                          boxSize: boxSize,
                          icon: Icons.star_outline),
                      ContainerProfileImage(
                        onTap: () async {
                          ControllerLogin controllerLogin = Get.find();
                          await controllerLogin.resetSession();

                          // ثم إعادة توجيه المستخدم لأول صفحة
                          Get.offAllNamed(NamePages.pFirst);
                        },
                        svg: '',
                        label: "203".tr,
                        boxSize: boxSize,
                        icon: Icons.login_outlined,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: boxSize.maxHeight * 0.02,
                ),
                SizedBox(
                  //  height: boxSize.minHeight*0.30,
                  width: boxSize.maxWidth,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RowSocialMediaApp(
                          onTapFacebook: () async {
                            ControllerNotifications c = Get.find();
                            Clipboard.setData(ClipboardData(text: c.token!));
                            ClipboardData? clipboardContent =
                                await Clipboard.getData('text/plain');
                            print('${clipboardContent!.text}');
                          },
                          onTapSnap: () {},
                          onTapInist: () {},
                          onTapTiktok: () {}),
                      const InformationAppOnProfile()
                    ],
                  ),
                ),
                SizedBox(
                  height: boxSize.maxHeight * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 45,
                        child: ButtonOnCart(
                          label: '25'.tr,
                          onTap: () {
                            //MyServices _myServices = Get.find();
                            // myServices.sharedPreferences.//'6352'
                            // _myServices.sharedPreferences.setString('UserId', '6352');
                            // _myServices.sharedPreferences.setString('Phone', '6352');
                          },
                          width: boxSize.maxWidth * 0.35,
                        )),
                    SizedBox(
                      width: boxSize.maxWidth * 0.08,
                    ),
                    SizedBox(
                        height: 45,
                        child: ButtonOnCart(
                          label: '24'.tr,
                          onTap: () {},
                          width: boxSize.maxWidth * 0.35,
                        )),
                  ],
                ),
                SizedBox(
                  height: boxSize.maxHeight * 0.02,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class InformationAppOnProfile extends StatelessWidget {
  const InformationAppOnProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '69'.tr,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Text('.'),
            Text(
              '70'.tr,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Text('.'),
            Text(
              '71'.tr,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '72'.tr,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '(109)122',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${"67".tr} 2024 ',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '73'.tr,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        )
      ],
    );
  }
}

class RowSocialMediaApp extends StatelessWidget {
  final Function() onTapFacebook;
  final Function() onTapSnap;
  final Function() onTapInist;
  final Function() onTapTiktok;

  const RowSocialMediaApp({
    super.key,
    required this.onTapFacebook,
    required this.onTapSnap,
    required this.onTapInist,
    required this.onTapTiktok,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTapFacebook,
          child: const CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage('images/facebook.png'),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        InkWell(
          onTap: onTapInist,
          child: const CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage('images/inist.png'),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        InkWell(
          onTap: onTapSnap,
          child: const CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage('images/snap.png'),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: onTapTiktok,
          child: const CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage('images/tiktok.png'),
          ),
        ),
      ],
    );
  }
}
/*
 Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ContainerProfileImage(onTap: (){}, svg: 'images/test13.svg', label: '30'.tr,boxSize:boxSize),
                          ContainerProfileImage(onTap: (){}, svg: 'images/test14.svg', label: '31'.tr,boxSize:boxSize),
                          ContainerProfileImage(onTap: (){}, svg: 'images/test14.svg', label: '32'.tr,boxSize:boxSize),
                        ],
                      ),
                      SizedBox(height: boxSize.maxHeight*0.03,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ContainerProfileImage(onTap: (){
                            //   Get.toNamed(NamePages.pFortuneWheel);
                            showDialog(
                                context: context,
                                builder:(context){
                                  return  AlertDialog(

                                    backgroundColor:Colors.white,
                                    title:   SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child:  const FortuneWheelPage(),
                                    ),
                                  );
                                });
                          }, svg: 'images/test17.svg', label: '29'.tr,boxSize:boxSize),
                          ContainerProfileImage(onTap: (){}, svg: 'images/test15.svg', label: '28'.tr,boxSize:boxSize),
                          ContainerProfileImage(onTap: (){}, svg: 'images/test14.svg', label: '27'.tr,boxSize:boxSize),
                        ],
                      ),
                      SizedBox(height: boxSize.maxHeight*0.03,),

                      ContainerProfileImage(onTap: (){
                        Get.toNamed(NamePages.pLanguage);
                      }, svg: 'images/test16.svg', label: '26'.tr,boxSize:boxSize),
                    ],
                  ),
                  //BOOTO OLD 
                  // SizedBox(
                        height: 45,
                          width: boxSize.maxWidth*0.35,
                          child:Container(
                            alignment: Alignment.center,

                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('24'.tr,style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white
                            )),
                          ),
                          //PrimaryButton(onTap: (){}, label:'24'.tr,)
                      )
 */
