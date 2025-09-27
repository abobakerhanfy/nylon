import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nylon/controller/home/controller_home_widget.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/Profile/widgets.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/button_on_cart.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';
import 'package:nylon/features/notification/presentation/controller/controller_notification.dart';
import 'package:nylon/view/home/widgets.dart';
import 'package:http/http.dart' as http;
import '../../core/routes/name_pages.dart';
import 'package:nylon/core/url/url_api.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:nylon/core/widgets/login/dialog.dart';
import 'package:nylon/core/widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  Profile({super.key});
  final MyServices _myServices = Get.find();
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('TXT = ${Theme.of(context).textTheme.bodyMedium?.color}');
    return Scaffold(
      backgroundColor: fullAppBackgroundColor,
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
                      if (_myServices.userIsLogin())
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
                      if (_myServices.sharedPreferences.getString("UserId") !=
                          null)
                        ContainerProfileImage(
                          onTap: () async {
                            print("tr(215) => ${'215'.tr}");

                            newCustomDialog(
                              title: 'delete_account_title'.tr,
                              dialogType: DialogType.warning,
                              body: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: PrimaryButton(
                                      label: 'delete_account_cancel'.tr,
                                      onTap: () => Get.back(),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: PrimaryButton(
                                      label: 'delete_account_confirm'.tr,
                                      onTap: () async {
                                        Get.back(); // إغلاق الرسالة

                                        final String? customerId = _myServices
                                            .sharedPreferences
                                            .getString("customer_id");
                                        final String? phone = _myServices
                                                .sharedPreferences
                                                .getString("Phone") ??
                                            _myServices.sharedPreferences
                                                .getString("Phon_User");
                                        final token = _myServices
                                            .sharedPreferences
                                            .getString('token');

                                        if (token != null &&
                                            (customerId != null ||
                                                phone != null)) {
                                          final deleteUrl = Uri.parse(
                                              '${AppApi.deleteCustomer}$token');

                                          final response =
                                              await http.post(deleteUrl, body: {
                                            if (customerId != null)
                                              'customer_id': customerId,
                                            if (customerId == null &&
                                                phone != null)
                                              'telephone': phone,
                                          });

                                          if (response.statusCode == 200 &&
                                              response.body
                                                  .contains('success')) {
                                            await _myServices.sharedPreferences
                                                .clear();
                                            Get.offAllNamed(NamePages.pFirst);
                                          } else {
                                            newCustomDialog(
                                              title: 'delete_account_fail'.tr,
                                              dialogType: DialogType.error,
                                              body: PrimaryButton(
                                                label:
                                                    'delete_account_cancel'.tr,
                                                onTap: () => Get.back(),
                                              ),
                                            );
                                          }
                                        } else {
                                          newCustomDialog(
                                            title: 'delete_account_no_data'.tr,
                                            dialogType: DialogType.info,
                                            body: PrimaryButton(
                                              label: 'delete_account_cancel'.tr,
                                              onTap: () => Get.back(),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          svg: '',
                          icon: Icons.delete_forever,
                          label: '215'.tr,
                          boxSize: boxSize,
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
                        label: '25'.tr, // مثلاً: تواصل معنا
                        onTap: () => _launchUrl(
                          "https://www.nylonsa.com/index.php?route=information/contact",
                        ),
                        width: boxSize.maxWidth * 0.35,
                      ),
                    ),
                    SizedBox(
                      width: boxSize.maxWidth * 0.08,
                    ),
                    SizedBox(
                        height: 45,
                        child: ButtonOnCart(
                          label: '24'.tr,
                          onTap: () => _launchUrl(
                            "https://apps.apple.com/eg/app/%D9%86%D8%A7%D9%8A%D9%84%D9%88%D9%86-nylon-sa/id6748893786",
                          ),
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
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

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
            InkWell(
              onTap: () => _launchUrl(
                "https://www.nylonsa.com/index.php?route=information/information&information_id=6",
              ),
              child: Text(
                '69'.tr, // سياسة الارجاع
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
            const Text('.'),
            InkWell(
              onTap: () => _launchUrl(
                "https://www.nylonsa.com/index.php?route=information/information&information_id=3",
              ),
              child: Text(
                '70'.tr, // سياسة الخصوصية
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
            const Text('.'),
            InkWell(
              onTap: () => _launchUrl(
                "https://www.nylonsa.com/index.php?route=information/information&information_id=5",
              ),
              child: Text(
                '71'.tr, // اتفاقية المستخدم
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black,
                    ),
              ),
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
              '${"67".tr} 2025',
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
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => _launchUrl("https://www.facebook.com/nylonsaa"),
          child: const CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage('images/facebook.png'),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => _launchUrl("https://x.com/sa_nylon_?lang=ar"),
          child: const CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage('images/twitter.png'),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => _launchUrl("https://www.instagram.com/sa_nylon_"),
          child: const CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage('images/inist.png'),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => _launchUrl(
              "https://www.snapchat.com/@nylon_sa?share_id=KMX-o-hj0k8&locale=ar-AE"),
          child: const CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage('images/snap.png'),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => _launchUrl("https://www.tiktok.com/@nylon_sa"),
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

                                    backgroundColor:fullAppBackgroundColor
,
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
                              color: fullAppBackgroundColor

                            )),
                          ),
                          //PrimaryButton(onTap: (){}, label:'24'.tr,)
                      )
 */
