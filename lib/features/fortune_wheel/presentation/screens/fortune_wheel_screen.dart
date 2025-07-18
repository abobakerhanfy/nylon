import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/login/dialog.dart';
import 'package:nylon/core/widgets/primary_button.dart';
import 'package:nylon/features/fortune_wheel/presentation/controller/controller_fortune.dart';
import 'package:nylon/features/home/presentation/controller/home_controller.dart';
import 'package:rxdart/rxdart.dart';

class FortuneWheelPage extends StatefulWidget {
  const FortuneWheelPage({super.key});

  @override
  State<FortuneWheelPage> createState() => _FortuneWheel();
}

class _FortuneWheel extends State<FortuneWheelPage> {
  final _selected = BehaviorSubject<int>();
  String value = '';
  List<String> _items = [];

  late ControllerFortune _controllerFortune;

  @override
  void initState() {
    super.initState();
    _controllerFortune = Get.find<ControllerFortune>();
    if (_controllerFortune.rewardModel?.data != null &&
        _controllerFortune.rewardModel!.data!.isNotEmpty) {
      _items = _controllerFortune.rewardModel!.data!
          .map((reward) => reward.name ?? '')
          .toList();
    }
  }

  @override
  void dispose() {
    _selected.close();
    super.dispose();
  }

  List<Color> generateColors(Color baseColor, int itemCount) {
    return List.filled(itemCount, baseColor);

    if (itemCount <= 1) {
      return [
        baseColor.withValues(
          red: (baseColor.r * 255.0).roundToDouble(),
          green: (baseColor.g * 255.0).roundToDouble(),
          blue: (baseColor.b * 255.0).roundToDouble(),
          alpha: 255.0,
        )
      ];
    }
    return List.generate(itemCount, (i) {
      double fraction = 4 + (i / (itemCount - 1)) * 6;
      double opacity = (fraction / 10).clamp(0.0, 1.0);
      return baseColor.withValues(
        red: (baseColor.r * 255.0).roundToDouble(),
        green: (baseColor.g * 255.0).roundToDouble(),
        blue: (baseColor.b * 255.0).roundToDouble(),
        alpha: opacity * 255.0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerHome>(builder: (controller) {
      return GetBuilder<ControllerFortune>(
        builder: (controller) {
          if (_items.isEmpty &&
              controller.rewardModel?.data != null &&
              controller.rewardModel!.data!.isNotEmpty) {
            _items = controller.rewardModel!.data!
                .map((reward) => reward.name ?? '')
                .toList();
          }

          return HandlingDataView(
            statusRequest: controller.statusRequestGet ?? StatusRequest.loading,
            onRefresh: () {
              _items.clear();
              _controllerFortune.getRewards();
            },
            widget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                          alignment: Alignment.center,
                          width: 75,
                          height: 38,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent[400],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("تخطي",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: Colors.white, fontSize: 14)),
                              const Icon(Icons.close,
                                  size: 19, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          width: 90,
                          height: 60,
                          child: Image.asset("images/logo.png",
                              fit: BoxFit.cover)),
                    ],
                  ),
                ),
                Text("فرصتك اليوم",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                Text("هدايا واكواد خصم تنتظرك!",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        )),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: FortuneWheel(
                      alignment: Alignment.center,
                      animateFirst: false,
                      selected: _selected.stream,
                      onAnimationEnd: () {
                        final selectedIndex = _selected.valueOrNull;
                        if (selectedIndex != null &&
                            selectedIndex < _items.length &&
                            _controllerFortune.rewardModel?.data != null) {
                          setState(() {
                            value = _items[selectedIndex];
                          });

                          final reward = _controllerFortune
                              .rewardModel?.data?[selectedIndex];
                          if (reward?.rewardId != null) {
                            _controllerFortune.addReward(
                                rewardId: reward!.rewardId!);
                          }
                        }
                      },
                      items: List.generate(
                        (_items.length < 2 ? 2 : _items.length),
                        (i) {
                          final item = _items.length < 2
                              ? (_items.isNotEmpty ? _items[0] : '')
                              : _items[i];
                          return FortuneItem(
                            style: FortuneItemStyle(
                              borderColor: Colors.black,
                              borderWidth: 1,
                              color: generateColors(
                                AppColors.primaryColor,
                                (_items.length < 2 ? 2 : _items.length),
                              )[i],
                            ),
                            child: Text(
                              item,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.white, fontSize: 17),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  height: 45,
                  child: _controllerFortune.statusRequestAddF ==
                          StatusRequest.loading
                      ? Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primaryColor))
                      : PrimaryButton(
                          onTap: () {
                            if (_controllerFortune.statusRequestAddF !=
                                StatusRequest.success) {
                              if (_items.isNotEmpty) {
                                _selected
                                    .add(Fortune.randomInt(0, _items.length));
                              }
                            } else {
                              newCustomDialog(
                                body: SizedBox(
                                  height: 40,
                                  child: PrimaryButton(
                                    label: 'موافق',
                                    onTap: () => Get.back(),
                                  ),
                                ),
                                title:
                                    'لا يمكنك المحاولة الآن \n لقد استنفدت محاولتك لهذا اليوم. يمكنك المحاولة مرة أخرى في يوم جديد.',
                                dialogType: DialogType.info,
                              );
                            }
                          },
                          label: 'جرب حظك',
                        ),
                ),
                const SizedBox(height: 10),
                Text(value,
                    style: const TextStyle(
                        fontSize: 20, fontFamily: 'ar', color: Colors.black)),
              ],
            ),
          );
        },
      );
    });
  }
}
